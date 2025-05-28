# Krabbel Application Usage Guide

## Running the Application

The Krabbel application now includes a unified `run.sh` script that combines all functionality needed to run the application in different environments. This script replaces the separate scripts previously used, including `scripts/run-prod-local.sh` and other environment-specific scripts.

> **Note:** The legacy scripts like `scripts/run-prod-local.sh` are now deprecated but kept for backward compatibility. We recommend using the new unified script for all operations.

### Basic Usage

To run both the backend and frontend in development mode:

```bash
./run.sh
```

### Command-Line Options

The `run.sh` script supports the following options:

| Option | Description |
|--------|-------------|
| `--profile`, `-p` | Set Spring Boot profile (dev/prod, default: dev) |
| `--frontend-only`, `-f` | Run only the frontend |
| `--backend-only`, `-b` | Run only the backend |
| `--port` | Set the backend port (default: 8080) |
| `--test-db` | Test database connection before starting |
| `--debug` | Enable debug mode with enhanced logging |
| `--setup` | Run environment setup before starting |
| `--help`, `-h` | Display help message |

### Examples

#### Running in Production Mode

```bash
./run.sh --profile prod
```

#### Running Only the Backend in Production Mode with Debug Logging

```bash
./run.sh --backend-only --profile prod --debug
```

#### Testing Database Connection Before Starting

```bash
./run.sh --test-db
```

#### Setting Up Environment and Running in Development Mode

```bash
./run.sh --setup
```

## Environment Configuration

The application requires a `.env` file with environment variables. If this file doesn't exist, you can create it by running:

```bash
./run.sh --setup
```

## Database Configuration

### Development Mode

In development mode, the application uses the following database configurations:

- URL: defined by `MYSQL_URL` in `.env` (default: jdbc:mysql://localhost:3306/krabbel_db)
- Username: defined by `MYSQL_USERNAME` in `.env` 
- Password: defined by `MYSQL_PASSWORD` in `.env`

### Production Mode

In production mode, the application uses the following database configurations:

- URL: defined by `AZURE_MYSQL_URL` in `.env`
- Username: defined by `AZURE_MYSQL_USERNAME` in `.env`
- Password: defined by `AZURE_MYSQL_PASSWORD` in `.env`

## Troubleshooting

If you encounter issues starting the application, try the following:

1. Ensure your `.env` file has the correct database credentials
2. Run with the `--test-db` flag to test database connectivity before starting
3. Use the `--debug` flag to enable enhanced logging
4. Check that all required services (MySQL, etc.) are running

For database connection issues in production mode, check:
- The `AZURE_MYSQL_URL` format (should be `jdbc:mysql://host:port/database?parameters`)
- Network connectivity to the database host
- Firewall settings allowing connections to the database port

## Logs

Logs are output to the console. In debug mode, additional logs are enabled for:
- Spring Framework
- Hibernate
- HikariCP connection pool
- Flyway database migrations
