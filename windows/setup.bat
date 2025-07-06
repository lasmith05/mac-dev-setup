@echo off
REM Windows Development Environment Setup Batch File
REM This file automatically handles PowerShell execution policy and runs the setup

echo.
echo ===============================================
echo   Windows Development Environment Setup
echo ===============================================
echo.

REM Check if running as Administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [INFO] Running with Administrator privileges - Good!
) else (
    echo [ERROR] This script must be run as Administrator!
    echo.
    echo Please:
    echo 1. Right-click on this file ^(setup.bat^)
    echo 2. Select "Run as administrator"
    echo 3. Click "Yes" when prompted
    echo.
    pause
    exit /b 1
)

echo.
echo [INFO] Preparing PowerShell environment...

REM Check PowerShell version
echo [INFO] Checking PowerShell version...
powershell -Command "if ($PSVersionTable.PSVersion.Major -lt 5) { Write-Host '[ERROR] PowerShell 5.1 or higher required' -ForegroundColor Red; exit 1 }" 2>nul
if %errorLevel% neq 0 (
    echo [ERROR] PowerShell 5.1 or higher is required for this script
    echo [INFO] Please update PowerShell and try again
    pause
    exit /b 1
)

REM Unblock the PowerShell script file (prevents "not digitally signed" errors)
echo [INFO] Unblocking PowerShell script file...
powershell -Command "Unblock-File '%~dp0windows-setup.ps1'" 2>nul
if %errorLevel% == 0 (
    echo [INFO] PowerShell script unblocked successfully
) else (
    echo [WARNING] Could not unblock script file automatically
)

REM Set PowerShell execution policy comprehensively
echo [INFO] Setting PowerShell execution policy...
powershell -Command "Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force" 2>nul
powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force" 2>nul

if %errorLevel% == 0 (
    echo [INFO] PowerShell execution policy configured successfully
) else (
    echo [WARNING] Could not set execution policy automatically
    echo [INFO] Will use bypass method for script execution...
)

echo.
echo [INFO] Starting Windows setup script...
echo [INFO] This will install WSL2, Ubuntu, and Windows applications
echo [INFO] Some steps require user interaction - please watch for prompts
echo.

REM First-time winget setup - accept source agreements
echo [INFO] Setting up winget (first-time setup may require agreement acceptance)...
powershell -Command "winget list > $null 2>&1"
if %errorLevel% neq 0 (
    echo [INFO] Please accept winget source agreements when prompted...
    powershell -Command "winget list"
    echo [INFO] Agreements accepted. Continuing with silent installations...
)

REM Run the PowerShell script with execution policy bypass
echo [INFO] Executing PowerShell setup script...
powershell -ExecutionPolicy Bypass -File "%~dp0windows-setup.ps1"

echo.
echo [INFO] PowerShell script completed with exit code: %errorLevel%

if %errorLevel% == 0 (
    echo.
    echo [SUCCESS] Windows setup completed successfully!
    echo.
    echo [INFO] Checking WSL installation status...
    wsl --list --verbose
    
    echo.
    echo [INFO] Next steps:
    echo 1. If WSL installation is pending, restart your computer
    echo 2. If Ubuntu shows "Stopped", open Windows Terminal and type 'wsl'
    echo 3. Set up Ubuntu username/password when prompted
    echo 4. Copy setup files and run ubuntu-setup.sh
    echo.
    echo [INFO] WSL Installation Notes:
    echo - WSL installation may require a restart to complete
    echo - Ubuntu will prompt for username/password on first run
    echo - If Ubuntu didn't install, run: wsl --install -d Ubuntu-24.04
) else (
    echo.
    echo [ERROR] Setup script encountered an error (Exit Code: %errorLevel%)
    echo.
    echo [INFO] Common issues and solutions:
    echo - Make sure you're running as Administrator
    echo - Check your internet connection
    echo - Ensure Windows version supports WSL2 (Windows 10 2004+ or Windows 11)
    echo - Try manual WSL install: wsl --install -d Ubuntu-24.04
    echo.
    echo [INFO] For detailed troubleshooting, check the README.md file
)

echo.
echo Press any key to exit...
pause >nul