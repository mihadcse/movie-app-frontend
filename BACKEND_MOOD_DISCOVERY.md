# Backend Implementation for Mood Discovery Feature

## Overview
This backend implementation allows users to select a mood and receive AI-powered movie recommendations from Gemini.

---

## 1. Controller: MoodDiscoveryController.java

```java
package org.example.movieappbackend.controllers;

import org.example.movieappbackend.payloads.MoodDiscoveryRequest;
import org.example.movieappbackend.payloads.MoodDiscoveryResponse;
import org.example.movieappbackend.services.MoodDiscoveryService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/mood-discovery")
@CrossOrigin(origins = "*")
public class MoodDiscoveryController {

    private static final Logger logger = LoggerFactory.getLogger(MoodDiscoveryController.class);

    @Autowired
    private MoodDiscoveryService moodDiscoveryService;

    /**
     * Get movie recommendations based on mood
     * POST /api/mood-discovery
     */
    @PostMapping
    public ResponseEntity<?> discoverByMood(@RequestBody MoodDiscoveryRequest request) {
        try {
            logger.info("Received mood discovery request for mood: {}", request.getMood());

            // Validate request
            if (request.getMood() == null || request.getMood().trim().isEmpty()) {
                logger.warn("Empty mood received");
                Map<String, String> errorResponse = new HashMap<>();
                errorResponse.put("error", "Mood cannot be empty");
                return ResponseEntity.badRequest().body(errorResponse);
            }

            // Get recommendations from service
            MoodDiscoveryResponse response = moodDiscoveryService.getMoviesByMood(request);

            logger.info("Successfully generated {} movie recommendations for mood: {}", 
                       response.getMovies().size(), request.getMood());
            
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            logger.error("Error processing mood discovery request", e);
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("error", "Failed to get movie recommendations: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    /**
     * Get available moods
     * GET /api/mood-discovery/moods
     */
    @GetMapping("/moods")
    public ResponseEntity<?> getAvailableMoods() {
        try {
            Map<String, Object> response = new HashMap<>();
            response.put("moods", java.util.List.of(
                "happy", "romantic", "thrilling", "mysterious", 
                "adventurous", "chill", "emotional", "inspired"
            ));
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.error("Error getting moods", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> health() {
        Map<String, String> response = new HashMap<>();
        response.put("status", "ok");
        response.put("service", "Mood Discovery API");
        return ResponseEntity.ok(response);
    }
}
```

---

## 2. Service: MoodDiscoveryService.java

