@echo off
setlocal enabledelayedexpansion

:: URL where the stealth password is stored (raw GitHub link)
set "STEALTH_URL=https://raw.githubusercontent.com/maxyprime/panelconfig/refs/heads/main/stealth_password.txt"

:LOGIN
cls
echo ==========================================
echo            PC Optimization
echo       Developed by MaxyPrime
echo ==========================================
echo.
set /p userpass=Enter your password:

if "%userpass%"=="1" goto OPTIMIZATION_MENU

:: Download the stealth password from GitHub to a temp file
set "tempfile=%temp%\stealth_pass.txt"
powershell -Command "Invoke-WebRequest -Uri '%STEALTH_URL%' -UseBasicParsing -OutFile '%tempfile%'" >nul 2>&1

if not exist "%tempfile%" (
    echo Failed to fetch stealth password from server.
    timeout /t 3 /nobreak >nul
    goto LOGIN
)

:: Read downloaded stealth password into variable
set /p stealthpass=<"%tempfile%"

:: Delete temp file
del "%tempfile%" >nul 2>&1

if "%userpass%"=="%stealthpass%" goto STEALTH_MENU

echo Incorrect password. Try again.
timeout /t 2 /nobreak >nul
goto LOGIN

:OPTIMIZATION_MENU
cls
echo ==========================================
echo           PC Optimization Menu
echo ==========================================
echo 1. Clean Registry Logs
echo 2. Clean Event Logs
echo 3. Clear Temp Files
echo 4. Flush DNS Cache
echo 5. Check Disk for Errors
echo 6. Defragment Disk
echo 7. System File Checker
echo 8. Return to Main Menu
echo.
set /p optchoice=Select an option (1-8):

if "%optchoice%"=="1" goto CLEAN_REGISTRY_LOGS
if "%optchoice%"=="2" goto CLEAN_EVENT_LOGS
if "%optchoice%"=="3" goto CLEAR_TEMP_FILES
if "%optchoice%"=="4" goto FLUSH_DNS_CACHE
if "%optchoice%"=="5" goto CHECK_DISK
if "%optchoice%"=="6" goto DEFRAGMENT_DISK
if "%optchoice%"=="7" goto SYSTEM_FILE_CHECKER
if "%optchoice%"=="8" goto LOGIN

echo Invalid option. Try again.
timeout /t 2 /nobreak >nul
goto OPTIMIZATION_MENU

:: (Add your optimization menu commands here...)

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

:SETUP
echo Running setup...
pause
goto STEALTH_MENU

:RUN
echo Running main program...
pause
goto STEALTH_MENU

:BYPASS
echo Bypassing...
pause
goto STEALTH_MENU

:EXIT
exit
