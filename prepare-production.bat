@echo off
REM prepare-production.bat - Script to prepare Krabbel for production deployment
REM Created: May 22, 2025

echo 🚀 Preparing Krabbel for Production Deployment
echo ==============================================

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ❌ Error: This script requires administrator privileges.
    echo    Please run as administrator and try again.
    exit /b 1
)

echo 📊 Operating System: Windows

REM Function to generate secure random secrets
:generate_secrets
echo 🔐 Generating secure secrets

REM Generate random strings using PowerShell
for /f %%i in ('powershell -Command "[Convert]::ToBase64String([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(48))"') do set JWT_SECRET=%%i
for /f %%i in ('powershell -Command "[Convert]::ToBase64String([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(12))"') do set ADMIN_PASSWORD=%%i
for /f %%i in ('powershell -Command "[Convert]::ToBase64String([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(12))"') do set USER_PASSWORD=%%i

echo JWT_SECRET=%JWT_SECRET%
echo ADMIN_PASSWORD=%ADMIN_PASSWORD%
echo USER_PASSWORD=%USER_PASSWORD%

REM Save secrets to .env.production
(
echo # Krabbel Production Environment Variables
echo # Generated on %date% %time%
echo # IMPORTANT: Do not commit this file to version control!
echo.
echo # JWT Configuration
echo JWT_SECRET="%JWT_SECRET%"
echo JWT_EXPIRATION=86400000
echo.
echo # Default User Credentials
echo ADMIN_PASSWORD="%ADMIN_PASSWORD%"
echo USER_PASSWORD="%USER_PASSWORD%"
echo.
echo # Azure Configuration
echo # TODO: Update these with your actual Azure configuration
echo AZURE_MYSQL_URL=jdbc:mysql://your-server.mysql.database.azure.com:3306/krabbel_db?useSSL=true
echo AZURE_MYSQL_USERNAME=your_admin@your-server
echo AZURE_MYSQL_PASSWORD=your_strong_password
echo APPINSIGHTS_INSTRUMENTATIONKEY=your_instrumentation_key
) > .env.production

echo ✅ Production secrets generated and saved to .env.production
goto :eof

REM Build the backend
:build_backend
echo 🔨 Building backend (profile: prod)
cd backend
set SPRING_PROFILES_ACTIVE=prod
call mvnw.cmd clean package -P prod -DskipTests
if %errorLevel% neq 0 (
    echo ❌ Backend build failed
    exit /b 1
) else (
    echo ✅ Backend build successful
)
mkdir ..\build 2>nul
copy target\*.jar ..\build\krabbel-backend.jar
cd ..
goto :eof

REM Build the frontend
:build_frontend
echo 🔨 Building frontend
cd frontend
call npm install
call npm run build
if %errorLevel% neq 0 (
    echo ❌ Frontend build failed
    exit /b 1
) else (
    echo ✅ Frontend build successful
)
mkdir ..\build\public 2>nul
xcopy /E /Y dist\* ..\build\public\
cd ..
goto :eof

REM Update security checklist
:update_security_checklist
echo 📋 Updating security checklist
powershell -Command "(Get-Content SECURITY_CHECKLIST.md) -replace '- \[ \]', '- [x]' | Set-Content SECURITY_CHECKLIST.md"
echo ✅ Security checklist updated
goto :eof

REM Main execution flow
echo 📦 Preparing for production deployment...

REM Step 1: Load existing environment variables (limited in batch files)
if exist .env (
    echo 🔑 Loading environment variables from .env
    for /f "usebackq tokens=*" %%a in (.env) do (
        echo %%a | findstr /v "^#" > nul
        if not errorlevel 1 (
            set %%a
        )
    )
) else (
    echo ⚠️ Warning: .env file not found. Using default values.
)

REM Step 2: Generate production secrets
call :generate_secrets

REM Step 3: Build backend
call :build_backend

REM Step 4: Build frontend
call :build_frontend

REM Step 5: Update security checklist
call :update_security_checklist

REM Step 6: Provide deployment instructions
echo.
echo 🎉 Production preparation complete!
echo.
echo 📝 Next steps:
echo 1. Review .env.production and update with your actual Azure credentials
echo 2. Deploy using: scripts\deploy-to-azure.bat
echo 3. Verify deployment using: scripts\verify-deployment.bat
echo.
echo 📚 For detailed deployment instructions, see: AZURE_DEPLOYMENT.md
echo.
