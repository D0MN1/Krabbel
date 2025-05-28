package com.notedapp.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * Root controller to provide basic application information
 * Useful for verifying the application is running on Azure
 */
@RestController
public class RootController {

    @Value("${CORS_ALLOWED_ORIGINS:http://localhost:5173}")
    private String allowedOrigins;

    @GetMapping("/")
    public ResponseEntity<Map<String, Object>> root() {
        Map<String, Object> response = new HashMap<>();
        response.put("application", "Krabbel");
        response.put("description", "Smart Note-Taking Application");
        response.put("status", "running");
        response.put("timestamp", LocalDateTime.now());
        response.put("version", "1.0.0");
        
        Map<String, String> endpoints = new HashMap<>();
        endpoints.put("health", "/api/health/status");
        endpoints.put("login", "/api/auth/login");
        endpoints.put("register", "/api/auth/register");
        endpoints.put("notes", "/api/notes");
        endpoints.put("cors-config", "/cors-config");
        
        response.put("endpoints", endpoints);
        
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/status")
    public ResponseEntity<String> status() {
        return ResponseEntity.ok("Krabbel Backend is Running! ✅");
    }

    @GetMapping("/cors-config")
    public ResponseEntity<Map<String, String>> corsConfig() {
        Map<String, String> response = new HashMap<>();
        response.put("allowedOrigins", allowedOrigins);
        response.put("note", "This endpoint shows the current CORS configuration");
        return ResponseEntity.ok(response);
    }
}
