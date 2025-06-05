package com.notedapp.config;

import com.notedapp.entity.User;
import com.notedapp.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Component
public class DataInitializer implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(DataInitializer.class);

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Value("${ADMIN_DEFAULT_PASSWORD:admin123}")
    private String adminDefaultPassword;
    
    @Value("${USER_DEFAULT_PASSWORD:user123}")
    private String userDefaultPassword;
    
    @Value("${spring.profiles.active:dev}")
    private String activeProfile;

    @Override
    public void run(String... args) {
        logger.info("Initializing data with profile: {}", activeProfile);
        logger.info("Admin default password: {}", adminDefaultPassword);
        logger.info("User default password: {}", userDefaultPassword);
        
        // Check and create admin user
        boolean adminExists = userRepository.existsByUsername("admin");
        logger.info("Admin user exists: {}", adminExists);
        
        if (!adminExists) {
            User admin = new User();
            admin.setUsername("admin");
            String encodedAdminPassword = passwordEncoder.encode(adminDefaultPassword);
            admin.setPassword(encodedAdminPassword);
            admin.setEmail("admin@notedapp.com");
            admin.setRole(User.Role.ADMIN);
            User savedAdmin = userRepository.save(admin);
            logger.info("Admin user created with ID: {}, password length: {}", savedAdmin.getId(), encodedAdminPassword.length());
        } else {
            logger.info("Admin user already exists, skipping creation");
        }

        // Check and create regular user only in dev mode
        boolean userExists = userRepository.existsByUsername("user");
        logger.info("Regular user exists: {}", userExists);
        
        if (!activeProfile.equals("prod") && !userExists) {
            User user = new User();
            user.setUsername("user");
            String encodedUserPassword = passwordEncoder.encode(userDefaultPassword);
            user.setPassword(encodedUserPassword);
            user.setEmail("user@notedapp.com");
            user.setRole(User.Role.USER);
            User savedUser = userRepository.save(user);
            logger.info("Test user created in {} environment with ID: {}, password length: {}", activeProfile, savedUser.getId(), encodedUserPassword.length());
        } else if (activeProfile.equals("prod")) {
            logger.info("Production profile detected, skipping test user creation");
        } else {
            logger.info("Test user already exists, skipping creation");
        }
        
        // Log total user count
        long totalUsers = userRepository.count();
        logger.info("Total users in database: {}", totalUsers);
    }
} 