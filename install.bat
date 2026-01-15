@echo off
setlocal
cd /d "%~dp0"

echo ==========================================
echo    Navicat Auto-Reset Installer (Windows)
echo ==========================================
echo.

:: Check for Administrator privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Running as Administrator
) else (
    echo [ERROR] Please right-click this file and select "Run as Administrator"
    pause
    exit /b 1
)

set "TASK_NAME=NavicatAutoReset"
set "SCRIPT_PATH=%~dp0reset_navicat.bat"

if not exist "%SCRIPT_PATH%" (
    echo [ERROR] Could not find reset_navicat.bat in the current directory!
    pause
    exit /b 1
)

echo.
echo Installing background task...
echo Script Path: %SCRIPT_PATH%
echo.

:: Delete existing task if it exists to avoid errors on update
schtasks /delete /tn "%TASK_NAME%" /f 2>nul

:: Create the new task
:: /sc DAILY: Run every day
:: /st 00:00: Run at midnight
:: /ru SYSTEM: Run with highest privileges (needed for registry access sometimes) or current user.
:: We will use current user since HKCU (Current User Registry) needs to be modified for the logged-in user.
schtasks /create /tn "%TASK_NAME%" /tr "\"%SCRIPT_PATH%\"" /sc DAILY /st 00:00 /f

if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] Task "%TASK_NAME%" has been created successfully.
    echo It will run every night at 00:00.
) else (
    echo.
    echo [ERROR] Failed to create scheduled task.
)

echo.
pause
