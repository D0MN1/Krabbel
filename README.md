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

### Backend Setup

1. Navigate to the backend directory:
   ```
   cd backend
   ```

2. Build the project:
   ```
   mvn clean install
   ```

3. Run the Spring Boot application:
   ```
   mvn spring-boot:run
   ```

The backend will start on http://localhost:8081 with the following endpoints:
- API: http://localhost:8081/api/
- Swagger UI: http://localhost:8081/swagger-ui/index.html
- H2 Console: http://localhost:8081/h2-console (JDBC URL: jdbc:h2:mem:noted_db)

### Frontend Setup

1. Navigate to the frontend directory:
   ```
   cd frontend
   ```

2. Install dependencies:
   ```
   npm install
   ```

3. Run the development server:
   ```
   npm run dev
   ```

The frontend will start on http://localhost:5173

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

## API Documentation

The API documentation is available via Swagger UI at http://localhost:8081/swagger-ui/index.html when the backend is running.

## Deployment

### Backend

To build a production JAR file:

```
cd backend
mvn clean package
```

The JAR file will be available in the `target` directory and can be run with:

```
java -jar target/noted-backend-0.0.1-SNAPSHOT.jar
```

### Frontend

To build for production:

```
cd frontend
npm run build
```

The production build will be available in the `dist` directory.

## Running Both Frontend and Backend

You can run both the frontend and backend simultaneously using a single command. From the project root directory, run:

```bash
(cd backend && mvn spring-boot:run) & (cd frontend && npm run dev)
```

This will:
1. Start the backend server on http://localhost:8081
2. Start the frontend development server on http://localhost:5173

Note: The `&` operator runs both commands in parallel. You can stop both servers by pressing `Ctrl+C` in the terminal.

## License

[ISC License]

## Contributing

Contributions are welcome. Please feel free to submit a Pull Request. 