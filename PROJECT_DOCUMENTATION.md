# Krabbel - Detailed Project Documentation

This document provides detailed technical information about the Krabbel architecture, components, and workflows.

## Table of Contents
- [Architecture Overview](#architecture-overview)
- [Backend Components](#backend-components)
- [Frontend Components](#frontend-components)
- [Authentication Flow](#authentication-flow)
- [Data Models](#data-models)
- [API Endpoints](#api-endpoints)
- [Configuration](#configuration)
- [Development Workflow](#development-workflow)
- [Testing](#testing)
- [Production Deployment](#production-deployment)

## Architecture Overview

Krabbel follows a modern client-server architecture with:

1. **Spring Boot Backend**: RESTful API services, authentication, and data persistence
2. **Vue.js Frontend**: Single Page Application (SPA) that communicates with the backend via HTTP
3. **JWT Authentication**: Stateless authentication mechanism
4. **Database Layer**: JPA with H2 (development) and MySQL (production) support

### System Diagram

```
┌───────────────┐     HTTP/JSON     ┌────────────────┐     JPA      ┌────────────┐
│   Vue.js SPA  │ ────────────────> │  Spring Boot   │ ───────────> │  Database  │
│   (Browser)   │ <──────────────── │  REST API      │ <─────────── │  (H2/MySQL)│
└───────────────┘                   └────────────────┘              └────────────┘
                                         │
                                         │ Authentication
                                         ▼
                                    ┌────────────────┐
                                    │  Spring        │
                                    │  Security+JWT  │
                                    └────────────────┘
```

## Backend Components

### Core Dependencies

- **Spring Boot 3.2.3**: Main framework providing auto-configuration and standalone application capabilities
- **Spring Web**: REST API development
- **Spring Security**: Authentication and authorization
- **Spring Data JPA**: Data access layer
- **H2 Database**: In-memory database for development
- **MySQL Connector**: For production database connectivity
- **JSON Web Token (JWT)**: JWT libraries for authentication
- **Lombok**: Reduces boilerplate code
- **Swagger/SpringDoc**: API documentation

### Key Components

#### 1. Entity Models

- **User**: Represents application users with authentication details
- **Note**: Represents user notes with CRUD capabilities

#### 2. Controllers

- **AuthController**: Handles user authentication (login/register)
- **NoteController**: Manages note CRUD operations

#### 3. Services

- **UserService**: User management operations
- **NoteService**: Note management operations

#### 4. Security

- **JwtUtils**: JWT token generation and validation
- **JwtAuthenticationFilter**: Intercepts requests for JWT validation
- **SecurityConfig**: Security configuration defining access rules

#### 5. Data Access

- **UserRepository**: JPA repository for User entity
- **NoteRepository**: JPA repository for Note entity

## Frontend Components

### Core Dependencies

- **Vue.js 3**: Progressive JavaScript framework for building UIs
- **Vue Router**: Client-side routing
- **Axios**: HTTP client for API requests
- **Bootstrap 5**: CSS framework for styling

### Key Components

#### 1. Router

- Configures application routes and view components
- Handles navigation guards for authenticated routes

#### 2. Views

- **Login/Register**: Authentication forms
- **Notes Dashboard**: Main view displaying user notes
- **Note Editor**: Create/edit note interface

#### 3. Components

- **Navbar**: Navigation component
- **NoteList**: Displays user notes
- **NoteCard**: Individual note display

#### 4. Services

- **AuthService**: Handles authentication API requests
- **NoteService**: Manages note API requests

## Authentication Flow

1. **User Registration**:
   - User submits registration form
   - Backend validates data and creates new user
   - JWT token generated and returned

2. **User Login**:
   - User submits credentials
   - Backend authenticates and generates JWT
   - Frontend stores JWT in localStorage

3. **Authenticated Requests**:
   - Frontend includes JWT in Authorization header
   - Backend validates JWT for each protected request
   - Unauthorized requests are rejected with 401

4. **Logout**:
   - Frontend removes JWT from localStorage
   - User redirected to login page

## Data Models

### User Entity

```java
public class User implements UserDetails {
    private Long id;
    private String username;
    private String password;
    private String email;
    private Role role;
    private LocalDateTime createdAt;
    private LocalDateTime lastLogin;
    private String apiKey;
    
    public enum Role {
        USER, ADMIN
    }
}
```

### Note Entity

```java
public class Note {
    private Long id;
    private User user;
    private String title;
    private String content;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private boolean isDeleted;
}
```

## API Endpoints

### Authentication

- `POST /api/auth/login`: Authenticate user and get JWT token
- `POST /api/auth/register`: Register new user

### Notes

- `GET /api/notes`: Get all notes for authenticated user
- `GET /api/notes/{id}`: Get specific note by ID
- `GET /api/notes/search?keyword=query`: Search notes by keyword in title or content
- `POST /api/notes`: Create new note
- `PUT /api/notes/{id}`: Update existing note
- `DELETE /api/notes/{id}`: Delete note

## Configuration

### Backend Properties

Main application properties (`application.properties`):

```properties
# Server
server.port=8081

# Database
spring.datasource.url=jdbc:h2:mem:noted_db
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
spring.h2.console.enabled=true

# JPA
spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.show-sql=true

# JWT
jwt.secret=your_jwt_secret_key
jwt.expiration=86400000 # 24 hours
```

### Frontend Configuration

Environment variables for API endpoints:

```js
// main.js or .env file
axios.defaults.baseURL = 'http://localhost:8081'
```

## Development Workflow

### Backend Development

1. Run the Spring Boot application:
   ```
   cd backend
   mvn spring-boot:run
   ```

2. Access Swagger UI for API testing:
   ```
   http://localhost:8081/swagger-ui/index.html
   ```

3. Access H2 Console for database inspection:
   ```
   http://localhost:8081/h2-console
   JDBC URL: jdbc:h2:mem:noted_db
   User: sa
   Password: (leave empty)
   ```

### Frontend Development

1. Run the development server:
   ```
   cd frontend
   npm run dev
   ```

2. Access the application:
   ```
   http://localhost:5173
   ```

## Testing

### Backend Testing

The backend includes unit and integration tests:

```
cd backend
mvn test
```

### Frontend Testing

The frontend can be tested using:

```
cd frontend
npm run test
```

## Production Deployment

### Backend Deployment

1. Configure production database:
   - Update `application-prod.properties` with MySQL configuration
   - Secure JWT secret key

2. Build production JAR:
   ```
   mvn clean package -Pprod
   ```

3. Run with production profile:
   ```
   java -jar target/noted-backend-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod
   ```

### Frontend Deployment

1. Build for production:
   ```
   npm run build
   ```

2. Deploy `dist` directory to web server 