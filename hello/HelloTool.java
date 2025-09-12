package hello;

import java.util.Arrays;

/**
 * HelloTool - Primary greeting tool demonstrating professional Java patterns.
 * Supports customizable greetings with proper argument validation and error handling.
 * 
 * Usage: java hello.HelloTool [name] [options]
 * 
 * @author HelloWorld Example Project
 * @version 1.0
 */
public class HelloTool {
    
    private static boolean verbose = false;
    private static String defaultName = "World";
    
    /**
     * Main entry point for HelloTool.
     * Demonstrates proper argument parsing, assertions, and error handling.
     * 
     * @param args Command line arguments
     */
    public static void main(String[] args) {
        assert args != null : "Arguments array cannot be null";
        
        try {
            String name = parseArguments(args);
            String greeting = HelloUtils.generateGreeting(name);
            
            if (verbose) {
                System.err.println("HelloTool: Generating greeting for '" + name + "'");
            }
            
            System.out.println(greeting);
            
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
     * Parses command line arguments and extracts the name parameter.
     * 
     * @param args Command line arguments
     * @return The name to greet
     * @throws IllegalArgumentException if arguments are invalid
     */
    private static String parseArguments(String[] args) throws IllegalArgumentException {
        assert args != null : "Arguments array cannot be null";
        
        String name = defaultName;
        
        for (String arg : args) {
            assert arg != null : "Individual argument cannot be null";
            
            if ("--help".equals(arg) || "-h".equals(arg)) {
                printUsage();
                System.exit(0);
            } else if ("--verbose".equals(arg) || "-v".equals(arg)) {
                verbose = true;
            } else if (arg.startsWith("--name=")) {
                name = arg.substring("--name=".length());
                if (name.isEmpty()) {
                    throw new IllegalArgumentException("Name cannot be empty");
                }
            } else if (arg.startsWith("-")) {
                throw new IllegalArgumentException("Unknown option: " + arg);
            } else {
                // Treat as positional name argument
                name = arg;
            }
        }
        
        assert name != null && !name.isEmpty() : "Name must be non-null and non-empty";
        return name;
    }
    
    /**
     * Prints usage information to stderr.
     */
    private static void printUsage() {
        System.err.println("HelloTool - Professional greeting generator");
        System.err.println();
        System.err.println("Usage:");
        System.err.println("  java hello.HelloTool [name] [options]");
        System.err.println("  java hello.HelloTool --name=<name> [options]");
        System.err.println();
        System.err.println("Arguments:");
        System.err.println("  name              Name to greet (default: World)");
        System.err.println();
        System.err.println("Options:");
        System.err.println("  --name=<name>     Specify name explicitly");
        System.err.println("  --verbose, -v     Enable verbose output");
        System.err.println("  --help, -h        Show this help message");
        System.err.println();
        System.err.println("Examples:");
        System.err.println("  java hello.HelloTool");
        System.err.println("  java hello.HelloTool Alice");
        System.err.println("  java hello.HelloTool --name=Bob --verbose");
    }
}