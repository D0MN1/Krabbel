@echo off
REM run.bat - Unified Windows script to run Krabbel application in any environment
REM Created: May 28, 2025 (updated)

REM Enable command extensions
setlocal EnableExtensions
setlocal EnableDelayedExpansion

REM ANSI color codes for Windows 10+ consoles
set "GREEN=[92m"
set "YELLOW=[93m"
set "RED=[91m"
set "BOLD=[1m"
set "NC=[0m"

REM Display formatted messages
echo %BOLD%%GREEN%Krabbel Application Runner%NC%

REM Set default values
set PROFILE=dev
set FRONTEND=true
set BACKEND=true
set TARGET_PORT=8080
set TEST_DB_CONNECTION=false
set DEBUG_MODE=false
set SETUP_ENV=false

REM Parse arguments
:parse
if "%~1"=="" goto :main
if /i "%~1"=="--profile" set PROFILE=%~2& shift & shift & goto :parse
if /i "%~1"=="-p" set PROFILE=%~2& shift & shift & goto :parse
if /i "%~1"=="--frontend-only" set BACKEND=false& shift & goto :parse
if /i "%~1"=="-f" set BACKEND=false& shift & goto :parse
if /i "%~1"=="--backend-only" set FRONTEND=false& shift & goto :parse
if /i "%~1"=="-b" set FRONTEND=false& shift & goto :parse
if /i "%~1"=="--port" set TARGET_PORT=%~2& shift & shift & goto :parse
if /i "%~1"=="--test-db" set TEST_DB_CONNECTION=true& shift & goto :parse
if /i "%~1"=="--debug" set DEBUG_MODE=true& shift & goto :parse
if /i "%~1"=="--setup" set SETUP_ENV=true& shift & goto :parse
if /i "%~1"=="--help" goto :help
if /i "%~1"=="-h" goto :help
echo %RED%Unknown parameter: %~1%NC%
exit /b 1

:help
echo %BOLD%Usage: run.bat [options]%NC%
echo %BOLD%Options:%NC%
echo   --profile, -p ^<profile^>   Set Spring Boot profile (dev/prod, default: dev)
echo   --frontend-only, -f       Run only the frontend
echo   --backend-only, -b        Run only the backend
echo   --port ^<port_number^>      Set the backend port (default: 8080)
echo   --test-db                 Test database connection before starting
echo   --debug                   Enable debug mode with enhanced logging
echo   --setup                   Run environment setup before starting
echo   --help, -h                Display this help message
exit /b 0

:main
echo %BOLD%%GREEN%Starting Krabbel Application%NC%
echo %GREEN%Profile:%NC% %BOLD%%PROFILE%%NC%
echo %GREEN%Target Backend Port:%NC% %TARGET_PORT%

REM Determine project root directory
set "PROJECT_ROOT=%~dp0"
set "ENV_FILE=%PROJECT_ROOT%.env"

REM Run environment setup if requested
if "%SETUP_ENV%"=="true" (
    echo %YELLOW%Running environment setup...%NC%
    if exist "%PROJECT_ROOT%setup-env.bat" (
        call "%PROJECT_ROOT%setup-env.bat"
    ) else (
        echo %RED%ERROR: setup-env.bat not found in %PROJECT_ROOT%%NC%
    )
)

REM Load environment variables
if exist "%ENV_FILE%" (
    echo %YELLOW%Loading environment variables from %ENV_FILE%%NC%
    
    REM Process .env file, skipping comments and empty lines
    for /f "usebackq tokens=*" %%a in ("%ENV_FILE%") do (
        set "line=%%a"
        if "!line:~0,1!" neq "#" if "!line:~0,2!" neq "//" if "!line!" neq "" (
            for /f "tokens=1,* delims==" %%b in ("!line!") do (
                if "%%b" neq "" if "%%c" neq "" (
                    set "%%b=%%c"
                    echo Exported: %%b
                )
            )
        )
    )
    
    REM Always set Spring profile explicitly
    set "SPRING_PROFILES_ACTIVE=%PROFILE%"
    echo Exported: SPRING_PROFILES_ACTIVE=%PROFILE%
) else (
    echo %RED%ERROR: Environment file '%ENV_FILE%' not found%NC%
    echo %YELLOW%Run with --setup to create a new .env file%NC%
    exit /b 1
)

REM Show key environment variables for debug purposes
if /i "%PROFILE%"=="prod" (
    echo.
    echo %GREEN%Production environment variables:%NC%
    echo Effective PORT: %PORT%
    echo AZURE_MYSQL_URL: %AZURE_MYSQL_URL%
    echo AZURE_MYSQL_USERNAME: %AZURE_MYSQL_USERNAME%
    REM Do not echo password
)

REM Test database connection if requested
if "%TEST_DB_CONNECTION%"=="true" (
    call :test_database_connection
)

