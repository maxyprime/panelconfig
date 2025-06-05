@echo off
setlocal enabledelayedexpansion

:: === Stealth password read from config.txt ===
set "PASSWORD="
for /f "tokens=1,2 delims==" %%a in (config.txt) do (
    if "%%a"=="password" set "PASSWORD=%%b"
)

:LOGIN_PASS
cls
echo ==========================================
echo            PC Optimization
echo       Developed by MaxyPrime
echo ==========================================
echo.
echo Enter stealth password:
set /p userpass=

if "%userpass%"=="%PASSWORD%" (
    goto KEYAUTH_LOGIN
) else (
    echo Incorrect password. Try again.
    timeout /t 2 /nobreak >nul
    goto LOGIN_PASS
)

:: --- KeyAuth login prompt ---
:KEYAUTH_LOGIN
cls
echo ==========================================
echo          KeyAuth User Login
echo ==========================================
echo.
set /p username=Enter username:
set /p userkey=Enter license key:

:: Call PowerShell script to verify KeyAuth credentials
powershell -Command ^
"$url = 'https://keyauth.win/api/1.3/';" ^
"$name = 'Arunkumar.pandi''s Application';" ^
"$ownerid = 'fnnkAQsWWq';" ^
"$version = '1.0';" ^
"$username = '%username%';" ^
"$userkey = '%userkey%';" ^
"" ^
"$params = @{name=$name; ownerid=$ownerid; ver=$version; user=$username; key=$userkey};" ^
"$query = $params.GetEnumerator() | ForEach-Object { $_.Key + '=' + [uri]::EscapeDataString($_.Value) } -join '&';" ^
"$api_url = $url + '?'+ $query;" ^
"$response = Invoke-RestMethod -Uri $api_url -UseBasicParsing;" ^
"if ($response.success) { exit 0 } else { Write-Host 'Login failed: ' + $response.message; exit 1 }"

if %errorlevel% neq 0 (
    echo.
    echo Login failed, please try again.
    pause
    goto KEYAUTH_LOGIN
)

goto STEALTH_MENU

:: --- Stealth Menu ---
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
