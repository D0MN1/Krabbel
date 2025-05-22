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
    
    @Value("${admin.default.password:admin123}")
    private String adminDefaultPassword;
    
    @Value("${user.default.password:user123}")
    private String userDefaultPassword;
    
    @Value("${spring.profiles.active:dev}")
    private String activeProfile;

    @Override
    public void run(String... args) {
        logger.info("Initializing data with profile: {}", activeProfile);
        
        // Create admin user
        if (!userRepository.existsByUsername("admin")) {
            User admin = new User();
            admin.setUsername("admin");
            admin.setPassword(passwordEncoder.encode(adminDefaultPassword));
            admin.setEmail("admin@notedapp.com");
            admin.setRole(User.Role.ADMIN);
            userRepository.save(admin);
            logger.info("Admin user created");
        }

        // Create regular user only in dev mode
        if (!activeProfile.equals("prod") && !userRepository.existsByUsername("user")) {
            User user = new User();
            user.setUsername("user");
            user.setPassword(passwordEncoder.encode(userDefaultPassword));
            user.setEmail("user@notedapp.com");
            user.setRole(User.Role.USER);
            userRepository.save(user);
            logger.info("Test user created in {} environment", activeProfile);
        }
    }
} 