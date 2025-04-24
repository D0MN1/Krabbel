package com.notedapp.service;

import com.notedapp.dto.auth.RegisterRequest;
import com.notedapp.entity.User;

public interface UserService {
    User register(RegisterRequest request);
    User findByUsername(String username);
    void updateLastLogin(String username);
} 