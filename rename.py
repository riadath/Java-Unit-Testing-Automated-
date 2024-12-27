import os
import re

def find_java_files():
    """
    Recursively find all Java files in the current directory.
    Exclude test files and build-related paths.
    """
    java_files = []
    for root, _, files in os.walk("."):
        for file in files:
            if file.endswith(".java") and "MainTest.java" not in file and "build" not in root and ".gradle" not in root:
                java_files.append(os.path.join(root, file))
    return java_files

def rename_class_to_main(file_path):
    """
    Replace the public class name in a Java file with 'Main' and update all references.
    """
    with open(file_path, 'r') as f:
        content = f.read()

    # Match the public class name
    match = re.search(r'public class ([A-Za-z0-9_]+)', content)
    if not match:
        print(f"Could not find public class in {file_path}")
        return

    original_class_name = match.group(1)
    print(f"Renaming class {original_class_name} in {file_path}")

    # Replace all occurrences of the original class name with "Main"
    updated_content = re.sub(rf'\b{original_class_name}\b', "Main", content)

    # Overwrite the file with the modified content
    with open(file_path, 'w') as f:
        f.write(updated_content)

def main():
    java_files = find_java_files()
    print(java_files)
    for file_path in java_files:
        rename_class_to_main(file_path)

if __name__ == "__main__":
    main()