REM Run services based on flags
if "%BACKEND%"=="true" if "%FRONTEND%"=="true" (
    REM Run both concurrently
    echo %BOLD%%GREEN%Starting Services Concurrently%NC%
    start "Krabbel Backend" cmd /c "cd %PROJECT_ROOT% && run.bat --backend-only --profile %PROFILE% --port %TARGET_PORT% %DEBUG_MODE:true=--debug% %TEST_DB_CONNECTION:true=--test-db%"
    start "Krabbel Frontend" cmd /c "cd %PROJECT_ROOT% && run.bat --frontend-only"
    exit /b 0
) else if "%BACKEND%"=="true" (
    call :run_backend
) else if "%FRONTEND%"=="true" (
    call :run_frontend
) else (
    echo %RED%No services selected to run%NC%
    echo Run with --help to see available options
    exit /b 1
)

exit /b 0

:test_database_connection
echo %YELLOW%Testing database connection...%NC%
if /i "%PROFILE%"=="prod" (
    if exist "%ProgramFiles%\MySQL\MySQL Server 8.0\bin\mysql.exe" (
        set "MYSQL_EXE=%ProgramFiles%\MySQL\MySQL Server 8.0\bin\mysql.exe"
    ) else if exist "%ProgramFiles(x86)%\MySQL\MySQL Server 8.0\bin\mysql.exe" (
        set "MYSQL_EXE=%ProgramFiles(x86)%\MySQL\MySQL Server 8.0\bin\mysql.exe"
    ) else (
        echo %YELLOW%MySQL client not found, skipping connectivity test.%NC%
        exit /b 0
    )
    
    REM Extract hostname from JDBC URL
    for /f "tokens=3 delims=/" %%a in ("%AZURE_MYSQL_URL%") do (
        set "JDBC_HOST=%%a"
    )
    
    REM Extract host and port
    for /f "tokens=1,2 delims=:" %%a in ("!JDBC_HOST!") do (
        set "HOST=%%a"
        set "PORT=%%b"
    )
    
    REM Extract database name
    for /f "tokens=1 delims=?" %%a in ("%JDBC_HOST:*/=%") do (
        set "DB=%%a"
    )
    
    echo Attempting to connect to MySQL at %HOST%:%PORT%/%DB%...
    "%MYSQL_EXE%" -h %HOST% -P %PORT% -u %AZURE_MYSQL_USERNAME% -p%AZURE_MYSQL_PASSWORD% -e "SELECT 1;" %DB% >nul 2>&1
    if errorlevel 1 (
        echo %RED%ERROR: Could not connect to MySQL. The application may fail to start.%NC%
    ) else (
        echo %GREEN%MySQL connection successful!%NC%
    )
) else (
    echo %YELLOW%Skipping database test in development mode.%NC%
)
exit /b 0

:run_backend
echo %BOLD%%GREEN%Starting Backend Server%NC%
echo %GREEN%Profile:%NC% %BOLD%%PROFILE%%NC%
echo %GREEN%Port:%NC% %TARGET_PORT%

cd "%PROJECT_ROOT%\backend" || (
    echo %RED%ERROR: Failed to change directory to backend from %CD%%NC%
    exit /b 1
)

REM Find and kill processes using the target port
echo %YELLOW%Checking if port %TARGET_PORT% is in use...%NC%
for /f "tokens=5" %%a in ('netstat -aon ^| find ":%TARGET_PORT% " ^| find "LISTENING"') do (
    echo %YELLOW%Port %TARGET_PORT% is in use by PID %%a. Attempting to terminate...%NC%
    taskkill /F /PID %%a >nul 2>&1
    if errorlevel 1 (
        echo %RED%ERROR: Failed to terminate process %%a. Manual intervention may be required.%NC%
    ) else (
        echo %GREEN%Process %%a terminated.%NC%
    )
    REM Give a moment for the port to be released
    timeout /t 2 >nul
)

REM Set environment variables for the backend
set "SPRING_PROFILES_ACTIVE=%PROFILE%"
set "SERVER_PORT=%TARGET_PORT%"

REM Set Java options for debug mode
set "JAVA_OPTS="
if "%DEBUG_MODE%"=="true" (
    echo %YELLOW%Running with enhanced debug logging%NC%
    set "JAVA_OPTS=-Dlogging.level.org.springframework=DEBUG -Dlogging.level.com.zaxxer.hikari=DEBUG -Dlogging.level.org.flywaydb=DEBUG -Dlogging.level.org.hibernate=DEBUG -Dspring.datasource.hikari.leak-detection-threshold=2000"
)

REM Run the backend
echo %YELLOW%Launching Spring Boot application...%NC%
call mvnw.cmd spring-boot:run -Dspring-boot.run.profiles=%PROFILE% -Dserver.port=%TARGET_PORT% -Dspring-boot.run.jvmArguments="%JAVA_OPTS%"

exit /b 0

:run_frontend
echo %BOLD%%GREEN%Starting Frontend Development Server%NC%

cd "%PROJECT_ROOT%\frontend" || (
    echo %RED%ERROR: Failed to change directory to frontend from %CD%%NC%
    exit /b 1
)

REM Check if node_modules exists, if not install dependencies
if not exist "node_modules" (
    echo %YELLOW%Installing frontend dependencies...%NC%
    call npm install
) 

echo %YELLOW%Launching Vue.js development server...%NC%
call npm run dev

exit /b 0