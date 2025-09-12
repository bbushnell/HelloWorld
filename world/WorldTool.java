package world;

import hello.HelloUtils;

/**
 * WorldTool - Secondary tool demonstrating cross-package interaction.
 * Generates world information and interacts with HelloTool functionality.
 * 
 * Usage: java world.WorldTool [options]
 * 
 * @author HelloWorld Example Project
 * @version 1.0
 */
public class WorldTool {
    
    private static boolean verbose = false;
    
    /**
     * Main entry point for WorldTool.
     * Demonstrates cross-package usage and different tool patterns.
     * 
     * @param args Command line arguments
     */
    public static void main(String[] args) {
        assert args != null : "Arguments array cannot be null";
        
        try {
            parseArguments(args);
            
            if (verbose) {
                System.err.println("WorldTool: Generating world information");
            }
            
            // Demonstrate cross-package interaction
            String worldGreeting = HelloUtils.generateGreeting("World");
            String worldInfo = WorldUtils.generateWorldInfo();
            
            System.out.println(worldGreeting);
            System.out.println(worldInfo);
            
            // Demonstrate assertion density with validation
            validateOutput(worldGreeting, worldInfo);
            
        } catch (IllegalArgumentException e) {
            System.err.println("Error: " + e.getMessage());
            printUsage();
            System.exit(1);
        } catch (Exception e) {
            System.err.println("Unexpected error: " + e.getMessage());
            if (verbose) {
                e.printStackTrace();
            }
            System.exit(1);
        }
    }
    
    /**
     * Parses command line arguments.
     * 
     * @param args Command line arguments
     * @throws IllegalArgumentException if arguments are invalid
     */
    private static void parseArguments(String[] args) throws IllegalArgumentException {
        assert args != null : "Arguments array cannot be null";
        
        for (String arg : args) {
            assert arg != null : "Individual argument cannot be null";
            
            if ("--help".equals(arg) || "-h".equals(arg)) {
                printUsage();
                System.exit(0);
            } else if ("--verbose".equals(arg) || "-v".equals(arg)) {
                verbose = true;
            } else if (arg.startsWith("-")) {
                throw new IllegalArgumentException("Unknown option: " + arg);
            } else {
                throw new IllegalArgumentException("Unexpected argument: " + arg);
            }
        }
    }
    
    /**
     * Validates that the generated output meets quality requirements.
     * Demonstrates defensive programming with comprehensive validation.
     * 
     * @param greeting The greeting to validate
     * @param worldInfo The world info to validate
     * @throws IllegalStateException if output validation fails
     */
    private static void validateOutput(String greeting, String worldInfo) throws IllegalStateException {
        assert greeting != null : "Greeting cannot be null";
        assert worldInfo != null : "World info cannot be null";
        assert !greeting.isEmpty() : "Greeting cannot be empty";
        assert !worldInfo.isEmpty() : "World info cannot be empty";
        
        if (greeting == null || greeting.isEmpty()) {
            throw new IllegalStateException("Generated greeting is invalid");
        }
        
        if (worldInfo == null || worldInfo.isEmpty()) {
            throw new IllegalStateException("Generated world info is invalid");
        }
        
        // Validate greeting format
        if (!greeting.contains("World") && !greeting.contains("world")) {
            throw new IllegalStateException("Greeting should reference the world");
        }
        
        // Validate world info content
        if (!worldInfo.contains("population") || !worldInfo.contains("languages")) {
            throw new IllegalStateException("World info should contain population and language data");
        }
        
        if (verbose) {
            System.err.println("WorldTool: Output validation passed");
        }
    }
    
    /**
     * Prints usage information to stderr.
     */
    private static void printUsage() {
        System.err.println("WorldTool - World information generator");
        System.err.println();
        System.err.println("Usage:");
        System.err.println("  java world.WorldTool [options]");
        System.err.println();
        System.err.println("Options:");
        System.err.println("  --verbose, -v     Enable verbose output");
        System.err.println("  --help, -h        Show this help message");
        System.err.println();
        System.err.println("Description:");
        System.err.println("  Generates world information and demonstrates cross-package");
        System.err.println("  interaction with hello package functionality.");
        System.err.println();
        System.err.println("Examples:");
        System.err.println("  java world.WorldTool");
        System.err.println("  java world.WorldTool --verbose");
    }
}