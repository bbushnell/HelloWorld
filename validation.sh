#!/bin/bash
# validation.sh - Common validation functions for HelloWorld project
# Provides defensive programming utilities for shell scripts
# Version 1.0

# Colors for output (if terminal supports them)
if [[ -t 2 ]]; then
    RED='\033[0;31m'
    YELLOW='\033[1;33m'
    GREEN='\033[0;32m'
    NC='\033[0m' # No Color
else
    RED=''
    YELLOW=''
    GREEN=''
    NC=''
fi

# Validation Functions

# Validates Java installation and version compatibility
validate_java_version() {
    local min_version=${1:-8}

    if ! command -v java &> /dev/null; then
        echo -e "${RED}❌ Error: Java not found${NC}" >&2
        echo "Please install Java Development Kit (JDK) $min_version or higher." >&2
        echo "Download from: https://adoptium.net/" >&2
        return 1
    fi

    if ! command -v javac &> /dev/null; then
        echo -e "${RED}❌ Error: Java compiler (javac) not found${NC}" >&2
        echo "Please install Java Development Kit (JDK), not just JRE." >&2
        echo "Download from: https://adoptium.net/" >&2
        return 1
    fi

    # Extract Java version
    local java_version
    java_version=$(java -version 2>&1 | head -1 | cut -d'"' -f2)

    # Parse major version (handle both 1.8.x and 11+ formats)
    local major_version
    if [[ "$java_version" =~ ^1\.([0-9]+) ]]; then
        major_version=${BASH_REMATCH[1]}
    elif [[ "$java_version" =~ ^([0-9]+) ]]; then
        major_version=${BASH_REMATCH[1]}
    else
        echo -e "${YELLOW}⚠️  Warning: Could not parse Java version: $java_version${NC}" >&2
        return 0  # Allow execution with warning
    fi

    if [ "$major_version" -lt "$min_version" ]; then
        echo -e "${RED}❌ Error: Java $min_version or higher required (found: $java_version)${NC}" >&2
        echo "Please update your Java installation." >&2
        return 1
    fi

    return 0
}

# Validates that a file exists and is readable
validate_file_exists() {
    local file="$1"
    local description="${2:-file}"

    if [ -z "$file" ]; then
        echo -e "${RED}❌ Error: No file path provided to validate_file_exists${NC}" >&2
        return 1
    fi

    if [ ! -f "$file" ]; then
        echo -e "${RED}❌ Error: Required $description not found: $file${NC}" >&2
        echo "Please ensure the file exists and is accessible." >&2
        return 1
    fi

    if [ ! -r "$file" ]; then
        echo -e "${RED}❌ Error: Cannot read $description: $file${NC}" >&2
        echo "Please check file permissions." >&2
        return 1
    fi

    return 0
}

# Validates that a directory exists and is writable
validate_directory_writable() {
    local dir="$1"
    local description="${2:-directory}"

    if [ -z "$dir" ]; then
        echo -e "${RED}❌ Error: No directory path provided to validate_directory_writable${NC}" >&2
        return 1
    fi

    if [ ! -d "$dir" ]; then
        echo -e "${RED}❌ Error: $description does not exist: $dir${NC}" >&2
        echo "Please create the directory or check the path." >&2
        return 1
    fi

    if [ ! -w "$dir" ]; then
        echo -e "${RED}❌ Error: Cannot write to $description: $dir${NC}" >&2
        echo "Please check directory permissions." >&2
        return 1
    fi

    return 0
}

# Validates that a directory exists (read-only check)
validate_directory_exists() {
    local dir="$1"
    local description="${2:-directory}"

    if [ -z "$dir" ]; then
        echo -e "${RED}❌ Error: No directory path provided to validate_directory_exists${NC}" >&2
        return 1
    fi

    if [ ! -d "$dir" ]; then
        echo -e "${RED}❌ Error: Required $description not found: $dir${NC}" >&2
        echo "Please ensure the directory exists and is accessible." >&2
        return 1
    fi

    if [ ! -r "$dir" ]; then
        echo -e "${RED}❌ Error: Cannot read $description: $dir${NC}" >&2
        echo "Please check directory permissions." >&2
        return 1
    fi

    return 0
}

