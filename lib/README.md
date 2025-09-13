# External Dependencies Directory

This directory contains external JAR dependencies for the with-jars branch deployment strategy.

## Dual-Branch Deployment Strategy

### Master Branch (Development)
- This directory is empty by design
- Dependencies detected automatically via `configure.sh`
- Uses system-installed libraries (Eclipse JDT, etc.)
- Optimized for development flexibility

### With-Jars Branch (Production)
- Contains all required JAR files for self-contained deployment
- No external configuration needed
- Enables deployment to systems without pre-installed dependencies
- All JARs committed to version control for consistency

## Directory Structure

```
lib/
├── README.md                    # This file
├── eclipse-jdt-core.jar         # [with-jars only] Eclipse JDT for AST processing
├── eclipse-jdt-ui.jar           # [with-jars only] Eclipse JDT UI components
└── other-dependencies.jar       # [with-jars only] Additional required JARs
```

## Adding New Dependencies

When adding new dependencies to the project:

### For Master Branch (Development)
1. Update `configure.sh` to detect the library
2. Add detection logic for multiple installation paths
3. Update `compile.sh` and tool scripts to use `$BUILD_CLASSPATH`
4. Document in project documentation

### For With-Jars Branch (Production)
1. Obtain the required JAR files
2. Place them in this `lib/` directory
3. Update classpath references in shell scripts
4. Test complete functionality without external dependencies
5. Commit JARs to with-jars branch

## Branch Creation Process

To create a with-jars branch from master:

```bash
# Create new branch
git checkout -b with-jars

# Add dependency JARs to lib/
cp /path/to/eclipse-jdt-core.jar lib/
cp /path/to/other-dependencies.jar lib/

# Update .gitignore to allow JARs in lib/
echo "# Allow JARs in lib/ directory for with-jars branch" >> .gitignore
echo "!lib/*.jar" >> .gitignore

# Update compile.sh for self-contained classpath
# [Edit compile.sh to use lib/*.jar instead of system detection]

# Test complete functionality
sh compile.sh
sh run-tests.sh

# Commit with-jars configuration
git add lib/ .gitignore compile.sh
git commit -m "Add with-jars deployment configuration"
```

## Usage Notes

- **Development**: Use master branch with `configure.sh` for flexible development
- **Production**: Use with-jars branch for guaranteed-working deployments
- **CI/CD**: with-jars branch enables consistent builds across environments
- **Distribution**: with-jars branch provides complete, self-contained packages

## Classpath Integration

Shell scripts automatically detect and use lib/ JARs when present:

```bash
# In shell scripts:
CLASSPATH="$DIR:$DIR/lib/*"
```

This works for both branches:
- Master: `lib/` is empty, uses system classpaths
- With-jars: `lib/*.jar` provides all dependencies

## Maintenance

- Keep lib/ directory structure consistent across branches
- Document all dependencies in this README
- Test both branches regularly for compatibility
- Update JARs periodically for security and features