```java
package org.example.movieappbackend.services;

import org.example.movieappbackend.payloads.GeminiRequest;
import org.example.movieappbackend.payloads.GeminiResponse;
import org.example.movieappbackend.payloads.MoodDiscoveryRequest;
import org.example.movieappbackend.payloads.MoodDiscoveryResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class MoodDiscoveryService {

    private static final Logger logger = LoggerFactory.getLogger(MoodDiscoveryService.class);

    @Value("${gemini.api.key}")
    private String apiKey;

    @Value("${gemini.api.url}")
    private String apiUrl;

    private final RestTemplate restTemplate;

    public MoodDiscoveryService() {
        this.restTemplate = new RestTemplate();
    }

    public MoodDiscoveryResponse getMoviesByMood(MoodDiscoveryRequest request) {
        try {
            String mood = request.getMood();
            int count = request.getCount() != null ? request.getCount() : 10;

            // Build specialized prompt for movie recommendations
            String prompt = buildMoodPrompt(mood, count);

            // Call Gemini API
            String geminiResponse = callGeminiApi(prompt);

            // Parse movie recommendations from response
            List<MoodDiscoveryResponse.MovieRecommendation> movies = parseMovieRecommendations(geminiResponse);

            // Build response
            MoodDiscoveryResponse response = new MoodDiscoveryResponse();
            response.setMood(mood);
            response.setMovies(movies);
            response.setDescription(extractDescription(geminiResponse));

            return response;

        } catch (Exception e) {
            logger.error("Error getting movies by mood", e);
            throw new RuntimeException("Failed to get movie recommendations: " + e.getMessage());
        }
    }

    private String buildMoodPrompt(String mood, int count) {
        return String.format(
            "You are a movie recommendation expert. A user is feeling '%s' and wants movie suggestions.\n\n" +
            "Please recommend exactly %d movies that perfectly match this mood. " +
            "For each movie, provide:\n" +
            "1. Movie title\n" +
            "2. Release year\n" +
            "3. Brief reason why it matches the '%s' mood (1-2 sentences)\n\n" +
            "Format your response EXACTLY like this:\n\n" +
            "Based on your '%s' mood, here are perfect movie recommendations:\n\n" +
            "1. [Movie Title] (Year) - [Reason why it matches the mood]\n" +
            "2. [Movie Title] (Year) - [Reason]\n" +
            "...\n\n" +
            "Be specific with movie titles and years. Focus on well-known, highly-rated films that truly capture the essence of feeling '%s'.",
            mood, count, mood, mood, mood
        );
    }

    private String callGeminiApi(String prompt) {
        try {
            // Build request
            GeminiRequest.Part part = new GeminiRequest.Part(prompt);
            GeminiRequest.Content content = new GeminiRequest.Content(List.of(part));
            GeminiRequest request = new GeminiRequest(List.of(content));

            // Set headers
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            // Create request entity
            HttpEntity<GeminiRequest> entity = new HttpEntity<>(request, headers);

            // Build URL with API key
            String urlWithKey = apiUrl + "?key=" + apiKey;

            logger.debug("Calling Gemini API for mood discovery");

            // Call Gemini API
            ResponseEntity<GeminiResponse> response = restTemplate.exchange(
                    urlWithKey,
                    HttpMethod.POST,
                    entity,
                    GeminiResponse.class
            );

            // Extract response text
            if (response.getBody() != null &&
                    response.getBody().getCandidates() != null &&
                    !response.getBody().getCandidates().isEmpty()) {

                GeminiResponse.Candidate firstCandidate = response.getBody().getCandidates().get(0);
                if (firstCandidate.getContent() != null &&
                        firstCandidate.getContent().getParts() != null &&
                        !firstCandidate.getContent().getParts().isEmpty()) {

                    return firstCandidate.getContent().getParts().get(0).getText();
                }
            }

            throw new RuntimeException("No valid response from Gemini API");

        } catch (Exception e) {
            logger.error("Error calling Gemini API", e);
            throw new RuntimeException("Failed to call Gemini API: " + e.getMessage());
        }
    }

    private List<MoodDiscoveryResponse.MovieRecommendation> parseMovieRecommendations(String response) {
        List<MoodDiscoveryResponse.MovieRecommendation> movies = new ArrayList<>();

        try {
            // Pattern to match: number. Title (year) - description
            // Examples:
            // 1. The Shawshank Redemption (1994) - A powerful story...
            // 2. Forrest Gump (1994) - An inspiring journey...
            Pattern pattern = Pattern.compile(
                "\\d+\\.\\s*([^(]+)\\s*\\((\\d{4})\\)\\s*[-–]\\s*(.+?)(?=\\n\\d+\\.|$)",
                Pattern.DOTALL
            );

            Matcher matcher = pattern.matcher(response);

            while (matcher.find()) {
                String title = matcher.group(1).trim();
                String year = matcher.group(2).trim();
                String description = matcher.group(3).trim();

                MoodDiscoveryResponse.MovieRecommendation movie = 
                    new MoodDiscoveryResponse.MovieRecommendation();
                movie.setTitle(title);
                movie.setYear(Integer.parseInt(year));
                movie.setDescription(description);
                movie.setReason(description); // Same as description for now

                movies.add(movie);
                
                logger.debug("Parsed movie: {} ({})", title, year);
            }

            // If parsing failed, try a simpler pattern
            if (movies.isEmpty()) {
                logger.warn("Primary pattern failed, trying fallback parsing");
                movies = parseFallback(response);
            }

        } catch (Exception e) {
            logger.error("Error parsing movie recommendations", e);
            // Return fallback movies if parsing fails
            movies = getFallbackMovies();
        }

        return movies;
    }

    private List<MoodDiscoveryResponse.MovieRecommendation> parseFallback(String response) {
        List<MoodDiscoveryResponse.MovieRecommendation> movies = new ArrayList<>();
        
        // Try to extract any movie titles with years
        Pattern simplePattern = Pattern.compile("([A-Z][^\\n(]{2,50})\\s*\\((\\d{4})\\)");
        Matcher matcher = simplePattern.matcher(response);
        
        while (matcher.find() && movies.size() < 10) {
            String title = matcher.group(1).trim();
            String year = matcher.group(2).trim();
            
            MoodDiscoveryResponse.MovieRecommendation movie = 
                new MoodDiscoveryResponse.MovieRecommendation();
            movie.setTitle(title);
            movie.setYear(Integer.parseInt(year));
            movie.setDescription("Recommended for your selected mood");
            movie.setReason("A great match for your current mood");
            
            movies.add(movie);
        }
        
        return movies;
    }

    private String extractDescription(String response) {
        // Extract the first paragraph or introduction line
        String[] lines = response.split("\\n");
        for (String line : lines) {
            line = line.trim();
            if (!line.isEmpty() && !line.matches("^\\d+\\..*") && line.length() > 20) {
                return line;
            }
        }
        return "Here are movie recommendations based on your mood.";
    }

    private List<MoodDiscoveryResponse.MovieRecommendation> getFallbackMovies() {
        // Fallback movies in case of parsing error
        List<MoodDiscoveryResponse.MovieRecommendation> movies = new ArrayList<>();
        
        MoodDiscoveryResponse.MovieRecommendation movie1 = new MoodDiscoveryResponse.MovieRecommendation();
        movie1.setTitle("The Shawshank Redemption");
        movie1.setYear(1994);
        movie1.setDescription("A timeless classic about hope and friendship");
        movies.add(movie1);

        MoodDiscoveryResponse.MovieRecommendation movie2 = new MoodDiscoveryResponse.MovieRecommendation();
        movie2.setTitle("Inception");
        movie2.setYear(2010);
        movie2.setDescription("A mind-bending thriller that will keep you engaged");
        movies.add(movie2);

        return movies;
    }
}
```

