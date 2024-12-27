#!/bin/bash

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to find all Java files recursively
find_java_files() {
    find . -type f -name "*.java" ! -name "MainTest.java" ! -path "*/build/*" ! -path "*/.gradle/*"
}

# Cleanup function
cleanup() {
    echo -e "${BLUE}Cleaning up build and src directories...${NC}"
    rm -rf build src gradle .gradle gradlew gradlew.bat build.gradle
}

# Main process
run_tests() {
    # Ensure directories exist before processing
    mkdir -p src/main/java
    mkdir -p src/test/java

    # Copy the test file
    cp MainTest.java src/test/java/MainTest.java




    # Process each Java file
    for file in $(find_java_files); do
        echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo -e "${GREEN}Processing file: $file${NC}"

        # Copy the renamed file to the target directory
        cp "$file" src/main/java/Main.java

        # Create build.gradle
        cat > build.gradle << 'EOL'
plugins {
    id 'java'
    id 'jacoco'
}

repositories {
    mavenCentral()
}

dependencies {
    testImplementation 'org.junit.jupiter:junit-jupiter-api:5.9.2'
    testRuntimeOnly 'org.junit.jupiter:junit-jupiter-engine:5.9.2'
}

test {
    useJUnitPlatform()
    finalizedBy jacocoTestReport

    testLogging {
        events "passed", "skipped", "failed"
        showExceptions true
        showCauses true
        showStackTraces true

        afterTest { desc, result ->
            println "${desc.className} > ${desc.name} [${result.resultType}]"
        }

        afterSuite { desc, result ->
            if (!desc.parent) {
                println "\nTest Results Summary"
                println "==================="
                println "Total tests run: ${result.testCount}"
                println "Successful: ${result.successfulTestCount}"
                println "Failed: ${result.failedTestCount}"
                println "Skipped: ${result.skippedTestCount}"
                println "==================="
            }
        }
    }
}

jacocoTestReport {
    reports {
        csv.required = true
        html.required = false
    }

    doLast {
        def coverageFile = new File("${buildDir}/reports/jacoco/test/jacocoTestReport.csv")
        if (coverageFile.exists()) {
            println "\nCode Coverage Summary"
            println "==================="

            def lines = coverageFile.readLines()
            if (lines.size() > 1) {
                def data = lines[1].split(',')
                if (data.length >= 11) {
                    def missedInstructions = Integer.parseInt(data[3])
                    def totalInstructions = Integer.parseInt(data[4])
                    def instructionsCoverage = ((totalInstructions - missedInstructions) * 100.0 / totalInstructions)
                    println "Instructions covered: ${String.format('%.2f', instructionsCoverage)}%"

                    def missedBranches = Integer.parseInt(data[5])
                    def totalBranches = Integer.parseInt(data[6])
                    def branchesCoverage = totalBranches > 0 ?
                        ((totalBranches - missedBranches) * 100.0 / totalBranches) : 100.0
                    println "Branches covered: ${String.format('%.2f', branchesCoverage)}%"

                    def missedLines = Integer.parseInt(data[7])
                    def totalLines = Integer.parseInt(data[8])
                    def linesCoverage = ((totalLines - missedLines) * 100.0 / totalLines)
                    println "Lines covered: ${String.format('%.2f', linesCoverage)}%"

                    def missedMethods = Integer.parseInt(data[9])
                    def totalMethods = Integer.parseInt(data[10])
                    def methodsCoverage = ((totalMethods - missedMethods) * 100.0 / totalMethods)
                    println "Methods covered: ${String.format('%.2f', methodsCoverage)}%"
                }
            }
            println "==================="
        } else {
            println "Jacoco execution data not found."
        }
    }
}
EOL

        # Create Gradle wrapper and run tests
        gradle wrapper
        ./gradlew test jacocoTestReport

        # Cleanup after each test
        cleanup
        # Recreate necessary directories for the next iteration
        mkdir -p src/main/java
        mkdir -p src/test/java
        cp MainTest.java src/test/java/MainTest.java
    done
}

# Start the script
echo -e "${GREEN}Starting Java code testing...${NC}"

# Run the Python script to rename classes
python3 rename.py

# Proceed with the renamed files
run_tests

# Final cleanup
echo -e "${GREEN}All tests completed.${NC}"
cleanup
