@echo off
:: ============================
:: Admin Check (foolproof)
:: ============================
fsutil dirty query %systemdrive% >nul 2>&1
if %errorlevel% NEQ 0 (
    echo =================================================
    echo  ADMIN PRIVILEGES REQUIRED
    echo  Please run this script as Administrator.
    echo  Right-click this file and choose "Run as Administrator".
    echo =================================================
    pause
    exit /b
)

setlocal enabledelayedexpansion

:: === Read secret password from config.txt ===
set "SECRET_PASS="
for /f "tokens=1,2 delims==" %%a in (config.txt) do (
    if "%%a"=="password" set "SECRET_PASS=%%b"
)

:LOGIN
cls
echo ==========================================
echo            PC Optimization
echo       Developed by MaxyPrime
echo ==========================================
echo.
echo Enter your password:
set /p userpass=

if "%userpass%"=="1" goto OPTIMIZATION_MENU
if "%userpass%"=="%SECRET_PASS%" goto KEYAUTH_LOGIN

echo Incorrect password. Try again.
timeout /t 2 /nobreak >nul
goto LOGIN

:: ============================
:: Optimization Menu
:: ============================
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

:: ============================
:: KeyAuth Login (inline PowerShell)
:: ============================
:KEYAUTH_LOGIN
cls
echo ==========================================
echo          KeyAuth User Login
echo ==========================================
echo.
set /p username=Enter username:
set /p userkey=Enter license key:

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"param([string]$username, [string]$userkey); ^
$name='Arunkumar.pandi''s Application'; ^
$ownerid='fnnkAQsWWq'; ^
$version='1.0'; ^
$url='https://keyauth.win/api/1.3/'; ^
$params=@{name=$name; ownerid=$ownerid; ver=$version; user=$username; key=$userkey}; ^
$query = $params.GetEnumerator() ^| ForEach-Object { $_.Key + '=' + [uri]::EscapeDataString($_.Value) } -join '&'; ^
$api_url = $url + '?' + $query; ^
try { ^
  $response = Invoke-RestMethod -Uri $api_url -UseBasicParsing; ^
  if ($response.success) { exit 0 } else { Write-Host 'Login failed: ' + $response.message; exit 1 } ^
} catch { ^
  Write-Host 'Error connecting to KeyAuth API.'; exit 1 ^
}" -username "%username%" -userkey "%userkey%"

if %errorlevel% neq 0 (
    echo.
    echo Login failed, please try again.
    pause
    goto KEYAUTH_LOGIN
)

goto STEALTH_MENU

:: ============================
:: Stealth Menu
:: ============================
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
:: Add setup logic here
pause
goto STEALTH_MENU

:RUN
echo Running main program...
:: Add run logic here
pause
goto STEALTH_MENU

:BYPASS
echo Bypassing...
:: Add bypass logic here
pause
goto STEALTH_MENU

:EXIT
exit
