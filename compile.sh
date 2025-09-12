#!/bin/bash

# HelloWorld compile script
# Laptop-friendly compilation with reasonable defaults

# Standard directory resolution
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "HelloWorld Compiler v1.0"
echo "========================"

# Check for Java compiler
if ! command -v javac &> /dev/null; then
    echo "❌ Error: javac not found. Please install Java Development Kit (JDK)."
    exit 1
fi

echo "📁 Project directory: $DIR"

# Compile all Java files in packages
echo "🔨 Compiling Java source files..."

# Find and compile all .java files in package directories  
JAVA_FILES=$(find "$DIR" \( -path "*/hello/*" -o -path "*/world/*" \) -name "*.java")

if [ -z "$JAVA_FILES" ]; then
    echo "❌ No Java source files found in hello/ or world/ packages"
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
    
    echo ""
    echo "🚀 Ready to run tools:"
    echo "  sh hello.sh [name]           - Generate personalized greeting"
    echo "  sh world.sh                  - Display world information"
    echo "  sh run-tests.sh              - Execute test suite"
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