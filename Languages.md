# Language Selection Policy - HelloWorld Project
*Implementing PRINCIPLE #2: Tactical Technology Stack*

## 1. Primary Development Language

**STANDARD**: Everything must be written in Java with shell script wrappers.

**Rationale**:
- **Consistency enables tactical precision** across all operations
- **Unified compilation and deployment patterns** reduce complexity
- **Leverages existing BBTools ecosystem** and proven architectural patterns
- **Supports professional development practices** with mature tooling
- **Cross-platform compatibility** without additional runtime dependencies
- **Strong type safety** prevents entire classes of operational failures

**Implementation Requirements**:
- All core logic implemented in Java
- Professional shell script launchers for all functionality
- BBTools-style argument parsing and memory management
- Comprehensive error handling and user guidance

## 2. Shell Script Integration Policy

**REQUIREMENT**: All Java functionality must be accessible through shell scripts.

**Shell Script Responsibilities**:
- **Professional argument parsing** with comprehensive help functions
- **Memory management integration** (-Xmx, -Xms, garbage collection tuning)
- **Classpath management** to ensure correct library and class loading
- **Environment validation** to verify prerequisites before execution
- **Error handling and guidance** with actionable troubleshooting information
- **BBTools compatibility** following established patterns and conventions

**Example Integration Pattern**:
```bash
#!/bin/bash
# Professional Java tool launcher

# Memory management
DEFAULT_MEM="1g"
JVM_OPTS="-Xmx${MEM:-$DEFAULT_MEM} -Xms256m"

# Usage function (REQUIRED)
usage() {
    echo "Purpose: [Tool description]"
    echo "Usage: $0 [options] arguments"
    # Complete usage documentation
}

# Execute Java with proper error handling
java $JVM_OPTS -cp "$CLASSPATH" ToolClass "$@"
```

## 3. Acceptable Language Exceptions

### 3.1 Limited Exceptions Policy
**Exceptions permitted** only when dramatically easier or better to use another language, with explicit justification required.

### 3.2 Node.js for Server Functionality
**ACCEPTABLE**: Node.js for server-related functionality where JavaScript ecosystem provides clear advantage.

**Valid Use Cases**:
- **Web servers and APIs** where Express.js or similar frameworks provide significant benefits
- **Real-time communication** using WebSocket libraries optimized for JavaScript
- **Frontend integration** where Node.js bridges between client and server effectively
- **Package ecosystem leverage** when npm provides libraries unavailable in Java

**Requirements for Node.js Use**:
- **Explicit justification** documented in project README.md
- **Clear integration patterns** with existing Java infrastructure
- **Professional deployment** following established Node.js best practices
- **Haiku test compliance** - must work from fresh clone with documented setup

### 3.3 Bash for System Operations
**REQUIRED**: Bash for system operations, build scripts, and tool launchers.

**Standard Bash Use Cases**:
- **Compilation scripts** (compile.sh, build automation)
- **Tool launchers** (wrapping Java applications with professional interfaces)
- **System integration** (file operations, process management, environment setup)
- **Development workflow** (testing scripts, validation automation)

**Bash Script Standards**:
- **Professional error handling** with meaningful exit codes
- **Comprehensive usage() functions** for all user-facing scripts
- **Input validation** to prevent common failure modes
- **Cross-platform compatibility** where possible (Windows/Linux/macOS)

## 4. Forbidden Technologies

### 4.1 Python Ecosystem - ABSOLUTELY PROHIBITED
**NEVER USE**: Python unless no realistic alternative exists.

**Specific Prohibitions**:
- **Python scripts** for any functionality that could be implemented in Java
- **Conda** package management system - completely forbidden
- **Python virtual environments** (venv, virtualenv, pipenv) - all prohibited
- **pip installations** and Python package dependencies
- **Python-based tools** when Java or Node.js alternatives exist