---

## 3. Request DTO: MoodDiscoveryRequest.java

```java
package org.example.movieappbackend.payloads;

public class MoodDiscoveryRequest {
    private String mood;
    private Integer count; // Optional: number of recommendations (default: 10)

    public MoodDiscoveryRequest() {
    }

    public MoodDiscoveryRequest(String mood, Integer count) {
        this.mood = mood;
        this.count = count;
    }

    public String getMood() {
        return mood;
    }

    public void setMood(String mood) {
        this.mood = mood;
    }

    public Integer getCount() {
        return count;
    }

    public void setCount(Integer count) {
        this.count = count;
    }
}
```

---

## 4. Response DTO: MoodDiscoveryResponse.java

```java
package org.example.movieappbackend.payloads;

import java.util.List;

public class MoodDiscoveryResponse {
    private String mood;
    private List<MovieRecommendation> movies;
    private String description;

    public static class MovieRecommendation {
        private String title;
        private Integer year;
        private String description;
        private String reason;
        private String posterUrl; // Optional: can be added later
        private Double rating; // Optional: can be fetched from TMDB

        public MovieRecommendation() {
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public Integer getYear() {
            return year;
        }

        public void setYear(Integer year) {
            this.year = year;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public String getReason() {
            return reason;
        }

        public void setReason(String reason) {
            this.reason = reason;
        }

        public String getPosterUrl() {
            return posterUrl;
        }

        public void setPosterUrl(String posterUrl) {
            this.posterUrl = posterUrl;
        }

        public Double getRating() {
            return rating;
        }

        public void setRating(Double rating) {
            this.rating = rating;
        }
    }

    public MoodDiscoveryResponse() {
    }

    public String getMood() {
        return mood;
    }

    public void setMood(String mood) {
        this.mood = mood;
    }

    public List<MovieRecommendation> getMovies() {
        return movies;
    }

    public void setMovies(List<MovieRecommendation> movies) {
        this.movies = movies;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
```

