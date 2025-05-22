package com.notedapp.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.actuate.health.HealthComponent;
import org.springframework.boot.actuate.health.HealthEndpoint;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Controller for health checks and readiness probes
 * Used by Azure App Service to verify application health
 */
@RestController
@RequestMapping("/api/health")
public class HealthCheckController {

    @Autowired
    private HealthEndpoint healthEndpoint;
    
    /**
     * Simple health check endpoint that can be called without authentication
     * Used by Azure's monitoring services
     * 
     * @return Basic health status string
     */
    @GetMapping("/status")
    public ResponseEntity<String> healthCheck() {
        return ResponseEntity.ok("OK");
    }
    
    /**
     * Detailed health check that includes database connectivity and other components
     * 
     * @return Application health details from Spring Actuator
     */
    @GetMapping("/details")
    public ResponseEntity<HealthComponent> healthDetails() {
        return ResponseEntity.ok(healthEndpoint.health());
    }
}
