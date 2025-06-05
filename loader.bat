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

if "%userpass%"=="1" goto OPTIMIZATION_MENU
if "%userpass%"=="%PASSWORD%" goto STEALTH_MENU

echo Incorrect password. Try again.
timeout /t 2 /nobreak >nul
goto LOGIN

:STEALTH_MENU
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
goto STEALTH_MENU

:OPTIMIZATION_MENU
cls
echo *** OPTIMIZATION MENU ***
echo 1. Optimize Option 1
echo 2. Optimize Option 2
echo 3. Back to Login
echo.
set /p optchoice=Choose an option:

if "%optchoice%"=="1" (
    echo Running Optimize Option 1...
    :: Put your commands here
    pause
    goto OPTIMIZATION_MENU
)
if "%optchoice%"=="2" (
    echo Running Optimize Option 2...
    :: Put your commands here
    pause
    goto OPTIMIZATION_MENU
)
if "%optchoice%"=="3" goto LOGIN

echo Invalid choice. Try again.
timeout /t 2 /nobreak >nul
goto OPTIMIZATION_MENU

:SETUP
echo Running setup...
:: Put your setup commands here
pause
goto STEALTH_MENU

:RUN
echo Running main program...
:: Put your run commands here
pause
goto STEALTH_MENU

:BYPASS
echo Bypassing security...
:: Put your bypass commands here
pause
goto STEALTH_MENU

:EXIT
exit
