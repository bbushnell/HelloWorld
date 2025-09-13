#!/bin/bash

# HelloWorld compile script
# Professional Java compilation with comprehensive validation

# Standard directory resolution
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source validation functions
if [ -f "$DIR/validation.sh" ]; then
    source "$DIR/validation.sh"
else
    echo "❌ Error: validation.sh not found. Required for proper compilation validation."
    exit 1
fi

echo "HelloWorld Compiler v1.0"
echo "========================"

# Comprehensive environment validation
if ! validate_helloworld_environment "$DIR"; then
    exit 1
fi

echo "📁 Project directory: $DIR"

# Compile all Java files in packages
echo "🔨 Compiling Java source files..."

# Find and compile all .java files in package directories
JAVA_FILES=$(find "$DIR" \( -path "*/hello/*" -o -path "*/world/*" -o -path "*/tools/*" \) -name "*.java")

if [ -z "$JAVA_FILES" ]; then
    echo "❌ No Java source files found in hello/, world/, or tools/ packages"
    exit 1
fi

echo "Found Java files:"
echo "$JAVA_FILES" | sed 's/^/  /'

# Compile with package structure - classes go in same directories as source
javac -cp "$DIR" -d "$DIR" $JAVA_FILES

if [ $? -eq 0 ]; then
    echo "✅ Compilation successful!"
    
    # Count compiled classes
    CLASS_COUNT=$(find "$DIR" -name "*.class" | wc -l)
    echo "📦 Generated $CLASS_COUNT class files"
    
    # Show where classes were created
    echo "📁 Class file locations:"
    find "$DIR" -name "*.class" | sed 's/^/  /'
    
    # Generate API documentation if ApiWriter is available
    if [ -f "$DIR/tools/ApiWriter.class" ] && [ -f "$DIR/apiwriter.sh" ]; then
        echo "📄 Generating API documentation..."

        # Generate package APIs
        if [ -d "$DIR/hello" ] && sh "$DIR/apiwriter.sh" hello/ api/package_hello.api > /dev/null 2>&1; then
            echo "  ✅ Generated api/package_hello.api"
        fi

        if [ -d "$DIR/world" ] && sh "$DIR/apiwriter.sh" world/ api/package_world.api > /dev/null 2>&1; then
            echo "  ✅ Generated api/package_world.api"
        fi

        if [ -d "$DIR/tools" ] && sh "$DIR/apiwriter.sh" tools/ api/package_tools.api > /dev/null 2>&1; then
            echo "  ✅ Generated api/package_tools.api"
        fi
    fi

    echo ""
    echo "🚀 Ready to run tools:"
    echo "  sh hello.sh [name]           - Generate personalized greeting"
    echo "  sh world.sh                  - Display world information"
    echo "  sh run-tests.sh              - Execute test suite"
    echo "  sh apiwriter.sh <input>      - Generate API documentation"
    echo ""
    
else
    echo "❌ Compilation failed"
    echo ""
    echo "🔧 Troubleshooting:"
    echo "  • Check that all Java files have correct package declarations"
    echo "  • Verify that cross-package imports are correct"
    echo "  • Ensure file paths match package structure"
    exit 1
fi