**Rationale for Python Prohibition**:
- **Deployment complexity** - virtual environments create operational burden
- **Dependency hell** - Python package management is notoriously fragile
- **Version conflicts** - Multiple Python versions and package incompatibilities
- **Inconsistent behavior** - Different behavior across Python installations
- **Operational liability** - Conda and pip create maintenance nightmares

### 4.2 Other Forbidden Patterns
- **Mixed-language projects** without explicit architectural justification
- **Proprietary languages** that create vendor lock-in
- **Experimental languages** without proven stability and ecosystem
- **Languages requiring special runtime environments** beyond JVM/Node.js

## 5. Decision Criteria Framework

### 5.1 Language Selection Process
When encountering a new development requirement:

**Step 1: Java Evaluation**
- Can this be implemented effectively in Java?
- Are there mature Java libraries for this functionality?
- Would Java implementation be maintainable long-term?
- **If YES to all**: Use Java (90% of cases)

**Step 2: Exception Evaluation**
- Is there a dramatic advantage to another language?
- Would the alternative significantly reduce complexity?
- Is the alternative well-established and stable?
- Can it integrate cleanly with existing Java infrastructure?

**Step 3: Alternative Assessment**
- **Node.js consideration**: For server/web functionality
- **Bash consideration**: For system operations only
- **Other languages**: Require explicit architectural justification

**Step 4: Python Rejection**
- Could this requirement be met with Java + libraries?
- Could Node.js handle this functionality?
- Is this truly impossible without Python?
- **If ANY alternative exists**: Use it instead of Python

### 5.2 Justification Documentation Requirements
For any non-Java choice:

**Required Documentation**:
1. **Problem statement**: What exactly needs to be solved?
2. **Java assessment**: Why Java is insufficient for this case
3. **Alternative evaluation**: What options were considered?
4. **Selection rationale**: Why this specific language/tool?
5. **Integration plan**: How does this fit with existing architecture?
6. **Maintenance strategy**: Long-term support and update approach

**Review Criteria**:
- Technical necessity clearly demonstrated
- Integration approach professionally designed
- Long-term sustainability considered
- Haiku test compliance maintained

## 6. Implementation Patterns

### 6.1 Java-First Architecture
```
Project Structure:
├── src/main/java/          # All core functionality
│   ├── package1/           # Logical groupings
│   └── package2/
├── shell-scripts/          # User-facing interfaces
│   ├── tool1.sh           # Professional launchers
│   └── tool2.sh
├── compile.sh             # Build automation
└── README.md              # Complete documentation
```

### 6.2 Multi-Language Integration (When Necessary)
```
Mixed Project (Exceptional):
├── java/                  # Core Java functionality
├── node/                  # Server components (if justified)
├── scripts/               # Shell script interfaces
├── docs/                  # Language-specific documentation
│   ├── JavaComponents.md  # Java architecture
│   └── NodeIntegration.md # Node.js justification
└── README.md              # Unified user interface
```

### 6.3 Shell Script Standardization
All shell scripts must follow this template:
```bash
#!/bin/bash
# {ToolName} - {Brief description}
# {Longer description of purpose and functionality}

# Configuration
DEFAULT_MEM="1g"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
    cat << EOF
Purpose: {Clear description}

Usage: $0 [options] arguments

Options:
  -h, --help          Show this help
  -v, --verbose       Enable detailed output
  -Xmx<size>         Set maximum heap size (default: $DEFAULT_MEM)

Examples:
  $0 input.txt
  $0 --verbose -Xmx2g large_input.txt

Dependencies: Java 8+, compiled classes in expected locations
Output: {Description of what this produces}
EOF
}

# Implementation with error handling...
```

## 7. HelloWorld Project Compliance

### 7.1 Current Implementation Analysis
HelloWorld demonstrates excellent language policy compliance:

