package world;

import java.util.Arrays;
import java.util.List;

/**
 * WorldUtils - Utility functions for world information generation.
 * Provides factual data with proper validation and error handling.
 * 
 * @author HelloWorld Example Project
 * @version 1.0
 */
public class WorldUtils {
    
    /** Approximate world population (updated periodically) */
    private static final long WORLD_POPULATION = 8_100_000_000L;
    
    /** Major world languages with speaker counts */
    private static final List<String> TOP_LANGUAGES = Arrays.asList(
        "Mandarin Chinese (918M)", "Spanish (460M)", "English (379M)",
        "Hindi (341M)", "Bengali (228M)", "Portuguese (221M)",
        "Russian (154M)", "Japanese (128M)"
    );
    
    /** Continental information */
    private static final List<String> CONTINENTS = Arrays.asList(
        "Asia (30% land, 60% population)",
        "Africa (20% land, 18% population)", 
        "North America (16% land, 8% population)",
        "South America (12% land, 6% population)",
        "Antarctica (10% land, 0% population)",
        "Europe (7% land, 10% population)",
        "Australia/Oceania (6% land, 1% population)"
    );
    
    /**
     * Generates comprehensive world information.
     * Provides factual data about global demographics and geography.
     * 
     * @return Formatted world information string
     * @throws IllegalStateException if world data cannot be generated
     */
    public static String generateWorldInfo() throws IllegalStateException {
        try {
            StringBuilder info = new StringBuilder();
            
            info.append("World Information Summary:\n");
            info.append("========================\n\n");
            
            // Population information
            info.append("Population: ");
            info.append(formatPopulation(WORLD_POPULATION));
            info.append(" people (approximate)\n\n");
            
            // Language information
            info.append("Major languages by speakers:\n");
            for (String language : TOP_LANGUAGES) {
                assert language != null && !language.isEmpty() : "Language entry must be valid";
                info.append("  * ").append(language).append("\n");
            }
            info.append("\n");

            // Continental information
            info.append("Continental distribution:\n");
            for (String continent : CONTINENTS) {
                assert continent != null && !continent.isEmpty() : "Continent entry must be valid";
                info.append("  * ").append(continent).append("\n");
            }
            
            String result = info.toString();
            assert result != null && !result.isEmpty() : "Generated world info must be valid";
            assert result.contains("population") : "World info must contain population data";
            assert result.contains("languages") : "World info must contain language data";
            
            return result;
            
        } catch (Exception e) {
            throw new IllegalStateException("Failed to generate world information: " + e.getMessage(), e);
        }
    }
    
    /**
     * Formats a population number for human-readable display.
     * 
     * @param population The population count to format
     * @return Formatted population string
     * @throws IllegalArgumentException if population is negative
     */
    public static String formatPopulation(long population) throws IllegalArgumentException {
        assert population >= 0 : "Population cannot be negative";
        
        if (population < 0) {
            throw new IllegalArgumentException("Population cannot be negative: " + population);
        }
        
        if (population >= 1_000_000_000L) {
            double billions = population / 1_000_000_000.0;
            return String.format("%.1f billion", billions);
        } else if (population >= 1_000_000L) {
            double millions = population / 1_000_000.0;
            return String.format("%.1f million", millions);
        } else if (population >= 1_000L) {
            double thousands = population / 1_000.0;
            return String.format("%.1f thousand", thousands);
        } else {
            return String.valueOf(population);
        }
    }
    
    /**
     * Validates that world information meets quality standards.
     * 
     * @param worldInfo The world info to validate
     * @return true if the world info is valid and complete
     */
    public static boolean isValidWorldInfo(String worldInfo) {
        if (worldInfo == null || worldInfo.trim().isEmpty()) {
            return false;
        }
        
        String info = worldInfo.toLowerCase();
        return info.contains("population") && 
               info.contains("languages") &&
               info.contains("continental") &&
               info.length() > 100; // Minimum content length
    }
    
    /**
     * Gets the current estimated world population.
     * 
     * @return Current world population estimate
     */
    public static long getWorldPopulation() {
        return WORLD_POPULATION;
    }
}