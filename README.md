# Java Testing Automation Process

## Overview
This repository contains scripts to automate the testing process for Java files. The automation process ensures all Java files are tested individually by renaming their public class and references to "Main," compiling, and running them with a single test file (`MainTest.java`). This setup is designed for projects where Java files are tested independently against a single unit test.

## Nomeclature
- When refering to `MainTest.jav` I am referring to the file that contains the unit tests for the Java files.
- When refering to `Main.java` I am referring to the file that contains the main code that is being tested.

## Importatn Notes
- Ensure `MainTest.java` is the only test file in the directory, and it **must** be named exactly `MainTest.java` for the script to work correctly. This file is assumed to contain the necessary unit tests for all Java files.
- All other Java files can have arbitrary names and can be located anywhere within the directory or its subdirectories; they will be processed and renamed automatically.
- If you encounter permission issues on Linux/Mac, make the script executable using:
  ```bash
  chmod +x script.sh
  ```

- The Main.java and MainTest.java file should be self contained and should not import any other classes from other files. This is to ensure that the script works correctly.If you do need to use a class from your main code in the MainTest.java you can declare them as public static class and access them directly through the `Main` class. For example, if the `MainTest.java` class needs to use a class defined in `Main.java` you can declare the class in `Main.java` as `public static class ClassName` and access it in `MainTest.java` as `Main.ClassName`.

## Requirements
Before running the scripts, ensure the following dependencies are installed:

1. **Python** (Version 3.6 or later)
   - Installation guide: [Python Downloads](https://www.python.org/downloads/)

2. **Gradle** (Version 7.0 or later)
   - Installation guide: [Gradle Downloads](https://gradle.org/releases/)

## Directory Structure
The directory structure can look like this before running the script:
```
.
├── MainTest.java         # Your single unit test file (mandatory, must be named exactly `MainTest.java`)
├── rename.py            # Python script for renaming classes
├── script.sh            # Bash script to run the automation
├── File1.java           # Example Java file
├── File2.java           # Another example Java file
├── Subdirectory/        # Optional subdirectory with Java files
│   ├── File3.java
│   └── File4.java
```

## How It Works
1. **Renaming Classes:**
   - The `rename.py` script finds all Java files in the directory and its subdirectories (excluding `MainTest.java` and files in build-related directories) and renames the public class in each file to `Main`.
   - All references to the original class name within the file are updated to `Main`.

2. **Testing Each File:**
   - The `script.sh` script processes each Java file individually by copying it to `src/main/java/Main.java` and the test file to `src/test/java/MainTest.java`.
   - Gradle is used to build and test the file using the provided `MainTest.java`.

3. **Code Coverage Report:**
    - The code coverage reports are currently not correctly generated due to the limitations of the script. Use the script mainly for testing the unit tests.
    - I would highly recommend using "Intellij IDE"'s built in code coverage tool.

4. **Cleanup:**
   - After testing each file, the temporary build and source directories are cleaned up to prepare for the next file.

## Installation and Setup
### Windows
1. Install Python:
   - Download and install Python from [Python Downloads](https://www.python.org/downloads/).
   - Add Python to your system's PATH during installation.

2. Install Gradle:
   - Download Gradle from [Gradle Downloads](https://gradle.org/releases/).
   - Extract the archive and add the `bin` directory to your system's PATH.

3. Run the Scripts:
   - Open Command Prompt or PowerShell.
   - Navigate to the project directory.
   - Run the following command:
     ```bash
     bash script.sh
     ```
   - Alternatively, if you have a shell emulator installed (e.g., Git Bash), you can run:
     ```bash
     ./script.sh
     ```

### Linux/Mac
1. Install Python:
   - Use the package manager for your system (e.g., `apt`, `yum`, `brew`) to install Python:
     ```bash
     sudo apt install python3  # For Ubuntu/Debian
     brew install python       # For macOS
     ```

2. Install Gradle:
   - Use the package manager or manual installation:
     ```bash
     sudo apt install gradle  # For Ubuntu/Debian
     brew install gradle      # For macOS
     ```

3. Run the Scripts:
   - Open a terminal.
   - Navigate to the project directory.
   - Run the following command:
     ```bash
     ./script.sh
     ```



## Output
The script provides:
- Test results for each file, including passed, failed, and skipped tests.

## Final Cleanup
After all tests are completed, the script cleans up the generated directories and files to maintain a clean workspace.

