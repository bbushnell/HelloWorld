# Shell Script Guide - BBTools Professional Patterns
*Professional shell script architecture with reusable auxiliary components*

## Core Philosophy

**Don't reinvent argument parsing in every script.** BBTools uses sophisticated auxiliary scripts that handle complex parsing, memory detection, and environment setup. This creates consistent, professional tools with minimal code duplication.

## Essential Components

### 1. Directory Resolution Block (Standard Pattern)

```bash
#!/bin/bash

# Standard BBTools directory resolution - handles symlinks correctly
pushd . > /dev/null
DIR="${BASH_SOURCE[0]}"
while [ -h "$DIR" ]; do
  cd "$(dirname "$DIR")"
  DIR="$(readlink "$(basename "$DIR")")"
done
cd "$(dirname "$DIR")"
DIR="$(pwd)/"
popd > /dev/null

# Set classpath
CP="$DIR""current/"
```

**Why This Pattern:** Correctly resolves script directory even when called through symlinks or from different working directories.

### 2. Auxiliary Script Architecture

#### Core Auxiliary Scripts

Create these reusable scripts in your project root:

**`memdetect.sh`** - Memory detection across environments
- Handles Linux (`/proc/meminfo`) and macOS (`sysctl`, `vm_stat`)
- SLURM and other scheduler integration
- Percentage-based allocation with safety margins
- Fixed, auto, and partial memory modes

**`javasetup.sh`** - Java argument parsing and environment setup  
- Standardized argument parsing (`-Xmx`, `--mem`, `ea`, `da`)
- Environment detection (AWS, NERSC, containers)
- PATH configuration for different deployment environments
- SIMD, assertions, and OOM handling

**`projectsetup.sh`** - Project-specific configuration
- Tool-specific defaults and paths
- Custom argument handling beyond Java flags
- Integration with project build system

### 3. Professional Tool Script Pattern

```bash
#!/bin/bash

usage() {
cat << EOF
Written by [Author]
Last modified [Date]

Description: [What this tool does]

Usage:
$0 input.file output.file [options]

Parameters:
input.file      Input file description
output.file     Output file description

Java/Memory Options:
-Xmx<memory>    Set maximum heap size (e.g., -Xmx4g)
--mem=<memory>  Alternative memory specification
--mode=fixed    Use fixed memory allocation
-ea/-da         Enable/disable assertions

Tool Options:
--verbose       Enable verbose output
--help          Show this help message

Please contact [maintainer] if you encounter any problems.
EOF
}

# Standard directory resolution
pushd . > /dev/null
DIR="${BASH_SOURCE[0]}"
while [ -h "$DIR" ]; do
  cd "$(dirname "$DIR")"
  DIR="$(readlink "$(basename "$DIR")")"
done
cd "$(dirname "$DIR")"
DIR="$(pwd)/"
popd > /dev/null

# Source auxiliary scripts
source "$DIR/memdetect.sh"
source "$DIR/javasetup.sh"
source "$DIR/projectsetup.sh"  # Optional: project-specific setup

# Tool initialization function
initializeTool() {
    # Parse Java arguments and set memory
    parseJavaArgs "$@"
    
    # Set environment paths
    setEnvironment
    
    # Handle help and usage
    for arg in "$@"; do
        if [ "$arg" = "--help" ] || [ "$arg" = "-h" ]; then
            usage
            exit 0
        fi
    done
}

# Tool execution function
executeTool() {
    local CMD="java $EA $EOOM $SIMD $XMX $XMS -cp $CP tools.YourToolClass $@"
    
    # Optionally log the command for debugging
    if [ "$VERBOSE" = "1" ]; then
        echo "Executing: $CMD" >&2
    fi
    
    eval $CMD
}

# Main execution
initializeTool "$@"
executeTool "$@"
```

## Auxiliary Script Implementation

### memdetect.sh Template

```bash
#!/bin/bash

# Memory detection with environment awareness
DEFAULT_MEM_MB=3200
DEFAULT_MEM_PERCENT_SHARED=45
DEFAULT_MEM_PERCENT_EXCLUSIVE=85
RESERVED_MEM_KB=500000

detectMemory() {
    RAM=0
    local defaultMem=$DEFAULT_MEM_MB
    local memPercent=$DEFAULT_MEM_PERCENT_SHARED
    local memMode="auto"
    
    # Parse arguments: detectMemory "4g" "75" "fixed"
    if [ $# -gt 0 ]; then
        # Handle memory units (4g, 2048m, etc.)
        defaultMem=$1
        case $defaultMem in
            *g) defaultMem=$(echo $defaultMem | sed 's/g$//')
                defaultMem=$(( defaultMem * 1024 )) ;;
            *m) defaultMem=$(echo $defaultMem | sed 's/m$//');;
        esac
    fi
    
    if [ $# -gt 1 ]; then memPercent=$2; fi
    if [ $# -gt 2 ]; then memMode=$3; fi
    
    # Fixed mode: use exactly what was specified
    if [ "$memMode" = "fixed" ]; then
        RAM=$defaultMem
        return 0
    fi
    
    # Auto mode: detect system memory
    detectSystemMemory
    calculateFinalMemory "$memPercent"
}

detectSystemMemory() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        detectMacMemory
    elif [ -e /proc/meminfo ]; then
        detectLinuxMemory  
    else
        availableMemKB=$(( DEFAULT_MEM_MB * 1024 ))
    fi
}

# Export for sourcing
export -f detectMemory
```

### javasetup.sh Template

