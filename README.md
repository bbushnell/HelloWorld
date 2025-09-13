# HelloWorld
*Professional Java project template demonstrating scalable architecture patterns*

## 🔥 REAL GitHub Repository

**This is a REAL project at: https://github.com/bbushnell/HelloWorld**

Why this matters:
- **Permanent existence** - Not lost when local disk fails
- **Professional credibility** - Real projects have real repositories  
- **Collaboration enabled** - Others can clone, fork, and contribute
- **History preserved** - Every change tracked and recoverable
- **CI/CD ready** - GitHub Actions can run tests on every push

**WARNING**: Any "project" without a GitHub repository is just files playing pretend.

## Overview

HelloWorld is a complete reference implementation showcasing professional Java project organization from simple tools to complex frameworks. This project serves as a working template for the Universal Project Organization patterns documented in the included guides.

## 🚀 Quick Start

```bash
# Clone the REAL repository
git clone https://github.com/bbushnell/HelloWorld.git
cd HelloWorld
sh compile.sh

# Run tools
sh hello.sh                    # Default greeting
sh hello.sh Alice               # Custom greeting
sh world.sh                     # World information
sh run-tests.sh                 # Execute test suite
```

## 📁 Directory Structure

### Base Pattern (All Projects)
```
HelloWorld/
├── README.md                   # This file - complete project documentation
├── compile.sh                  # Build system with error handling
├── hello.sh                    # HelloTool launcher with laptop-friendly defaults
├── world.sh                    # WorldTool launcher
├── run-tests.sh               # Professional test runner
├── hello/                      # Primary package
│   ├── HelloTool.java         # Main greeting generator
│   ├── HelloUtils.java        # Time-aware greeting utilities
│   └── *.class                # Compiled classes (generated)
├── world/                      # Secondary package (demonstrates multi-package)
│   ├── WorldTool.java         # World information generator
│   ├── WorldUtils.java        # Global statistics utilities
│   └── *.class                # Compiled classes (generated)
├── api/                        # Generated API documentation
│   ├── package_hello.api      # Hello package API
│   └── package_world.api      # World package API
├── testCases/                  # Test infrastructure
│   ├── hello_basic/           # Basic HelloTool functionality test
│   └── world_basic/           # Cross-package interaction test
├── reports/                    # Test outputs and analysis results
├── old/                        # Archives (never delete - always archive)
└── lib/                        # External dependencies (empty for this example)
```

### Optional Scaling Components (Demonstrated)
- **Multi-package architecture**: `hello/` and `world/` packages
- **Cross-package dependencies**: WorldTool uses HelloUtils
- **Professional test suite**: Automated test execution with reporting
- **API documentation**: Package-level APIs for framework understanding
- **Laptop-friendly defaults**: 512MB heap instead of cluster-scale memory

## 🔧 Tools

### HelloTool (`hello.sh`)
Professional greeting generator with customizable names and time-aware selection.

```bash
sh hello.sh                    # Hello, World!
sh hello.sh Alice               # Hi, Alice! (varies by time)
sh hello.sh --name=Bob --verbose # Verbose greeting with detailed output
sh hello.sh --help              # Complete usage information
```

**Features:**
- Time-aware greeting selection (Good morning, Hello, Good evening)
- Input sanitization and validation
- Professional argument parsing
- Comprehensive error handling
- Assertion-based defensive programming

### WorldTool (`world.sh`)
World information generator demonstrating cross-package interaction.

```bash
sh world.sh                     # World statistics and greeting
sh world.sh --verbose           # Detailed execution information
sh world.sh --help              # Complete usage information
```

**Features:**
- Global population statistics (8.1 billion people)
- Major world languages with speaker counts
- Continental distribution data
- Cross-package integration with HelloUtils
- Professional output validation

### Test Suite (`run-tests.sh`)
Professional test runner with detailed reporting and validation.

```bash
sh run-tests.sh                 # Run all tests
sh run-tests.sh --test hello_basic    # Run specific test
sh run-tests.sh --verbose       # Detailed test execution
sh run-tests.sh --help          # Complete usage information
```

**Features:**
- Automated test discovery and execution
- Content validation and format checking
- Professional test reporting with timing
- Output capture and analysis
- Comprehensive error diagnosis

## 💻 Laptop-Friendly Configuration

