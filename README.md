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
│   ├── cleanup-deprecated.sh
│   ├── generate-secrets.sh
│   ├── run-migrations.sh
│   ├── run-prod-local.sh
│   └── update-prod-passwords.sh
├── .env.template        # Template for environment variables
├── README.md            # This file
├── run.sh               # Cross-platform run script
├── run.bat              # Windows run script
├── setup-env.sh         # Environment setup script
├── prepare-production.sh # Production preparation script
├── prepare-production.bat # Windows production preparation script
├── AZURE_DEPLOYMENT.md  # Guide for Azure deployment
├── DATABASE_SECURITY.md # Notes on database security
├── PROJECT_DOCUMENTATION.md # Overall project documentation
├── UPDATE_SUMMARY.md    # Summary of updates
├── USAGE_GUIDE.md       # Detailed usage guide for scripts
└── package.json         # Project metadata (if applicable at root)
```

## Prerequisites

- Java Development Kit (JDK) 17 or higher
- Node.js 16 or higher
- npm or yarn
- Maven 3.6 or higher
- MySQL/MariaDB 8.0+ (for production)
- MySQL (for production)

## Getting Started

### 1. Install Dependencies

<details>
<summary>Linux / macOS</summary>

## Install backend dependencies
```bash
cd backend
./mvnw clean install
```

## Install frontend dependencies
```bash
cd frontend
npm install
```

</details>

<details>
<summary>Windows</summary>

## Install backend dependencies
```bash
cd backend
mvnw.cmd clean install
```

## Install frontend dependencies
```bash
cd frontend
npm install
```

</details>

### 2. Setup Environment Configuration
This step will guide you through creating your `.env` file.

<details>
<summary>Linux / macOS</summary>

```bash
./setup-env.sh
```

## Follow the prompts. If you need to manually edit the .env file:
```bash
nano .env
```

</details>

<details>
<summary>Windows</summary>

```bash
bash setup-env.sh
```

## Follow the prompts. If you need to manually edit the .env file:
```bash
notepad .env
```

If you don't have bash installed on Windows, you can manually copy `.env.template` to `.env` and edit it.

</details>

### 3. Run the Application
## Linux / macOS 
```bash
./run.sh
```

## Windows
```bash
./run.bat
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