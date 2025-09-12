#!/bin/bash

# HelloWorld Test Runner
# Professional test execution with detailed reporting

# Standard directory resolution
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TEST_DIR="$DIR/testCases"
REPORTS_DIR="$DIR/reports"

# Test execution settings
VERBOSE=false
SPECIFIC_TEST=""
CATEGORY=""

usage() {
    echo "run-tests.sh - HelloWorld Test Suite Runner"
    echo ""
    echo "Usage:"
    echo "  $0 [options]"
    echo ""
    echo "Options:"
    echo "  --all                Run all tests (default)"
    echo "  --test <name>        Run specific test case"
    echo "  --category <name>    Run tests in specific category"
    echo "  --verbose, -v        Enable verbose output"
    echo "  --help, -h          Show this help"
    echo ""
    echo "Examples:"
    echo "  $0                           # Run all tests"
    echo "  $0 --test hello_basic        # Run specific test"
    echo "  $0 --category basic_functionality  # Run category"
    echo "  $0 --verbose                 # Verbose test execution"
    echo ""
    echo "Available Tests:"
    if [ -d "$TEST_DIR" ]; then
        find "$TEST_DIR" -name "test_metadata.json" | while read -r metadata; do
            test_name=$(basename "$(dirname "$metadata")")
            description=$(grep -o '"description": "[^"]*"' "$metadata" | cut -d'"' -f4)
            echo "  • $test_name: $description"
        done
    fi
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --help|-h)
            usage
            exit 0
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --all)
            # Default behavior, no action needed
            shift
            ;;
        --test)
            SPECIFIC_TEST="$2"
            shift 2
            ;;
        --category)
            CATEGORY="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage
            exit 1
            ;;
    esac
done

# Ensure reports directory exists
mkdir -p "$REPORTS_DIR"

# Test execution function
run_test() {
    local test_name="$1"
    local test_path="$TEST_DIR/$test_name"
    
    if [ ! -d "$test_path" ]; then
        echo "❌ Test not found: $test_name" >&2
        return 1
    fi
    
    if [ ! -f "$test_path/test_metadata.json" ]; then
        echo "❌ Test metadata missing: $test_name" >&2
        return 1
    fi
    
    echo "🧪 Running test: $test_name"
    
    # Extract test metadata
    local tool=$(grep -o '"tool": "[^"]*"' "$test_path/test_metadata.json" | cut -d'"' -f4)
    local description=$(grep -o '"description": "[^"]*"' "$test_path/test_metadata.json" | cut -d'"' -f4)
    local expected_result=$(grep -o '"expected_result": "[^"]*"' "$test_path/test_metadata.json" | cut -d'"' -f4)
    
    if [ "$VERBOSE" = true ]; then
        echo "   Tool: $tool"
        echo "   Description: $description"
        echo "   Expected: $expected_result"
    fi
    
    # Prepare test execution
    local output_file="$REPORTS_DIR/test_${test_name}_output.txt"
    local error_file="$REPORTS_DIR/test_${test_name}_error.txt"
    
    # Execute test
    local start_time=$(date +%s)
    if [ "$VERBOSE" = true ]; then
        echo "   Executing: sh $tool"
    fi
    
    # Run the tool and capture output
    cd "$DIR"
    timeout 30 sh "$tool" > "$output_file" 2> "$error_file"
    local exit_code=$?
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    # Analyze results
    local test_passed=true
    local failure_reasons=()
    
    # Check exit code
    if [ "$expected_result" = "success" ] && [ $exit_code -ne 0 ]; then
        test_passed=false
        failure_reasons+=("Exit code $exit_code (expected 0)")
    fi
    
    # Check for timeout
    if [ $exit_code -eq 124 ]; then
        test_passed=false
        failure_reasons+=("Test timed out after 30 seconds")
    fi
    
    # Validate output content based on test type
    if [ "$test_name" = "hello_basic" ]; then
        if ! grep -q "World" "$output_file"; then
            test_passed=false
            failure_reasons+=("Output missing 'World' reference")
        fi
        if ! grep -qE "(Hello|Hi|Good|Greetings)" "$output_file"; then
            test_passed=false
            failure_reasons+=("Output missing greeting word")
        fi
    elif [ "$test_name" = "world_basic" ]; then
        if ! grep -q "World" "$output_file"; then
            test_passed=false
            failure_reasons+=("Output missing greeting with 'World'")
        fi
        if ! grep -qi "population" "$output_file"; then
            test_passed=false
            failure_reasons+=("Output missing population information")
        fi
        if ! grep -qi "languages" "$output_file"; then
            test_passed=false
            failure_reasons+=("Output missing language information")
        fi
    fi
    
    # Check for error output
    if [ -s "$error_file" ] && [ "$expected_result" = "success" ]; then
        if [ "$VERBOSE" = true ]; then
            # In verbose mode, some stderr output might be expected
            if grep -qvE "(Launcher|Directory|Classpath|Memory|Assertions|Tool args)" "$error_file"; then
                test_passed=false
                failure_reasons+=("Unexpected error output")
            fi
        else
            test_passed=false
            failure_reasons+=("Unexpected error output")
        fi
    fi
    
    # Report results
    if [ "$test_passed" = true ]; then
        echo "   ✅ PASSED (${duration}s)"
        return 0
    else
        echo "   ❌ FAILED (${duration}s)"
        for reason in "${failure_reasons[@]}"; do
            echo "      • $reason"
        done
        
        if [ "$VERBOSE" = true ]; then
            echo "   📄 Output:"
            cat "$output_file" | sed 's/^/      /'
            if [ -s "$error_file" ]; then
                echo "   🚨 Errors:"
                cat "$error_file" | sed 's/^/      /'
            fi
        fi
        return 1
    fi
}

