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
├── backend/             # Spring Boot backend
│   ├── src/             # Source code
│   └── pom.xml          # Maven dependencies
├── frontend/            # Vue.js frontend
│   ├── src/             # Source code
│   └── package.json     # npm dependencies
├── scripts/             # Utility scripts
│   ├── deploy-to-azure.sh
│   └── verify-deployment.sh
├── run.sh               # Cross-platform run script
├── run.bat              # Windows run script
├── prepare-production.sh # Production preparation script
├── prepare-production.bat # Windows production preparation script
├── .env.template        # Template for environment variables
└── README.md            # This file
```

## Prerequisites

- Java Development Kit (JDK) 17 or higher
- Node.js 16 or higher
- npm or yarn
- Maven 3.6 or higher
- MySQL/MariaDB 8.0+ (for production)
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
   # Using the unified run script (recommended)
   ./run.sh
   
   # With specific profile
   ./run.sh --profile dev
   
   # Run only backend
   ./run.sh --backend-only
   
   # Run only frontend
   ./run.sh --frontend-only
   
   # Alternative: Start both in the background manually
   (cd backend && ./mvnw spring-boot:run) & (cd frontend && npm run dev)
   ```

4. **Stop Running Backend Process (if needed)**
   ```bash
   # Option 1: If you started with Ctrl+C in the terminal
   # Simply press Ctrl+C in the terminal where Spring Boot is running
   
   # Option 2: Using Spring Boot Actuator endpoint
   curl -X POST http://localhost:8080/actuator/shutdown
   
   # Option 3: If all else fails, find and kill the process
   pid=$(ps -ef | grep spring-boot | grep -v grep | awk '{print $2}')
   if [ -n "$pid" ]; then
     echo "Stopping Spring Boot app with PID: $pid"
     kill $pid
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
   REM Using the unified run script (recommended)
   run.bat
   
   REM With specific profile
   run.bat --profile dev
   
   REM Run only backend
   run.bat --backend-only
   
   REM Run only frontend
   run.bat --frontend-only
   
   REM Alternative: Using two separate command prompts
   REM First command prompt:
   cd backend
   mvnw.cmd spring-boot:run
   
   REM Second command prompt:
   cd frontend
   npm run dev
   ```

4. **Stop Running Backend Process (if needed)**
   ```cmd
   REM Option 1: If you started with Ctrl+C in the terminal
   REM Simply press Ctrl+C in the terminal where Spring Boot is running
   
   REM Option 2: Using Spring Boot Actuator endpoint
   curl -X POST http://localhost:8080/actuator/shutdown
   
   REM Option 3: If all else fails, find and kill the process
   FOR /F "tokens=1" %%A IN ('jps -l ^| findstr KrabbelApplication') DO (
     echo Stopping Spring Boot with PID: %%A
     taskkill /PID %%A
   )
   ```

### Access the Application

- Frontend: http://localhost:5173
- Backend API: http://localhost:8080/api/
- Swagger UI: http://localhost:8080/swagger-ui/index.html (not available in production)

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
- [x] MySQL database setup
- [x] Swagger documentation
- [x] Helper methods:
  - [x] Email validation
  - [x] Password hashing
- [x] CORS configuration
- [x] Dummy data generation
- [x] API endpoints for:
  - [x] User authentication

## Production Deployment

### Prerequisites
- Azure account with appropriate permissions
- Azure CLI installed
- MySQL/MariaDB database server (local or Azure Database for MySQL)

### Preparing for Production

1. Configure environment variables:
   ```bash
   # Copy the environment template
   cp .env.template .env
   
   # Edit with your values
   nano .env
   ```

2. Run the production preparation script:
   ```bash
   # On Linux/macOS
   ./prepare-production.sh
   
   # On Windows
   prepare-production.bat
   ```

3. Review production settings:
   - Check `backend/src/main/resources/application-prod.properties`
   - Verify environment variables in `.env.production`

4. Follow the Azure deployment guide:
   - See `AZURE_DEPLOYMENT.md` for detailed instructions
   - Use the provided scripts in the `scripts/` directory

For detailed security configuration, refer to `SECURITY_CHECKLIST.md`
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