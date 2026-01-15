@echo off
setlocal EnableExtensions DisableDelayedExpansion

echo ==========================================
echo    Navicat Premium Trial Reset Tool
echo ==========================================
echo.

echo Check if Navicat is running...
tasklist /FI "IMAGENAME eq navicat.exe" 2>NUL | find /I /N "navicat.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo Navicat is running. Killing process...
    taskkill /F /IM navicat.exe
    timeout /t 2 >nul
) else (
    echo Navicat is not running.
)

echo.
echo Deleting Registry Keys...

:: Delete the main Data key
reg delete "HKEY_CURRENT_USER\Software\PremiumSoft\Data" /f 2>nul
if %errorlevel% equ 0 (
    echo [OK] Deleted HKEY_CURRENT_USER\Software\PremiumSoft\Data
) else (
    echo [INFO] Key HKEY_CURRENT_USER\Software\PremiumSoft\Data not found.
)

:: Scan and delete hidden CLSID keys
:: Navicat hides registration info in HKCU\Software\Classes\CLSID\{GUID}\Info
echo Scanning for hidden trial info in CLSID...

for /f "tokens=*" %%a in ('reg query "HKEY_CURRENT_USER\Software\Classes\CLSID"') do (
    reg query "%%a" /v "Info" 2>nul | find "Info" >nul
    if not errorlevel 1 (
        echo Found trial key in: %%a
        reg delete "%%a" /f 2>nul
        if not errorlevel 1 echo [OK] Deleted: %%a
    )
)

echo.
echo ==========================================
echo    Reset Complete!
echo ==========================================
@echo on
