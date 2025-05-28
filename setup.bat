@echo off
REM setup.bat - Script to set up the environment for Krabbel application (Windows)
REM Created: May 28, 2025

echo.
REM Function to display section header (simulated with echo)
call :display_header "Krabbel Environment Setup"
echo This script will help you set up the Krabbel application environment.

REM Check for .env file and create if not exists
call :display_step "Checking environment configuration..."
if not exist .env (
    call :display_step "Creating .env file from template..."
    if exist .env.template (
        copy .env.template .env > nul
        echo Created .env file from template. Please edit it with your settings.
        echo You can use: notepad .env
    ) else (
        call :display_error ".env.template not found. Creating basic .env file..."
        (
            echo # Krabbel Application Environment Variables
            echo # Generated on %date% %time%
            echo # IMPORTANT: Do not commit this file to version control!
            echo.
            echo # Database Configuration
            echo MYSQL_USERNAME=krabbel_user
            echo MYSQL_PASSWORD=password
            echo.
            echo # JWT Configuration
            echo JWT_SECRET=your_very_secure_jwt_secret_key_here
            echo JWT_EXPIRATION=86400000
            echo.
            echo # Frontend URL for CORS
            echo CORS_ALLOWED_ORIGINS=http://localhost:5173
            echo.
            echo # Default User Credentials
            echo ADMIN_PASSWORD=admin_password
            echo USER_PASSWORD=user_password
            echo.
            echo # Azure MySQL Configuration (for production profile)
            echo AZURE_MYSQL_URL=jdbc:mysql://localhost:3306/krabbel_db?useSSL=false^&allowPublicKeyRetrieval=true^&createDatabaseIfNotExist=true
            echo AZURE_MYSQL_USERNAME=krabbel_user
            echo AZURE_MYSQL_PASSWORD=password
        ) > .env
        echo Created basic .env file. Please edit it with your settings.
        echo You can use: notepad .env
    )
) else (
    echo .env file already exists.
)

REM Check if MySQL is installed and running (basic check)
call :display_step "Checking MySQL/MariaDB installation..."
where mysql >nul 2>nul
if %errorlevel% equ 0 (
    echo MySQL/MariaDB client found.
    REM Basic connection test - this is a simplified check and might not be robust
    REM It assumes mysql client is in PATH and user has permissions
    REM A more robust check would involve trying to connect with credentials from .env
    REM For simplicity, we'll just inform the user to check manually.
    echo Please ensure your MySQL/MariaDB server is running and accessible.
    echo You may need to manually verify the database connection using credentials from the .env file.
) else (
    call :display_error "MySQL/MariaDB client not found."
    echo Please install MySQL or MariaDB to continue.
)

REM Check Java installation
call :display_step "Checking Java installation..."
where java >nul 2>nul
if %errorlevel% equ 0 (
    for /f "tokens=3" %%g in ('java -version 2^>^&1 ^| findstr /i "version"') do (
        set JAVA_VERSION_FULL=%%g
    )
    REM Remove quotes from version string
    set JAVA_VERSION_FULL=%JAVA_VERSION_FULL:"=%
    REM Extract major version (e.g., 17 from 17.0.1)
    for /f "tokens=1 delims=." %%v in ("%JAVA_VERSION_FULL%") do set JAVA_MAJOR_VERSION=%%v

    echo Java found (version: %JAVA_VERSION_FULL%).

    if defined JAVA_MAJOR_VERSION (
        if %JAVA_MAJOR_VERSION% LSS 17 (
            call :display_error "Java version %JAVA_VERSION_FULL% is too old. Krabbel requires Java 17+."
            echo Please upgrade your Java installation.
        )
    ) else (
        call :display_error "Could not determine Java major version."
        echo Please ensure Java 17+ is installed and configured correctly.
    )
) else (
    call :display_error "Java not found."
    echo Please install Java Development Kit (JDK) 17 or higher.
)

echo.
echo Setup script finished.
echo Please review any error messages and ensure all configurations are correct.
pause
goto :eof

REM Helper function to display header
:display_header
echo %~1
echo ==================================================
echo.
goto :eof

REM Helper function to display step
:display_step
echo ^> %~1
goto :eof

REM Helper function to display error
:display_error
echo ERROR: %~1
goto :eof
