# Project Organization Guide
*Scalable layout for Java projects - from simple tools to complex frameworks*

## MANDATORY FIRST REQUIREMENT: Real Version Control

**WARNING: A project without a GitHub repository is NOT a project - it's just files pretending to matter.**

Before ANY other setup:
```bash
# Create GitHub repository FIRST
gh repo create ProjectName --public --description "What this project does"
cd ProjectName
git init
git add .
git commit -m "Initial commit: Project structure"
git push -u origin main
```

**Why this is NON-NEGOTIABLE:**
- Local-only repositories have ZERO safety - one disk failure = total loss
- No collaboration possible without remote repository
- No history preservation without real version control
- No credibility as "professional" code without public accessibility
- Local git is just playing pretend - only remote repositories actually exist

## Core Principles

1. **GitHub repository FIRST** - Not optional, not "later", FIRST
2. **Scalable base pattern** - Same structure from simple to complex projects
3. **Everything in README.md** - All functionality documented and reachable 
4. **Shell script launchers** - Never manual `java` commands
5. **Classes with source** - .class files in package directories (simple) or managed by build system (complex)
6. **Complete documentation** - If it's not documented, it doesn't exist
7. **Optional components** - Add complexity only when needed

## Universal Directory Structure

### Base Pattern (Required for ALL projects)

```
ProjectName/
├── .git/                    # MANDATORY - Real version control
├── .gitignore              # MANDATORY - Prevent accidental commits
├── README.md                 # Complete project documentation
├── compile.sh               # Build system (simple or complex)
├── tool1.sh                 # Shell launcher for primary tool
├── package1/                # At least one package required
│   ├── MainTool.java        # Primary functionality
│   ├── UtilityClass.java    # Supporting classes
│   └── *.class             # Compiled classes (simple projects)
├── api/                     # Generated .api files
│   └── package_package1.api # Package overview for framework understanding
├── reports/                 # ALL outputs go here, never project floor
└── old/                     # Archives (never delete, always archive)
```

### Optional Scaling Components (Add as needed)

```
ProjectName/
├── configure.sh             # [OPTIONAL] Dependency detection & environment setup
├── javasetup.sh            # [OPTIONAL] Professional BBTools argument parsing  
├── memdetect.sh            # [OPTIONAL] Cross-platform memory detection
├── build/                  # [OPTIONAL] Complex build systems only
├── lib/                    # [OPTIONAL] External dependencies
├── package2/               # [OPTIONAL] Additional packages
│   ├── SpecializedTool.java
│   └── *.class
├── marketing/              # [OPTIONAL] Domain-specific packages
├── testCases/              # [OPTIONAL] Comprehensive test infrastructure
├── data/                   # [OPTIONAL] Test datasets and samples
├── docs/                   # [OPTIONAL] Extended documentation  
├── plans/                  # [OPTIONAL] Development planning artifacts
├── prompts/                # [OPTIONAL] Development templates
├── validation_results/     # [OPTIONAL] Quality assurance outputs
├── debug_temp/             # [OPTIONAL] Temporary debugging files
└── temp_test/              # [OPTIONAL] Temporary test artifacts
```

## File Locations (Absolute Rules)

- **Source + Compiled**: .java and .class files in same package directory
- **Scripts**: All .sh files at project root
- **Outputs**: reports/ directory, never project floor
- **Documentation**: README.md links to everything else
- **APIs**: api/ directory with package_X.api for every package

## Shell Script Patterns

### Simple Pattern (Basic Projects)

For straightforward tools with minimal argument parsing:

```bash
#!/bin/bash
# Standard directory resolution
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Help function
usage() {
    echo "Usage: $0 input.file [options]"
    echo "Description: What this tool does"
    echo "  --help    Show this help"
    echo "  -Xmx<mem> Set memory (e.g., -Xmx2g)"
}

# Basic argument processing
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    usage; exit 0
fi

# Simple memory management
XMX="-Xmx1g"
for arg in "$@"; do
    case $arg in -Xmx*) XMX="$arg";; esac
done

# Execute with basic classpath
CLASSPATH="$DIR/package1:$DIR/package2:$DIR/*"
java $XMX -ea -cp "$CLASSPATH" package1.ToolClassName "$@"
```

### Professional Pattern (Complex Projects)

For projects needing sophisticated argument parsing (see ShellScriptGuide.md):