# Main test execution
echo "🧪 HelloWorld Test Suite"
echo "======================="
echo ""

# Verify project is compiled
if [ ! -f "$DIR/hello/HelloTool.class" ] || [ ! -f "$DIR/world/WorldTool.class" ]; then
    echo "❌ Project not compiled. Running compile.sh first..."
    sh "$DIR/compile.sh"
    if [ $? -ne 0 ]; then
        echo "❌ Compilation failed. Cannot run tests."
        exit 1
    fi
    echo ""
fi

# Find tests to run
TESTS_TO_RUN=()

if [ -n "$SPECIFIC_TEST" ]; then
    TESTS_TO_RUN=("$SPECIFIC_TEST")
elif [ -n "$CATEGORY" ]; then
    # Find tests in category
    while IFS= read -r -d '' metadata; do
        test_name=$(basename "$(dirname "$metadata")")
        test_category=$(grep -o '"category": "[^"]*"' "$metadata" | cut -d'"' -f4)
        if [ "$test_category" = "$CATEGORY" ]; then
            TESTS_TO_RUN+=("$test_name")
        fi
    done < <(find "$TEST_DIR" -name "test_metadata.json" -print0)
else
    # Run all tests
    while IFS= read -r -d '' metadata; do
        test_name=$(basename "$(dirname "$metadata")")
        TESTS_TO_RUN+=("$test_name")
    done < <(find "$TEST_DIR" -name "test_metadata.json" -print0)
fi

if [ ${#TESTS_TO_RUN[@]} -eq 0 ]; then
    echo "❌ No tests found to run"
    exit 1
fi

# Execute tests
PASSED=0
FAILED=0
TOTAL=${#TESTS_TO_RUN[@]}

echo "📊 Executing $TOTAL test(s)..."
echo ""

for test_name in "${TESTS_TO_RUN[@]}"; do
    if run_test "$test_name"; then
        ((PASSED++))
    else
        ((FAILED++))
    fi
done

# Final report
echo ""
echo "📊 Test Results Summary"
echo "======================"
echo "Total: $TOTAL"
echo "Passed: $PASSED"
echo "Failed: $FAILED"

if [ $FAILED -eq 0 ]; then
    echo ""
    echo "🎉 All tests passed!"
    exit 0
else
    echo ""
    echo "❌ $FAILED test(s) failed"
    echo "📁 Test outputs saved to: $REPORTS_DIR"
    exit 1
fi