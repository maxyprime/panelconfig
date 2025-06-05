@echo off
setlocal enabledelayedexpansion

:: Read password from config.txt
for /f "tokens=1,2 delims==" %%a in (config.txt) do (
    if "%%a"=="password" set "PASSWORD=%%b"
)

:LOGIN
cls
echo Enter Password:
set /p userpass=

if "%userpass%"=="%PASSWORD%" (
    goto MENU
) else (
    echo Incorrect password. Try again.
    timeout /t 2 /nobreak >nul
    goto LOGIN
)

:MENU
cls
echo *** STEALTH LOADER MENU ***
echo 1. Setup
echo 2. Run
echo 3. Bypass
echo 4. Exit
echo.
set /p choice=Choose an option:

if "%choice%"=="1" goto SETUP
if "%choice%"=="2" goto RUN
if "%choice%"=="3" goto BYPASS
if "%choice%"=="4" goto EXIT

echo Invalid choice. Try again.
timeout /t 2 /nobreak >nul
goto MENU

:SETUP
echo Running setup...
:: Put your setup commands here
pause
goto MENU

:RUN
echo Running main program...
:: Put your run commands here
pause
goto MENU

:BYPASS
echo Bypassing security...
:: Put your bypass commands here
pause
goto MENU

:EXIT
exit
