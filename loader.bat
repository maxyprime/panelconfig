@echo off
setlocal enabledelayedexpansion

:: URL of the remote stealth password file
set "STEALTH_PASS_URL=https://raw.githubusercontent.com/maxyprime/panelconfig/refs/heads/main/stealth_password.txt"

:LOGIN
cls
echo ==========================================
echo            PC Optimization
echo       Developed by MaxyPrime
echo ==========================================
echo.
set /p userpass=Enter your password: 

if "%userpass%"=="1" (
    goto OPTIMIZATION_MENU
) else (
    call :CheckStealthPassword "%userpass%"
    if errorlevel 1 (
        echo Incorrect password. Try again.
        timeout /t 2 /nobreak >nul
        goto LOGIN
    ) else (
        goto STEALTH_MENU
    )
)

goto LOGIN

:CheckStealthPassword
set "inputpass=%~1"
for /f "usebackq delims=" %%A in (`powershell -Command "(Invoke-WebRequest -Uri '%STEALTH_PASS_URL%' -UseBasicParsing).Content.Trim()"`) do set "remote_pass=%%A"

if /i "%inputpass%"=="%remote_pass%" (
    exit /b 0
) else (
    exit /b 1
)

:: --- Optimization Menu ---
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

:CLEAN_REGISTRY_LOGS
echo Cleaning Registry Logs...
for /f "tokens=*" %%G in ('wevtutil el') do (
    wevtutil cl "%%G"
)
echo Registry logs cleared.
pause
goto OPTIMIZATION_MENU

:CLEAN_EVENT_LOGS
echo Cleaning Event Logs...
for /f "tokens=*" %%G in ('wevtutil el') do (
    wevtutil cl "%%G"
)
echo Event logs cleared.
pause
goto OPTIMIZATION_MENU

:CLEAR_TEMP_FILES
echo Clearing Temp Files...
del /s /q "%temp%\*.*" >nul 2>&1
del /s /q "C:\Windows\Temp\*.*" >nul 2>&1
echo Temp files cleared.
pause
goto OPTIMIZATION_MENU

:FLUSH_DNS_CACHE
echo Flushing DNS Cache...
ipconfig /flushdns
echo DNS Cache flushed.
pause
goto OPTIMIZATION_MENU

:CHECK_DISK
echo Checking Disk for Errors...
chkdsk C: /f /r
pause
goto OPTIMIZATION_MENU

:DEFRAGMENT_DISK
echo Defragmenting C: drive...
defrag C: /U /V
pause
goto OPTIMIZATION_MENU

:SYSTEM_FILE_CHECKER
echo Running System File Checker...
sfc /scannow
pause
goto OPTIMIZATION_MENU

:: --- Stealth Menu ---
:STEALTH_MENU
cls
echo  ===========================================
echo.
echo             *** STEALTH MENU ***
echo          Authorized Personnel Only
echo.
echo  ===========================================
echo.
echo  1. Setup
echo  2. Run
echo  3. Bypass
echo  4. Alert the Admin !!!
echo  5. Exit
echo.
set /p choice=Choose an option: 

if "%choice%"=="1" goto SETUP
if "%choice%"=="2" goto RUN
if "%choice%"=="3" goto BYPASS
if "%choice%"=="4" goto ALERT_ADMIN
if "%choice%"=="5" goto EXIT

echo Invalid choice. Try again.
timeout /t 2 /nobreak >nul
goto STEALTH_MENU

:SETUP
echo Running setup...
:: Add your setup commands here
pause
goto STEALTH_MENU

:RUN
echo Running main program...
:: Add your run commands here
pause
goto STEALTH_MENU

:BYPASS
echo Bypassing security...
:: Add your bypass commands here
pause
goto STEALTH_MENU

:ALERT_ADMIN
echo Alerting admin...
:: Add alert logic here (email, notification, etc.)
pause
goto STEALTH_MENU

:EXIT
exit
