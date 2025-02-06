$variable1 = $env:ursSiteID # Script Variable
$variable2 = $env:siteID # Site Variable

$siteID = if ([string]::IsNullOrEmpty($variable1)) { 
    $variable2 
} else { 
    $variable1 
}

$url = "https://merlot.centrastage.net/csm/profile/downloadAgent/$siteID"

Write-Host "$url"
# Terminate the process gui.exe if running
Stop-Process -Name "gui" -Force -ErrorAction SilentlyContinue

# Inform the user about the uninstallation process
Write-Host "Waiting for Datto RMM to be removed..."

# Execute the uninstallation of Datto RMM
Start-Process "C:\Program Files (x86)\CentraStage\uninst.exe" -ArgumentList "/S" -NoNewWindow -Wait -ErrorAction SilentlyContinue

# Pause execution for 10 seconds
Start-Sleep -Seconds 10

# Remove directories and their contents
$paths = @(
    "C:\Program Files (x86)\CentraStage",
    "C:\Windows\System32\config\systemprofile\AppData\Local\CentraStage",
    "C:\Windows\SysWOW64\config\systemprofile\AppData\Local\CentraStage",
    "$env:userprofile\AppData\Local\CentraStage",
    "$env:ALLUSERSPROFILE\CentraStage"
)

foreach ($path in $paths) {
    Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
}

# Delete the registry key
Remove-ItemProperty -Path "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" -Name "CentraStage" -Force -ErrorAction SilentlyContinue

# Pause execution for 2 minutes
Start-Sleep -Seconds 120 
#


(New-Object System.Net.WebClient).DownloadFile("$url", "$env:TEMP/AgentInstall.exe");start-process "$env:TEMP/AgentInstall.exe"
