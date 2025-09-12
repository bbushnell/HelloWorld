# HelloTool Basic Functionality Test

## Test Description

This test validates the basic functionality of HelloTool when run with no arguments.

## Expected Behavior

- Tool should execute successfully (exit code 0)
- Should output default greeting "Hello, World!"
- Should not produce any error messages
- Should use default time-based greeting selection

## Validation Rules

1. **contains_greeting**: Output must contain a recognizable greeting word
2. **contains_world**: Output must reference "World" as the default name
3. **proper_format**: Output must follow the expected greeting format
4. **no_errors**: Tool must not produce any error output

## Test Command

```bash
sh hello.sh
```

## Success Criteria

- Exit code: 0
- Standard output matches expected greeting pattern
- No error output produced
- Execution completes within reasonable time

## Notes

- This test may produce different greeting prefixes based on time of day
- The core validation focuses on the presence of "World" and proper formatting
- Serves as baseline functionality verification for the HelloTool