# Validates that required compiled classes exist
validate_compiled_classes() {
    local project_dir="$1"
    shift  # Remove project_dir from arguments

    if [ -z "$project_dir" ]; then
        echo -e "${RED}❌ Error: No project directory provided to validate_compiled_classes${NC}" >&2
        return 1
    fi

    local missing_classes=()

    for class_file in "$@"; do
        if [ ! -f "$project_dir/$class_file" ]; then
            missing_classes+=("$class_file")
        fi
    done

    if [ ${#missing_classes[@]} -gt 0 ]; then
        echo -e "${RED}❌ Error: Missing compiled classes:${NC}" >&2
        for class in "${missing_classes[@]}"; do
            echo "  $class" >&2
        done
        echo "Please run 'sh compile.sh' first to compile the project." >&2
        return 1
    fi

    return 0
}

# Validates memory specification format
validate_memory_spec() {
    local memory_spec="$1"

    if [ -z "$memory_spec" ]; then
        return 0  # Empty is okay, will use default
    fi

    if [[ ! "$memory_spec" =~ ^-Xmx[0-9]+[kmgKMG]?$ ]]; then
        echo -e "${RED}❌ Error: Invalid memory specification: $memory_spec${NC}" >&2
        echo "Use format: -Xmx<size>[k|m|g] (e.g., -Xmx2g, -Xmx512m)" >&2
        return 1
    fi

    return 0
}

# Validates project directory structure
validate_project_structure() {
    local project_dir="$1"

    if [ -z "$project_dir" ]; then
        project_dir="$(pwd)"
    fi

    local required_dirs=("api" "reports")
    local required_files=("README.md" "compile.sh")

    # Check required directories
    for dir in "${required_dirs[@]}"; do
        if ! validate_directory_exists "$project_dir/$dir" "$dir directory"; then
            return 1
        fi
    done

    # Check required files
    for file in "${required_files[@]}"; do
        if ! validate_file_exists "$project_dir/$file" "$file"; then
            return 1
        fi
    done

    return 0
}

# Creates directory if it doesn't exist
ensure_directory() {
    local dir="$1"
    local description="${2:-directory}"

    if [ -z "$dir" ]; then
        echo -e "${RED}❌ Error: No directory path provided to ensure_directory${NC}" >&2
        return 1
    fi

    if [ ! -d "$dir" ]; then
        if ! mkdir -p "$dir" 2>/dev/null; then
            echo -e "${RED}❌ Error: Cannot create $description: $dir${NC}" >&2
            echo "Please check parent directory permissions." >&2
            return 1
        fi
        echo -e "${GREEN}✅ Created $description: $dir${NC}" >&2
    fi

    return 0
}

# Validates that output path is writable
validate_output_path() {
    local output_path="$1"
    local description="${2:-output file}"

    if [ -z "$output_path" ]; then
        return 0  # stdout output is okay
    fi

    local output_dir
    output_dir=$(dirname "$output_path")

    if ! validate_directory_exists "$output_dir" "output directory"; then
        # Try to create the directory
        if ! ensure_directory "$output_dir" "output directory"; then
            return 1
        fi
    fi

    # Check if we can write to the directory
    if ! validate_directory_writable "$output_dir" "output directory"; then
        return 1
    fi

    # If file exists, check if it's writable
    if [ -f "$output_path" ] && [ ! -w "$output_path" ]; then
        echo -e "${RED}❌ Error: Cannot overwrite existing $description: $output_path${NC}" >&2
        echo "Please check file permissions or choose a different output path." >&2
        return 1
    fi

    return 0
}

# Comprehensive validation for HelloWorld tools
validate_helloworld_environment() {
    local project_dir="$1"

    if [ -z "$project_dir" ]; then
        project_dir="$(pwd)"
    fi

    echo "🔍 Validating HelloWorld environment..."

    # Java validation
    if ! validate_java_version 8; then
        return 1
    fi

    # Project structure validation
    if ! validate_project_structure "$project_dir"; then
        return 1
    fi

    echo -e "${GREEN}✅ Environment validation passed${NC}"
    return 0
}