```bash
#!/bin/bash
# BBTools-style directory resolution
pushd . > /dev/null
DIR="${BASH_SOURCE[0]}"
while [ -h "$DIR" ]; do
    cd "$(dirname "$DIR")"
    DIR="$(readlink "$(basename "$DIR")")"
done
cd "$(dirname "$DIR")"
DIR="$(pwd)/"
popd > /dev/null

# Source professional auxiliary scripts (if present)
if [ -f "$DIR/javasetup.sh" ]; then
    source "$DIR/javasetup.sh"
    source "$DIR/memdetect.sh"
    
    # Professional argument parsing
    parseJavaArgs "$@"
    setEnvironment
    
    # Execute with professional setup
    java $EA $EOOM $SIMD $XMX $XMS -cp "$BUILD_CLASSPATH" tools.ToolClassName "$@"
else
    # Fallback to simple pattern
    XMX="-Xmx1g"
    for arg in "$@"; do
        case $arg in -Xmx*) XMX="$arg";; esac
    done
    java $XMX -ea -cp "$DIR/*" tools.ToolClassName "$@"
fi
```

## Build System Patterns

### Simple Projects (compile.sh)

For basic projects with standard Java dependencies:

```bash
#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Simple compilation - .class files in package directories
find "$DIR" -name "*.java" -path "*/package*" -exec javac -cp "$DIR/*" {} +

if [ $? -eq 0 ]; then
    echo "✅ Compilation successful - .class files in packages/"
else
    echo "❌ Compilation failed"
    exit 1
fi
```

### Complex Projects (compile.sh + configure.sh)

For projects with external dependencies (Eclipse JDT, etc.):

```bash
#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source configuration if available
if [ -f "$DIR/projectname-env.sh" ]; then
    source "$DIR/projectname-env.sh"
elif [ -f "$DIR/configure.sh" ]; then
    echo "Running first-time configuration..."
    sh "$DIR/configure.sh"
    source "$DIR/projectname-env.sh"
fi

# Complex compilation with dependency management
javac -cp "$BUILD_CLASSPATH" -d "$DIR/build" "$DIR"/package*/*.java

if [ $? -eq 0 ]; then
    echo "✅ Compilation successful - classes in build/ or packages/"
    
    # Generate API files if tools available
    if [ -f "$DIR/build/tools/ApiWriter.class" ] || [ -f "$DIR/package*/ApiWriter.class" ]; then
        echo "Generating API files..."
        java -cp "$BUILD_CLASSPATH" tools.ApiWriter "$DIR"/package*/ "$DIR/api/"
    fi
else
    echo "❌ Compilation failed"
    exit 1
fi
```

## README.md Template

Every project README.md follows this structure:

```markdown
# ProjectName
*Brief description of what it does*

## Quick Start
```bash
sh projectName/compile.sh              # Build all tools
sh projectName/tool1.sh input.file     # Use primary tool
sh projectName/tool2.sh --help         # Get help for any tool
```

## Tools
- **tool1.sh** - Primary functionality description
- **tool2.sh** - Secondary functionality description

## Directory Structure
- **tools/** - Java source and compiled classes
- **api/** - Generated API files for framework understanding  
- **docs/** - Extended documentation
- **reports/** - All outputs go here

## Usage Examples
[Complete examples with expected inputs and outputs]
```

## Documentation Requirements

1. **README.md** - Complete usage documentation
2. **Package APIs** - api/package_X.api for every package (generated, not fabricated)
3. **Shell script help** - Every .sh responds to --help
4. **Examples** - Working examples with real inputs/outputs

## API Generation Patterns

### Simple Projects

Basic package API generation using standard tools:

```bash
# Generate package overview (non-private elements)
sh projectName/apiwriter.sh package1/ api/package_package1.api

# Generate individual class details (all elements including private)
sh projectName/apiwriter.sh package1/MainTool.java api/MainTool.api
```

### Complex Projects  

Comprehensive framework API generation:

```bash
# Generate comprehensive project overview
sh projectName/apiwriter.sh . project.api --include-all-packages

# Generate package-specific APIs
sh projectName/apiwriter.sh tools/ api/package_tools.api
sh projectName/apiwriter.sh marketing/ api/package_marketing.api

# Handle interface assertion bug if needed
java -da -cp "$BUILD_CLASSPATH" tools.ApiWriter marketing/ api/package_marketing.api
```

## Project Evolution: Simple → Complex

### Starting Simple (Single Package)
```
MyProject/
├── README.md
├── compile.sh              # Basic javac compilation
├── mytool.sh               # Simple shell script
├── mypackage/
│   ├── MyTool.java
│   └── MyTool.class
├── api/
│   └── package_mypackage.api
├── reports/
└── old/
```

### Growing Complex (Multiple Packages + Dependencies)
```
MyProject/
├── README.md
├── configure.sh            # Added for Eclipse JDT
├── myproject-env.sh        # Generated by configure.sh
├── compile.sh              # Now handles complex classpath
├── javasetup.sh           # Professional argument parsing
├── memdetect.sh           # Cross-platform memory detection
├── mytool.sh              # Now uses auxiliary scripts
├── specialtool.sh         # Additional tools
├── build/                 # Managed by complex build system
├── lib/                   # External dependencies
├── mypackage/             # Original package
├── specialized/           # New domain-specific package
├── testCases/             # Added testing infrastructure
├── data/                  # Test datasets
├── api/
│   ├── project.api        # Comprehensive overview
│   ├── package_mypackage.api
│   └── package_specialized.api
├── reports/
└── old/
```

