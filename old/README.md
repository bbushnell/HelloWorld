# Archive Directory

This directory contains archived versions of files following the BBTools project pattern.

## Archival Policy

**RULE: NEVER DELETE - ALWAYS ARCHIVE FIRST**

When modifying or replacing important files:

1. **Copy to old/ with timestamp:**
   ```bash
   cp important_file.txt old/important_file_archive_YYYYMMDD_HHMMSS_description.txt
   ```

2. **Then modify the original**

3. **Use descriptive archive names:**
   - `README_archive_20250912_235900_before_validation_update.md`
   - `compile_archive_20250912_120000_before_api_integration.sh`
   - `HelloTool_archive_20250912_080000_before_unicode_fix.java`

## Examples

```bash
# Before major refactoring
cp README.md old/README_archive_20250912_235900_before_structure_update.md

# Before bug fixes
cp world/WorldUtils.java old/WorldUtils_archive_20250912_120000_before_unicode_fix.java

# Before configuration changes
cp compile.sh old/compile_archive_20250912_080000_before_validation_system.sh
```

## Why Archive?

- **Rollback capability**: Easy to restore previous versions
- **Development history**: Track what changed and when
- **Debugging**: Compare current vs. previous implementations
- **Learning**: See evolution of code over time
- **Safety**: No fear of experimentation when you can always go back

## Directory Organization

Archives are kept flat in this directory with descriptive timestamps. No subdirectories needed - the filename contains all context.

## Retention Policy

- Keep archives indefinitely for major releases
- Clean up experimental archives after successful integration
- Never delete archives from production releases
- Compress very old archives if space becomes an issue

---

*Following BBTools archival patterns for safe development practices*