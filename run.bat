@echo off
REM run.bat - Windows script to run Krabbel application
REM Created: May 22, 2025

REM Set default values
set PROFILE=dev
set FRONTEND=true
set BACKEND=true

REM Parse arguments
:parse
if "%~1"=="" goto :main
if "%~1"=="--profile" set PROFILE=%~2& shift & shift & goto :parse
if "%~1"=="-p" set PROFILE=%~2& shift & shift & goto :parse
if "%~1"=="--frontend-only" set BACKEND=false& shift & goto :parse
if "%~1"=="-f" set BACKEND=false& shift & goto :parse
if "%~1"=="--backend-only" set FRONTEND=false& shift & goto :parse
if "%~1"=="-b" set FRONTEND=false& shift & goto :parse
if "%~1"=="--help" goto :help
if "%~1"=="-h" goto :help
echo Unknown parameter: %~1
exit /b 1

:help
echo Usage: run.bat [options]
echo Options:
echo   --profile, -p ^<profile^>   Set Spring Boot profile (dev/prod, default: dev)
echo   --frontend-only, -f       Run only the frontend
echo   --backend-only, -b        Run only the backend
echo   --help, -h                Display this help message
exit /b 0

:main
echo 🚀 Starting Krabbel Application
echo ⚙️ Profile: %PROFILE%

REM Load environment variables
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

REM Run services based on flags
if %BACKEND%==true if %FRONTEND%==true (
    REM Run both concurrently
    echo 🔄 Starting services concurrently
    start "Krabbel Backend" cmd /c "%~dp0run.bat --backend-only --profile %PROFILE%"
    start "Krabbel Frontend" cmd /c "%~dp0run.bat --frontend-only"
) else if %BACKEND%==true (
    call :run_backend
) else if %FRONTEND%==true (
    call :run_frontend
)

exit /b 0

:run_backend
echo 🔄 Starting backend server (profile: %PROFILE%)
cd backend
set SPRING_PROFILES_ACTIVE=%PROFILE%
call mvnw.cmd spring-boot:run -Dspring-boot.run.profiles=%PROFILE%
exit /b 0

:run_frontend
echo 🔄 Starting frontend development server
cd frontend
call npm install
call npm run dev
exit /b 0
