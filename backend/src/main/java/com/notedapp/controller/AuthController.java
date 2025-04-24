package com.notedapp.controller;

import com.notedapp.dto.auth.AuthResponse;
import com.notedapp.dto.auth.LoginRequest;
import com.notedapp.dto.auth.RegisterRequest;
import com.notedapp.entity.User;
import com.notedapp.security.JwtUtils;
import com.notedapp.service.UserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtils jwtUtils;

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword()));

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateToken((User) authentication.getPrincipal());
        
        User user = (User) authentication.getPrincipal();
        userService.updateLastLogin(user.getUsername());

        return ResponseEntity.ok(new AuthResponse(jwt, user.getUsername(), user.getRole().name()));
    }

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        User user = userService.register(request);
        
        String jwt = jwtUtils.generateToken(user);
        return ResponseEntity.ok(new AuthResponse(jwt, user.getUsername(), user.getRole().name()));
    }
} 