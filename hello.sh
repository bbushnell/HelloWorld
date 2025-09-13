#!/bin/bash

# HelloTool launcher script
# Laptop-friendly defaults with professional argument handling

# Standard directory resolution
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
    echo "hello.sh - Professional greeting generator launcher"
    echo ""
    echo "Usage:"
    echo "  $0 [name] [options]"
    echo ""
    echo "Arguments:"
    echo "  name              Name to greet (default: World)"
    echo ""
    echo "Java Options:"
    echo "  -Xmx<memory>      Set maximum heap size (default: 512m)"
    echo "  -Xms<memory>      Set initial heap size (default: 256m)"
    echo "  -ea               Enable assertions (default)"
    echo "  -da               Disable assertions"
    echo ""
    echo "Tool Options:"
    echo "  --name=<name>     Specify name explicitly"  
    echo "  --verbose, -v     Enable verbose output"
    echo "  --help, -h        Show tool help"
    echo ""
    echo "Launcher Options:"
    echo "  --launcher-help   Show this launcher help"
    echo ""
    echo "Examples:"
    echo "  $0                           # Hello, World!"
    echo "  $0 Alice                     # Hello, Alice!"
    echo "  $0 --name=Bob --verbose      # Verbose greeting for Bob"
    echo "  $0 Charlie -Xmx1g           # Greeting with 1GB heap"
}

# Laptop-friendly defaults (not cluster-scale)
XMX="-Xmx512m"      # 512MB max heap - reasonable for laptops
XMS="-Xms256m"      # 256MB initial heap
EA="-ea"            # Enable assertions by default
VERBOSE=false

# Parse launcher-specific arguments
TOOL_ARGS=()
for arg in "$@"; do
    case "$arg" in
        --launcher-help)
            usage
            exit 0
            ;;
        -Xmx*)
            XMX="$arg"
            ;;
        -Xms*)
            XMS="$arg"
            ;;
        -ea)
            EA="-ea"
            ;;
        -da)
            EA="-da"
            ;;
        --verbose|-v)
            VERBOSE=true
            TOOL_ARGS+=("$arg")
            ;;
        *)
            # Pass everything else to the tool
            TOOL_ARGS+=("$arg")
            ;;
    esac
done

# Comprehensive validation
validate_java_version 8 || exit 1
validate_compiled_classes "$DIR" "hello/HelloTool.class" || exit 1

# Validate memory specifications
for arg in "$@"; do
    case "$arg" in
        -Xmx*|-Xms*)
            validate_memory_spec "$arg" || exit 1
            ;;
    esac
done

# Set classpath
CLASSPATH="$DIR"

# Show execution details if verbose
if [ "$VERBOSE" = true ]; then
    echo "🚀 HelloWorld Launcher"
    echo "   Directory: $DIR" 
    echo "   Classpath: $CLASSPATH"
    echo "   Memory: $XMS $XMX"
    echo "   Assertions: $EA"
    echo "   Tool args: ${TOOL_ARGS[*]}"
    echo ""
fi

# Execute the tool
java $XMS $XMX $EA -cp "$CLASSPATH" hello.HelloTool "${TOOL_ARGS[@]}"

# Capture exit code
EXIT_CODE=$?

# Provide helpful error messages for common issues
if [ $EXIT_CODE -ne 0 ]; then
    echo "" >&2
    echo "🔧 Troubleshooting:" >&2
    case $EXIT_CODE in
        1)
            echo "   • Check command-line arguments with --help" >&2
            echo "   • Verify input parameters are valid" >&2
            ;;
        134)
            echo "   • Assertion failure detected" >&2
            echo "   • Try running with -da to disable assertions" >&2
            echo "   • Check that inputs meet validation requirements" >&2
            ;;
        137)
            echo "   • Process killed, likely out of memory" >&2
            echo "   • Try increasing heap size with -Xmx1g or similar" >&2
            ;;
        *)
            echo "   • Unexpected error occurred" >&2
            echo "   • Run with --verbose for more details" >&2
            ;;
    esac
fi

exit $EXIT_CODE