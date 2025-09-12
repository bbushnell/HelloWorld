# Functionality Investigation Guide
*Systematic methodology for understanding and working with existing codebases*

## Core Principle

**"Read Everything, Understand First, Modify Never Without Comprehension"**

Before implementing anything, determine what exists vs what needs implementation. Undocumented functionality is worthless - documentation-first, implementation second.

## The 5-Step Methodology

### Step 1: Read Complete Documentation
- **Start with README.md** - Complete project overview and usage patterns
- **Follow all documentation links** - Don't skip linked guides or references  
- **Understand the project structure** - What packages exist, what tools are available
- **Note discrepancies** - Documentation that doesn't match directory structure

### Step 2: Regenerate Project APIs (If Stale)
- **Check timestamp** - Are .api files older than source code?
- **Regenerate if needed** - Use project's API generation tools
- **Handle generation issues** - Some tools have assertion bugs (-da flag)
- **Verify completeness** - All packages should have corresponding .api files

### Step 3: Read API Files for Current Capabilities
- **Package-level APIs** - What classes and methods actually exist
- **Cross-package dependencies** - How components interact
- **Public interfaces** - What's exposed vs internal implementation
- **Gap identification** - What documentation claims vs what code provides

### Step 4: Test with Haiku Agent
Use a minimal-intelligence agent to verify usability:
```
Launch haiku agent with task: "Follow the README.md to compile and run the primary tool. Document any issues or missing functionality."
```

**The Haiku Test Standard**: If a Haiku instance cannot achieve full functionality based solely on documentation and standard procedures, the system is NOT tactically deployable.

**Document Results**:
- ✅ Working as documented - Update project status  
- ❌ Missing/broken - Create GitHub issues with specific failures
- ⚠️ Partially working - Document workarounds needed

### Step 5: Implementation (Only If Missing/Broken)
- **Read implementation files** - Understand existing patterns before changing
- **Follow project conventions** - Don't introduce inconsistent patterns
- **Implement systematically** - One component at a time
- **Return to Step 4** - Verify your implementation works via Haiku test

## When to Use This Methodology

### MANDATORY Application
- **Before implementing anything** in an existing project
- **When documentation seems incomplete** or inconsistent
- **Before claiming "X doesn't work"** - verify systematically first
- **When handed an unfamiliar codebase** requiring modifications

### Integration with Project Work
1. **Project Resumption**: Always use this before resuming work on existing projects
2. **Feature Requests**: Verify current capabilities before implementing new features
3. **Bug Reports**: Confirm bugs exist and understand scope before fixing
4. **Code Reviews**: Ensure new code integrates with existing functionality

## Common Anti-Patterns to Avoid

### ❌ Jumping to Implementation
```bash
# WRONG: Immediate classpath hacking
export CLASSPATH="$DIR/tools:$DIR/marketing:$DIR/build"  
javac -cp $CLASSPATH *.java
```

### ✅ Documentation-First Approach  
```bash
# CORRECT: Read README.md first, follow established build patterns
sh compile.sh  # Use project's documented build process
```

### ❌ Assumption-Based Functionality
"This project probably doesn't have X, so I'll implement it."

### ✅ Evidence-Based Assessment
1. Read documentation for X
2. Check .api files for X
3. Test with Haiku agent for X  
4. Only then implement if genuinely missing

### ❌ Fabricated Documentation
Creating plausible-sounding .api files without actual generation tools.

### ✅ Generated Documentation
Use project's actual API generation tools, handle bugs with appropriate flags.

## Tool-Specific Applications

### Java Projects
1. **Read README.md** - Compilation and usage instructions
2. **Check .api files** - Generated package overviews  
3. **Use compile.sh** - Don't manually craft javac commands
4. **Test with project's shell scripts** - Follow documented usage patterns

### Shell Script Projects
1. **Check for auxiliary scripts** - memdetect.sh, javasetup.sh patterns
2. **Understand argument parsing** - How complex vs simple patterns
3. **Test help functionality** - Every script should respond to --help
4. **Follow memory/environment patterns** - Laptop vs cluster defaults

### Documentation Projects  
1. **Verify link integrity** - All referenced files exist
2. **Check generation timestamps** - Auto-generated content up to date
3. **Test documentation completeness** - Can Haiku follow instructions successfully
4. **Validate examples** - Do provided examples actually work

## Emergency Protocols

### When Documentation Is Wrong
1. **Document the discrepancy** in project issues
2. **Create minimal fix** - Don't overhaul entire system
3. **Update documentation** - Fix what you found broken
4. **Test fix with Haiku** - Ensure you didn't break other functionality

### When APIs Are Missing/Broken
1. **Try generation with standard flags** first
2. **Use assertion bypass (-da)** if interface bugs exist  
3. **Document generation issues** - Help future developers
4. **Generate all packages** - Don't leave gaps in API coverage

### When Haiku Tests Fail
1. **Identify specific failure points** - Compilation? Usage? Documentation?
2. **Fix most critical blocker** first - Usually compilation or missing files
3. **Incremental improvement** - Don't try to fix everything at once
4. **Retest after each fix** - Ensure progress, not regression

## Verification Standards

### Project Readiness Checklist
- ✅ **Compilation**: `sh compile.sh` succeeds without errors
- ✅ **Primary tool**: Main functionality accessible via documented command
- ✅ **Help system**: `sh tool.sh --help` provides useful information  
- ✅ **API coverage**: All packages have corresponding .api files
- ✅ **Haiku success**: Minimal agent can achieve full functionality from documentation

### Documentation Quality Standards
- ✅ **Completeness**: Every feature mentioned has usage example
- ✅ **Accuracy**: Examples actually work as documented
- ✅ **Accessibility**: Haiku-level agent can follow instructions successfully
- ✅ **Maintenance**: Generated content has recent timestamps

### Implementation Integration Standards
- ✅ **Convention adherence**: New code follows existing patterns
- ✅ **Dependency management**: Uses project's established classpath/build system
- ✅ **Error handling**: Consistent with project's error reporting patterns
- ✅ **Documentation update**: New functionality properly documented

## Success Metrics

### Individual Developer Success
- **Zero classpath hacking** - Always use documented build processes
- **Systematic approach** - Apply 5-step methodology consistently
- **Evidence-based claims** - Never guess about functionality, always verify
- **Integration mindset** - Work with existing patterns, not against them

### Project Success  
- **Haiku Test passing** - Minimal intelligence can achieve full functionality
- **Documentation accuracy** - Claims match reality of implementation
- **Developer onboarding** - New contributors can quickly become productive
- **Maintenance efficiency** - Issues traced to specific, documentable causes

---

*Systematic functionality investigation prevents wasted effort and ensures reliable, maintainable development practices*

## Framework Motto

> **"If it's not documented and testable by Haiku, it doesn't exist operationally."**

Every system must pass the Haiku Test to be considered deployment-ready. This ensures functionality is accessible through documentation alone, without requiring deep codebase knowledge or institutional memory.