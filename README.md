# Krabbel - Smart Note-Taking Application

A full-stack application for secure note-taking with user authentication, built with Spring Boot and Vue.js.

## Project Overview

Krabbel is a secure note-taking application that allows users to:
- Create an account and authenticate
- Create, read, update, and delete notes
- Access notes from anywhere with proper authentication
- Enjoy a responsive and intuitive user interface

## Technology Stack

### Backend
- Java 17
- Spring Boot 3.2.3
- Spring Security with JWT authentication
- Spring Data JPA
- H2 Database (development)
- MySQL (production ready)
- Maven

### Frontend
- Vue.js 3
- Vue Router
- Axios
- Bootstrap 5
- Vite

## Project Structure

The project is organized as a monorepo with the following structure:

```
Krabbel/
├── backend/         # Spring Boot backend
│   ├── src/         # Source code
│   └── pom.xml      # Maven dependencies
├── frontend/        # Vue.js frontend
│   ├── src/         # Source code
│   └── package.json # npm dependencies
└── README.md        # This file
```

## Prerequisites

- Java Development Kit (JDK) 17 or higher
- Node.js 16 or higher
- npm or yarn
- Maven 3.6 or higher
- MySQL (for production)

## Getting Started

### Linux / macOS

1. **Install Backend Dependencies**
   ```bash
   cd backend
   ./mvnw clean install
   ```

2. **Install Frontend Dependencies**
   ```bash
   cd frontend
   npm install
   ```

3. **Start Both Frontend and Backend Together**
   ```bash
   # Start both in the background
   (cd backend && ./mvnw spring-boot:run) & (cd frontend && npm run dev)
   ```

14. **Stop Running Backend Process (if needed)**
   ```bash
   # Option 1: If you started with Ctrl+C in the terminal
   # Simply press Ctrl+C in the terminal where Spring Boot is running
   
   # Option 2: Using Spring Boot Actuator endpoint (if configured)
   curl -X POST http://localhost:8081/actuator/shutdown
   
   # Option 3: If all else fails, find and kill the process
   pid=$(ps -ef | grep spring-boot | grep -v grep | awk '{print $2}')
   if [ -n "$pid" ]; then
     echo "Stopping Spring Boot app with PID: $pid"
     kill $pid
     # Only use kill -9 as a last resort if the process won't terminate
     # kill -9 $pid
   else
     echo "No Spring Boot process found"
   fi
   ```

### Windows

1. **Install Backend Dependencies**
   ```cmd
   cd backend
   mvnw.cmd clean install
   ```

2. **Install Frontend Dependencies**
   ```cmd
   cd frontend
   npm install
   ```

3. **Start Both Frontend and Backend Together**
   ```cmd
   # Option 1: Using two separate command prompts
   # First command prompt:
   cd backend
   mvnw.cmd spring-boot:run
   
   # Second command prompt:
   cd frontend
   npm run dev
   
   # Option 2: Using one command prompt with start
   start cmd /k "cd backend && mvnw.cmd spring-boot:run"
   start cmd /k "cd frontend && npm run dev"
   ```

4. **Stop Running Backend Process (if needed)**
   ```cmd
   # Option 1: If you started with Ctrl+C in the terminal
   # Simply press Ctrl+C in the terminal where Spring Boot is running
   
   # Option 2: Using Spring Boot Actuator endpoint (if configured)
   curl -X POST http://localhost:8081/actuator/shutdown
   
   # Option 3: If all else fails, find and kill the process
   FOR /F "tokens=1" %%A IN ('jps -l ^| findstr KrabbelApplication') DO (
     echo Stopping Spring Boot with PID: %%A
     taskkill /PID %%A
     REM Only use /F as a last resort if the process won't terminate
     REM taskkill /F /PID %%A
   )
   ```

### Access the Application

- Frontend: http://localhost:5173
- Backend API: http://localhost:8081/api/
- Swagger UI: http://localhost:8081/swagger-ui/index.html
- H2 Console: http://localhost:8081/h2-console (JDBC URL: jdbc:h2:mem:noted_db)

## Default Users

The application is pre-configured with two users:

1. Admin User
   - Username: admin
   - Password: admin123
   - Role: ADMIN

2. Regular User
   - Username: user
   - Password: user123
   - Role: USER

## Progress

### Core Requirements
- [x] Implement proper error handling and user feedback
- [x] Add input validation for note creation/editing
- [x] Implement proper password hashing and security measures
- [ ] Add unit tests for both frontend and backend
- [ ] Set up CI/CD pipeline
- [ ] Add proper logging
- [x] Implement proper session management
- [ ] Add rate limiting for API endpoints

### Note Management Features
- [ ] Rich text editor integration for note content
- [x] Note metadata:
  - [x] Title
  - [x] Content (basic text)
  - [ ] Labels/tags
  - [x] Creation/update date and time
  - [ ] Deadlines
  - [ ] Images/attachments
- [ ] Search functionality:
  - [ ] Search by title
  - [ ] Search by tags
- [ ] Filtering:
  - [ ] Filter by date
  - [ ] Filter by tags
- [x] Note actions:
  - [x] Archive notes (soft delete)
  - [x] Delete notes
  - [ ] Share notes with others
  - [ ] Export notes to PDF
- [ ] Version control:
  - [ ] Track note versions
  - [ ] Restore previous versions
- [ ] UI/UX:
  - [ ] Dark mode support
  - [ ] Automatic icon generation for labels
  - [ ] Remember user preferences (filters, theme)
  - [ ] Responsive design

### Frontend Implementation
- [x] Vue 3 with Composition API:
  - [x] Setup login page
  - [x] Setup main notes page
- [x] Bootstrap CSS integration
- [x] Linting setup
- [x] Axios/Fetch implementation for API calls
- [ ] State management for:
  - [x] User authentication
  - [x] Notes data
  - [ ] UI preferences

### Backend Implementation
- [x] MySQL database setup (H2 for development)
- [x] Swagger documentation
- [x] Helper methods:
  - [x] Email validation
  - [x] Password hashing
- [x] CORS configuration
- [x] Dummy data generation
- [x] API endpoints for:
  - [x] User authentication
  - [x] CRUD operations for notes
  - [ ] Note sharing
  - [ ] Version control
  - [ ] Export functionality

### AI Integration (Note Enhancement)
- [ ] Research and select appropriate AI/LLM service (e.g., OpenAI, Anthropic, or self-hosted)
- [ ] Design API endpoints for note processing:
  - [ ] Formatting endpoint
  - [ ] Summarization endpoint
  - [ ] Keyword extraction
  - [ ] Topic categorization
- [ ] Implement backend service for AI processing:
  - [ ] Create service layer for AI interactions
  - [ ] Add caching for processed notes
  - [ ] Implement rate limiting for AI requests
- [ ] Add frontend components:
  - [ ] Note enhancement button/option
  - [ ] Processing status indicators
  - [ ] Preview of AI-suggested changes
  - [ ] User approval workflow
- [ ] Implement features:
  - [ ] Auto-formatting of messy notes
  - [ ] Smart summarization
  - [ ] Keyword/tag suggestions
  - [ ] Topic categorization
  - [ ] Grammar and spelling correction
  - [ ] Structure suggestions for better readability

## License

[ISC License]

## Contributing

Contributions are welcome. Please feel free to submit a Pull Request.