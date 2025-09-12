#!/bin/bash

# WorldTool launcher script  
# Laptop-friendly defaults with professional argument handling

# Standard directory resolution
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Usage function
usage() {
    echo "world.sh - World information generator launcher"
    echo ""
    echo "Usage:"
    echo "  $0 [options]"
    echo ""
    echo "Java Options:"
    echo "  -Xmx<memory>      Set maximum heap size (default: 512m)"
    echo "  -Xms<memory>      Set initial heap size (default: 256m)"
    echo "  -ea               Enable assertions (default)"
    echo "  -da               Disable assertions"
    echo ""
    echo "Tool Options:"
    echo "  --verbose, -v     Enable verbose output"
    echo "  --help, -h        Show tool help"
    echo ""
    echo "Launcher Options:"
    echo "  --launcher-help   Show this launcher help"
    echo ""
    echo "Examples:"
    echo "  $0                           # Display world information"
    echo "  $0 --verbose                 # Verbose world information"
    echo "  $0 -Xmx1g                   # World info with 1GB heap"
}

# Laptop-friendly defaults
XMX="-Xmx512m"      # 512MB max heap
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

# Verify Java is available
if ! command -v java &> /dev/null; then
    echo "❌ Error: java not found. Please install Java Runtime Environment (JRE)."
    exit 1
fi

# Verify compiled classes exist
if [ ! -f "$DIR/world/WorldTool.class" ]; then
    echo "❌ Error: WorldTool.class not found. Please run compile.sh first."
    echo "   sh compile.sh"
    exit 1
fi

# Also verify cross-package dependency
if [ ! -f "$DIR/hello/HelloUtils.class" ]; then
    echo "❌ Error: HelloUtils.class not found. WorldTool depends on hello package."
    echo "   sh compile.sh"
    exit 1
fi

# Set classpath
CLASSPATH="$DIR"

# Show execution details if verbose
if [ "$VERBOSE" = true ]; then
    echo "🌍 HelloWorld WorldTool Launcher"
    echo "   Directory: $DIR"
    echo "   Classpath: $CLASSPATH" 
    echo "   Memory: $XMS $XMX"
    echo "   Assertions: $EA"
    echo "   Tool args: ${TOOL_ARGS[*]}"
    echo ""
fi

# Execute the tool
java $XMS $XMX $EA -cp "$CLASSPATH" world.WorldTool "${TOOL_ARGS[@]}"

# Capture exit code
EXIT_CODE=$?

# Provide helpful error messages for common issues
if [ $EXIT_CODE -ne 0 ]; then
    echo "" >&2
    echo "🔧 Troubleshooting:" >&2
    case $EXIT_CODE in
        1)
            echo "   • Check command-line arguments with --help" >&2
            echo "   • Verify all required classes are compiled" >&2
            ;;
        134)
            echo "   • Assertion failure detected" >&2
            echo "   • Try running with -da to disable assertions" >&2
            echo "   • Check that cross-package dependencies are satisfied" >&2
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