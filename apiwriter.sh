#!/bin/bash
# ApiWriter Shell Wrapper v1.0
# Professional API documentation generation for Java projects
# Follows HelloWorld project shell script patterns

# Standard directory resolution (BBTools pattern)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source validation functions
if [ -f "$DIR/validation.sh" ]; then
    source "$DIR/validation.sh"
else
    echo "❌ Error: validation.sh not found. Required for proper validation."
    exit 1
fi

# Usage function
usage() {
    echo "ApiWriter v1.0 - Generate .api documentation from Java source"
    echo ""
    echo "Usage: $0 <input> [output] [options]"
    echo ""
    echo "  input   - Java file (.java) or package directory"
    echo "  output  - Output .api file (optional, defaults to stdout)"
    echo ""
    echo "Examples:"
    echo "  $0 hello/HelloTool.java api/HelloTool.api"
    echo "  $0 hello/ api/package_hello.api"
    echo "  $0 world/"
    echo ""
    echo "Options:"
    echo "  --help    Show this help"
    echo "  -Xmx<mem> Set memory (e.g., -Xmx2g)"
    echo "  --verbose Show detailed error information"
}

# Check for help
if [ "$1" = "--help" ] || [ "$1" = "-h" ] || [ $# -eq 0 ]; then
    usage
    exit 0
fi

# Comprehensive validation
validate_java_version 8 || exit 1
validate_compiled_classes "$DIR" "tools/ApiWriter.class" || exit 1

# Validate input path
if [ ! -e "$1" ]; then
    echo "Error: Input path does not exist: $1" >&2
    exit 1
fi

# Validate output path if provided
if [ -n "$2" ]; then
    validate_output_path "$2" "API output file" || exit 1
fi

# Memory management (laptop-friendly defaults)
XMX="-Xmx512m"
VERBOSE=""

# Parse memory and verbose flags from all arguments
for arg in "$@"; do
    case $arg in
        -Xmx*)
            validate_memory_spec "$arg" || exit 1
            XMX="$arg"
            ;;
        --verbose|-v) VERBOSE="--verbose" ;;
    esac
done

# Build classpath (current directory contains all compiled classes)
CLASSPATH="$DIR"

# Execute ApiWriter with proper error handling
if ! java $XMX -ea -cp "$CLASSPATH" tools.ApiWriter "$1" "$2" $VERBOSE; then
    echo "Error: API generation failed for input: $1" >&2
    echo "Ensure the input is a valid Java file or package directory." >&2
    exit 1
fi