**✅ Java-First Implementation**:
- All core functionality in Java (HelloTool, WorldTool, ApiWriter)
- Professional package structure (hello/, world/, tools/)
- Clean separation of concerns with utility classes
- No external language dependencies

**✅ Professional Shell Integration**:
- Self-documented launchers (hello.sh, world.sh, apiwriter.sh)
- BBTools-style argument parsing and memory management
- Comprehensive usage() functions with examples
- Error handling and user guidance

**✅ Build System Compliance**:
- Pure Java compilation through compile.sh
- No Python, Conda, or complex dependency management
- Transparent class file placement in package directories
- Cross-platform compatibility verified

### 7.2 Reference Implementation Value
HelloWorld serves as template for:
- **Proper Java project structure** with professional packaging
- **Shell script integration patterns** following BBTools conventions
- **Build system design** that avoids complex dependency management
- **Documentation standards** that support Haiku test compliance

## 8. Migration Guidelines

### 8.1 Legacy Python Code
For existing Python functionality that must be converted:

**Assessment Process**:
1. **Functionality mapping**: What does the Python code actually do?
2. **Java library research**: Are there equivalent Java libraries?
3. **Complexity analysis**: How difficult would Java implementation be?
4. **Integration planning**: How will Java version fit into existing systems?

**Migration Strategy**:
- **Phase 1**: Implement Java equivalent alongside Python version
- **Phase 2**: Validate Java implementation meets all requirements
- **Phase 3**: Switch user-facing scripts to Java version
- **Phase 4**: Remove Python dependencies entirely

### 8.2 Node.js Integration
For justified Node.js components:

**Integration Requirements**:
- **Clear architectural boundaries** between Java and Node.js components
- **Professional deployment** with package.json and documented dependencies
- **Shell script interfaces** that hide Node.js complexity from users
- **Documentation updates** explaining the integration architecture

## 9. Quality Assurance

### 9.1 Language Compliance Checklist
For any new development:

**Pre-Development**:
- [ ] Is Java the primary implementation language?
- [ ] Are exceptions properly justified and documented?
- [ ] Have alternatives to Python been explored thoroughly?
- [ ] Is the language choice consistent with project architecture?

**Post-Implementation**:
- [ ] Are shell script interfaces complete and professional?
- [ ] Does the implementation follow established patterns?
- [ ] Is documentation updated to reflect language choices?
- [ ] Does the project still pass Haiku test requirements?

### 9.2 Continuous Compliance
- **Regular review** of language choices in existing code
- **Documentation updates** when language decisions change
- **Pattern consistency** across all project components
- **Migration planning** for any non-compliant legacy code

## 10. Success Metrics

### 10.1 Compliance Indicators
- **Java percentage**: Fraction of core functionality implemented in Java
- **Shell script coverage**: All Java functionality accessible through scripts
- **Python elimination**: Zero Python dependencies in production code
- **Integration quality**: Clean boundaries between different language components

### 10.2 Operational Benefits
- **Reduced complexity** through consistent language choices
- **Improved maintainability** with unified development patterns
- **Simplified deployment** without complex dependency management
- **Enhanced reliability** through proven technology stack

---

## Summary

This language policy prioritizes **Java-first development** with **professional shell script integration** while allowing carefully justified exceptions for Node.js server functionality and requiring Bash for system operations.

**Python is absolutely forbidden** except in cases where no realistic alternative exists, and complex package management systems like Conda are never acceptable.

By following these standards, projects achieve:
- **Consistent development patterns** that enable rapid developer onboarding
- **Simplified deployment** without complex dependency management
- **Long-term maintainability** through proven, stable technology choices
- **Professional integration** with existing BBTools ecosystem

**Remember**: Language choices have long-term consequences. Choose conservatively, document thoroughly, and maintain consistency across all project components.

---

*This policy implements PRINCIPLE #2: Tactical Technology Stack*
*Written for HelloWorld project reference implementation*
*Version 1.0 - September 16, 2025*