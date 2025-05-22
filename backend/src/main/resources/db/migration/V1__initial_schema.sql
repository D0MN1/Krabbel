-- Initial Schema for Krabbel Application

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    role ENUM('USER', 'ADMIN') NOT NULL,
    api_key VARCHAR(255),
    created_at TIMESTAMP NOT NULL,
    last_login TIMESTAMP
);

-- Notes table
CREATE TABLE IF NOT EXISTS notes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    is_deleted BIT NOT NULL,
    user_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Initial admin user (with password: admin123)
INSERT INTO users (username, password, email, role, created_at) 
VALUES ('admin', '$2a$10$XrJsLlJWZxrBVuvwUioNw.ThmMUJBGfdseleQuTkLjo8XN0w9LYpa', 'admin@notedapp.com', 'ADMIN', NOW())
ON DUPLICATE KEY UPDATE username = username;

-- Initial regular user (with password: user123)
INSERT INTO users (username, password, email, role, created_at) 
VALUES ('user', '$2a$10$BpPrfyIzgeiGNWLsrsXmZOQEv9MWguEt8YALLeAQc2uQLABbdRygy', 'user@notedapp.com', 'USER', NOW())
ON DUPLICATE KEY UPDATE username = username;