Unlike cluster-oriented tools, HelloWorld uses reasonable defaults for development laptops:

- **Memory**: 512MB max heap (not 84% of system RAM)
- **Assertions**: Enabled by default for development
- **Timeouts**: 30-second test timeouts
- **No external dependencies**: Pure Java with standard library
- **Error handling**: Helpful messages for common issues

## 🔬 Testing Infrastructure

### Test Structure
Each test case includes:
- `test_metadata.json` - Test configuration and validation rules
- `expected_output.txt` or `expected_pattern.txt` - Expected results
- `README.md` - Test documentation and success criteria

### Available Tests
1. **hello_basic**: Validates HelloTool default functionality
2. **world_basic**: Tests cross-package interaction and WorldTool output

### Test Execution
- Automatic compilation verification
- Content validation based on test type
- Error output analysis
- Performance timing
- Detailed failure reporting

## 📚 API Documentation

### Package APIs
- **`api/package_hello.api`**: Hello package classes and methods
- **`api/package_world.api`**: World package classes and methods

### Framework Understanding
API files provide token-efficient documentation for AI frameworks:
- Method signatures without implementation details
- Cross-package dependency mapping
- Public interface documentation
- Usage patterns and examples

## 🏗️ Architecture Patterns Demonstrated

### Defensive Programming
- Comprehensive assertions in all methods
- Input validation and sanitization
- Professional error handling
- Proper exception propagation

### Professional Shell Scripts
- BBTools-style directory resolution
- Laptop-friendly memory defaults
- Graceful error handling
- Consistent argument parsing

### Cross-Package Interaction
- WorldTool imports and uses HelloUtils
- Proper classpath configuration
- Dependency validation in shell scripts

### Testing Infrastructure
- Professional test runner implementation
- Content validation strategies
- Automated test discovery
- Comprehensive reporting

## 🚀 Usage Examples

### Basic Functionality
```bash
# Compile project
sh compile.sh

# Generate greeting
sh hello.sh
# Output: Hello, World!

# Custom name
sh hello.sh "Alice"
# Output: Hi, Alice! (varies by time of day)

# World information
sh world.sh
# Output: Greeting + comprehensive world statistics

# Run tests
sh run-tests.sh
# Output: Professional test execution report
```

### Advanced Usage
```bash
# Memory configuration
sh hello.sh Bob -Xmx1g          # 1GB heap for greeting
sh world.sh -Xms512m -Xmx2g     # Custom memory configuration

# Assertion control
sh hello.sh Alice -da           # Disable assertions
sh world.sh -ea                 # Enable assertions (default)

# Verbose execution
sh hello.sh --verbose Charlie   # Detailed execution information
sh world.sh --verbose           # Show launcher details

# Test execution
sh run-tests.sh --verbose       # Detailed test output
sh run-tests.sh --test hello_basic  # Specific test execution
```

## 🔧 Development

### Adding New Tools
1. Create new package directory (e.g., `newpackage/`)
2. Implement Java classes with proper assertions
3. Create shell script launcher following existing patterns
4. Add test cases in `testCases/`
5. Generate API documentation
6. Update README.md

### Scaling to Complex Projects
HelloWorld demonstrates the base pattern that scales to complex frameworks:
1. Add `configure.sh` for external dependencies
2. Include `lib/` directory for JARs
3. Add professional auxiliary scripts (`javasetup.sh`, `memdetect.sh`)
4. Expand test infrastructure
5. Generate comprehensive `project.api`

## 📖 Documentation

This repository includes complete project organization guides:
- **ProjectGuide.md**: Universal scalable project structure
- **ShellScriptGuide.md**: Professional shell script patterns
- **FunctionalityGuide.md**: Systematic functionality investigation

## 🎯 Success Criteria

A successful HelloWorld deployment should:
- ✅ **Exist on GitHub** - Not just local pretend repository
- ✅ **Have .gitignore** - Prevent accidental commits of build artifacts
- ✅ **Regular commits** - History shows development progress
- ✅ Compile without errors using `compile.sh`
- ✅ Execute both tools successfully
- ✅ Pass all tests in the test suite
- ✅ Generate proper API documentation
- ✅ Demonstrate cross-package interaction
- ✅ Follow professional development patterns

---

*HelloWorld serves as the canonical reference for professional Java project organization, demonstrating patterns that scale from simple tools to complex frameworks.*