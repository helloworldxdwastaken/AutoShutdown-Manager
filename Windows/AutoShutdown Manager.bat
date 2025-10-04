@echo off
title AutoShutdown Manager
color 0A

echo.
echo ========================================
echo    AutoShutdown Manager for Windows
echo ========================================
echo.

REM Check if PowerShell is available
powershell -Command "Get-Host" >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: PowerShell is not available on this system.
    echo Please install PowerShell or run the .ps1 file directly.
    pause
    exit /b 1
)

REM Run the PowerShell script
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0AutoShutdown Manager.ps1"

pause
