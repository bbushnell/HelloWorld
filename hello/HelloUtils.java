package hello;

import java.time.LocalTime;
import java.util.Arrays;
import java.util.List;

/**
 * HelloUtils - Utility functions for greeting generation.
 * Demonstrates defensive programming with comprehensive input validation.
 * 
 * @author HelloWorld Example Project  
 * @version 1.0
 */
public class HelloUtils {
    
    /** Valid greeting prefixes based on time of day */
    private static final List<String> MORNING_GREETINGS = Arrays.asList(
        "Good morning", "Good day", "Hello"
    );
    
    private static final List<String> EVENING_GREETINGS = Arrays.asList(
        "Good evening", "Hello", "Greetings"
    );
    
    private static final List<String> DEFAULT_GREETINGS = Arrays.asList(
        "Hello", "Hi", "Greetings"
    );
    
    /**
     * Generates a contextual greeting for the specified name.
     * Uses time-based greeting selection for natural interaction.
     * 
     * @param name The name to greet (must be non-null and non-empty)
     * @return A formatted greeting string
     * @throws IllegalArgumentException if name is null or empty
     */
    public static String generateGreeting(String name) throws IllegalArgumentException {
        assert name != null : "Name cannot be null";
        assert !name.trim().isEmpty() : "Name cannot be empty or whitespace-only";
        
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Name cannot be null or empty");
        }
        
        String cleanName = sanitizeName(name.trim());
        String prefix = selectGreetingPrefix();
        
        String greeting = prefix + ", " + cleanName + "!";
        
        assert greeting != null && !greeting.isEmpty() : "Generated greeting must be valid";
        return greeting;
    }
    
    /**
     * Sanitizes a name for safe display.
     * Removes potentially problematic characters while preserving readability.
     * 
     * @param name The raw name to sanitize
     * @return A sanitized version of the name
     */
    private static String sanitizeName(String name) {
        assert name != null : "Name cannot be null for sanitization";
        
        // Remove potential control characters and excessive whitespace
        String sanitized = name.replaceAll("[\\p{Cntrl}]", "")
                              .replaceAll("\\s+", " ")
                              .trim();
        
        // Limit length to reasonable bounds
        if (sanitized.length() > 50) {
            sanitized = sanitized.substring(0, 50) + "...";
        }
        
        // Ensure we still have something after sanitization
        if (sanitized.isEmpty()) {
            sanitized = "Anonymous";
        }
        
        assert !sanitized.isEmpty() : "Sanitized name must not be empty";
        return sanitized;
    }
    
    /**
     * Selects an appropriate greeting prefix based on current time.
     * Demonstrates time-aware functionality for natural interaction.
     * 
     * @return A greeting prefix appropriate for the current time
     */
    private static String selectGreetingPrefix() {
        LocalTime now = LocalTime.now();
        int hour = now.getHour();
        
        List<String> availableGreetings;
        
        if (hour >= 5 && hour < 12) {
            availableGreetings = MORNING_GREETINGS;
        } else if (hour >= 18 && hour < 22) {
            availableGreetings = EVENING_GREETINGS;
        } else {
            availableGreetings = DEFAULT_GREETINGS;
        }
        
        // Use a simple deterministic selection based on current minute
        // This ensures consistent behavior while still being time-aware
        int index = now.getMinute() % availableGreetings.size();
        String selected = availableGreetings.get(index);
        
        assert selected != null && !selected.isEmpty() : "Selected greeting must be valid";
        return selected;
    }
    
    /**
     * Validates that a name meets basic requirements for greeting generation.
     * 
     * @param name The name to validate
     * @return true if the name is valid for greeting generation
     */
    public static boolean isValidName(String name) {
        if (name == null) return false;
        String trimmed = name.trim();
        return !trimmed.isEmpty() && trimmed.length() <= 100;
    }
}