### Migration Principles
1. **Base structure never changes** - same core directories
2. **Add optional components** - don't modify existing patterns  
3. **Shell scripts detect complexity** - fallback to simple patterns if auxiliary scripts missing
4. **Documentation scales** - README.md grows but maintains same structure

## configure.sh Pattern (Complex Projects Only)

When your project needs external dependencies (Eclipse JDT, specialized libraries):

```bash
#!/bin/bash
# configure.sh - Auto-detect dependencies and create environment
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Configuring project environment..."

# Detect Eclipse JDT (example for AST processing)
ECLIPSE_JDT=""
for eclipse_path in "/c/Users/$USER/eclipse/"*"/eclipse/plugins" "/opt/eclipse/plugins" "$HOME/eclipse/plugins"; do
    if [[ -d "$eclipse_path" ]] && [[ -f "$eclipse_path/org.eclipse.jdt.core_"*.jar ]]; then
        ECLIPSE_JDT="$eclipse_path/*"
        echo "Found Eclipse JDT: $eclipse_path"
        break
    fi
done

if [ -z "$ECLIPSE_JDT" ]; then
    echo "WARNING: Eclipse JDT not found. Some features may not work."
    echo "Install Eclipse JDT or place jars in lib/ directory."
fi

# Generate environment configuration
cat > "$DIR/$(basename "$DIR")-env.sh" << EOF
# Auto-generated environment configuration
export BUILD_CLASSPATH="$DIR/build:$DIR/*:$ECLIPSE_JDT"
export ECLIPSE_DETECTED="${ECLIPSE_JDT:+true}"
export PROJECT_ROOT="$DIR"
EOF

echo "Configuration complete. Environment saved to $(basename "$DIR")-env.sh"
```

## What NOT to Do

- ❌ **Local-only git repositories** (worthless without remote backup)
- ❌ **"I'll push to GitHub later"** (later never comes, disk failures do)
- ❌ Manual `java -cp` commands (use shell scripts)
- ❌ Inconsistent structure between simple/complex (use base pattern + optional components)
- ❌ Fabricated documentation (use generation tools)
- ❌ Outputs on project floor (use reports/)
- ❌ Searching for functionality (read documentation)
- ❌ Complex patterns for simple projects (start simple, scale up)

## Project Setup Checklists

### Simple Project Checklist
1. ✅ GitHub repository created and code pushed
2. ✅ Base directory structure (package/, api/, reports/, old/)
3. ✅ Simple compile.sh using javac  
4. ✅ Basic shell scripts with simple argument parsing
5. ✅ README.md documents all functionality
6. ✅ Package .api files generated
7. ✅ All outputs in reports/
8. ✅ Regular commits with meaningful messages

### Complex Project Checklist  
1. ✅ GitHub repository with proper branching strategy
2. ✅ Base structure + optional components (lib/, build/, testCases/, etc.)
3. ✅ configure.sh for dependency detection
4. ✅ Complex compile.sh with BUILD_CLASSPATH
5. ✅ Professional shell scripts with auxiliary script integration
6. ✅ Comprehensive APIs (project.api + package-specific)
7. ✅ Testing infrastructure and validation
8. ✅ CI/CD integration (GitHub Actions for tests/builds)

---

## Version Control Throughout Development

### Commit Discipline
```bash
# After EVERY significant change
git add .
git commit -m "Meaningful description of what changed and why"
git push

# Never let local commits accumulate
git status  # Should show "Your branch is up to date with 'origin/main'"
```

### Standard .gitignore for Java Projects
```gitignore
# Compiled class files
*.class

# Build directories
build/
target/
out/

# IDE files
.idea/
.vscode/
*.iml
.project
.classpath
.settings/

# Package files
*.jar
*.war
*.ear
*.zip
*.tar.gz
*.rar

# Logs and databases
*.log
*.sqlite

# OS files
.DS_Store
Thumbs.db

# Project-specific
reports/*
!reports/.gitkeep
temp_*/
debug_*/
*-env.sh
```

### Why Version Control Discipline Matters
- **"But I'm just testing"** - Test code becomes production code
- **"It's a small project"** - Small projects become large projects
- **"I work alone"** - You won't always, and future-you needs history
- **"My disk is reliable"** - No disk is reliable enough for irreplaceable code

---

*Universal structure for all Java projects - GitHub repository FIRST, then scalable patterns from simple tools to complex frameworks*