```bash
#!/bin/bash

# Source memory detection
source "$(dirname "$0")/memdetect.sh"

# Global Java variables
XMX="" XMS="" EA="-ea" EOOM="" SIMD=""
silent=0 VERBOSE=0

parseJavaArgs() {
    local setxmx=0 setxms=0
    local defaultMem="4g" memPercent=84 memMode="auto"
    
    for arg in "$@"; do
        case "${arg%%=*}" in
            "--mem") defaultMem="${arg#*=}" ;;
            "--mode") memMode="${arg#*=}" ;;
            "--percent") memPercent="${arg#*=}" ;;
            "-Xmx"|"Xmx") XMX="-Xmx${arg#*=}"; setxmx=1 ;;
            "-Xms"|"Xms") XMS="-Xms${arg#*=}"; setxms=1 ;;
            "-da"|"-ea"|"da"|"ea") EA="-${arg#-}" ;;
            "-eoom"|"eoom") EOOM="-XX:+ExitOnOutOfMemoryError" ;;
            "simd") SIMD="--add-modules jdk.incubator.vector" ;;
            "--verbose"|"verbose") VERBOSE=1 ;;
            "--silent"|"silent") silent=1 ;;
        esac
    done
    
    # Auto-detect memory if not specified
    if [ "$setxmx" = "0" ]; then
        detectMemory "$defaultMem" "$memPercent" "$memMode"
        XMX="-Xmx${RAM}m"
        XMS="-Xms${RAM}m"
    fi
}

setEnvironment() {
    # Environment-specific PATH settings
    if [ -n "$NERSC_HOST" ]; then
        PATH="/global/cfs/cdirs/bbtools/bgzip:$PATH"
        PATH="/global/cfs/cdirs/bbtools/java/jdk-17/bin:$PATH"
    elif [ -n "$EC2_HOME" ]; then
        PATH="/test1/binaries/bgzip:$PATH"
        PATH="/test1/binaries/pigz2/pigz-2.4:$PATH"
    fi
}

# Export functions for sourcing
export -f parseJavaArgs setEnvironment
```

## Advanced Patterns

### 1. Argument Forwarding

```bash
# Clean argument forwarding - remove parsed flags, pass the rest
forwardArgs=()
for arg in "$@"; do
    case "$arg" in
        -Xmx*|--mem=*|--mode=*|-ea|-da|--verbose) 
            # Skip Java/script arguments
            ;;
        *)
            forwardArgs+=("$arg")
            ;;
    esac
done

java $JAVA_FLAGS tools.YourTool "${forwardArgs[@]}"
```

### 2. Multi-Tool Scripts

```bash
# Handle multiple tool modes
TOOL_MODE="primary"
for arg in "$@"; do
    case "$arg" in
        --validate) TOOL_MODE="validator" ;;
        --analyze) TOOL_MODE="analyzer" ;;
        --convert) TOOL_MODE="converter" ;;
    esac
done

case "$TOOL_MODE" in
    "validator") java $JAVA_FLAGS tools.Validator "${forwardArgs[@]}" ;;
    "analyzer") java $JAVA_FLAGS tools.Analyzer "${forwardArgs[@]}" ;;
    "converter") java $JAVA_FLAGS tools.Converter "${forwardArgs[@]}" ;;
    *) java $JAVA_FLAGS tools.PrimaryTool "${forwardArgs[@]}" ;;
esac
```

### 3. Error Handling

```bash
executeTool() {
    local CMD="java $EA $EOOM $SIMD $XMX $XMS -cp $CP tools.YourTool $@"
    
    if [ "$VERBOSE" = "1" ]; then
        echo "Executing: $CMD" >&2
    fi
    
    eval $CMD
    local EXIT_CODE=$?
    
    if [ $EXIT_CODE -ne 0 ]; then
        echo "Error: Tool execution failed with exit code $EXIT_CODE" >&2
        if [ $EXIT_CODE -eq 134 ]; then
            echo "Hint: This may be an assertion failure. Try running with -da flag." >&2
        elif [ $EXIT_CODE -eq 137 ]; then
            echo "Hint: Process was killed, likely out of memory. Try increasing -Xmx." >&2
        fi
        exit $EXIT_CODE
    fi
}
```

## Reusable Infrastructure Setup

### Project Integration

1. **Copy auxiliary scripts** to your project root:
   - `memdetect.sh` (memory detection)
   - `javasetup.sh` (Java setup)  
   - `projectsetup.sh` (project-specific config)

2. **Customize projectsetup.sh** for your needs:
```bash
#!/bin/bash

# Project-specific configuration
PROJECT_NAME="yourproject"
DEFAULT_CLASSPATH="$DIR/tools"
TOOL_PACKAGE="tools"

# Project-specific argument parsing
parseProjectArgs() {
    for arg in "$@"; do
        case "${arg%%=*}" in
            "--config") CONFIG_FILE="${arg#*=}" ;;
            "--output-dir") OUTPUT_DIR="${arg#*=}" ;;
            # Add your project-specific arguments
        esac
    done
}

# Export for sourcing
export -f parseProjectArgs
```

3. **Create tool scripts** using the standard pattern above

4. **Update your ProjectGuide.md** to reference the ShellScriptGuide.md for complex argument handling

## Benefits

- **Consistency**: All tools handle arguments the same way
- **Maintainability**: Bug fixes in auxiliary scripts apply to all tools
- **Professional Quality**: Handles edge cases, environments, error conditions
- **Extensibility**: Easy to add new argument types or environment support
- **Documentation**: Self-documenting through usage functions

## Migration from Simple Scripts

1. **Keep simple scripts simple** - use basic pattern for trivial tools
2. **Use auxiliary scripts** for any tool that needs memory management or complex arguments
3. **Gradually migrate** existing scripts when they need new features
4. **Document the choice** in your project README.md

---

*This infrastructure eliminates reinventing argument parsing in every script while maintaining professional quality and consistency across all project tools.*