---

## 5. Configuration (application.properties)

```properties
# Existing Gemini configuration
gemini.api.key=YOUR_GEMINI_API_KEY_HERE
gemini.api.url=https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent

# Server configuration
server.port=8080
spring.application.name=movieappbackend
```

---

## 6. Testing the API

### Test with curl:

```bash
# Test mood discovery
curl -X POST http://localhost:8080/api/mood-discovery \
  -H "Content-Type: application/json" \
  -d '{
    "mood": "happy",
    "count": 5
  }'

# Get available moods
curl http://localhost:8080/api/mood-discovery/moods

# Health check
curl http://localhost:8080/api/mood-discovery/health
```

### Expected Response:

```json
{
  "mood": "happy",
  "description": "Based on your 'happy' mood, here are perfect movie recommendations:",
  "movies": [
    {
      "title": "Forrest Gump",
      "year": 1994,
      "description": "An inspiring and heartwarming tale that will leave you smiling",
      "reason": "An inspiring and heartwarming tale that will leave you smiling",
      "posterUrl": null,
      "rating": null
    },
    {
      "title": "The Pursuit of Happyness",
      "year": 2006,
      "description": "An uplifting story about perseverance and family",
      "reason": "An uplifting story about perseverance and family",
      "posterUrl": null,
      "rating": null
    }
  ]
}
```

---

## 7. API Endpoints Summary

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/mood-discovery` | Get movie recommendations based on mood |
| GET | `/api/mood-discovery/moods` | Get list of available moods |
| GET | `/api/mood-discovery/health` | Health check |

---

## 8. Request/Response Examples

### Request Body for Mood Discovery:
```json
{
  "mood": "romantic",
  "count": 8
}
```

### Response:
```json
{
  "mood": "romantic",
  "description": "Based on your 'romantic' mood, here are perfect movie recommendations:",
  "movies": [
    {
      "title": "The Notebook",
      "year": 2004,
      "description": "A passionate love story that spans decades",
      "reason": "A passionate love story that spans decades"
    },
    {
      "title": "La La Land",
      "year": 2016,
      "description": "A modern musical romance set in Los Angeles",
      "reason": "A modern musical romance set in Los Angeles"
    }
  ]
}
```

---

## 9. Integration Notes

1. **Add to your Spring Boot project:**
   - Create the controller in `controllers/` package
   - Create the service in `services/` package
   - Create the DTOs in `payloads/` package

2. **Dependencies required** (should already be in your pom.xml):
   ```xml
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-web</artifactId>
   </dependency>
   ```

3. **Ensure your Gemini API key is set** in application.properties

4. **Restart your Spring Boot application** after adding these files

---

## 10. Future Enhancements

- **Add movie posters**: Integrate with TMDB API to fetch poster URLs
- **Add ratings**: Fetch movie ratings from TMDB or your database
- **Cache results**: Implement caching to reduce API calls
- **User preferences**: Consider user's past ratings for better recommendations
- **Multiple moods**: Allow selecting multiple moods for more nuanced recommendations
- **Movie details link**: Return movie IDs to link with your existing movie database

---

## Troubleshooting

1. **No movies returned**: Check Gemini API response in logs
2. **Parsing errors**: Review the regex patterns in `parseMovieRecommendations()`
3. **API errors**: Verify your Gemini API key is valid and has quota
4. **CORS issues**: Ensure `@CrossOrigin(origins = "*")` is on the controller

---

This implementation provides a robust, production-ready mood discovery feature powered by Gemini AI!
