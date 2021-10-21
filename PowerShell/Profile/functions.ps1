# ---------------------------------
# PowerShell Core Profile Functions
# ---------------------------------

Function Update-ProfileModules {

  $modpath = ($env:PSModulePath -split ";")[0]
  $ymlpath = "$modpath\modules.yml"
  $mods = (Get-ChildItem $modpath -Directory).Name
  ConvertTo-Yaml -Data $mods -OutFile $ymlpath -Force

  # Set-Location "$HOME\Documents"
  # git pull
  # git add PowerShell/Modules/**
  # git commit -m "config: Updated modules configurations"
  # git-cliff -o "$HOME\Documents\CHANGELOG.md"
  # git add CHANGELOG.md
  # git commit -m "doc: update CHANGELOG.md for added modules"
  # git push

}

# ---------------------
# Search via `s-cli`
# ---------------------

If (Get-Command s -ErrorAction SilentlyContinue) {
  ${function:Search-GitHub} = { s -p github $args }
  ${function:Search-GitHubPwsh} = { s -p ghpwsh $args }
  ${function:Search-GitHubR} = { s -p ghr $args }
  ${function:Search-MyRepos} = { s -p myrepos $args }
}

# --------
# GCalCLI
# --------

If (Get-Command gcalcli -ErrorAction SilentlyContinue) {
  ${function:Get-Agenda} = { & gcalcli agenda }
  ${function:Get-CalendarMonth} = { & gcalcli calm }
  ${function:Get-CalendarWeek} = { & gcalcli calw }
  ${function:New-CalendarEvent} = { & gcalcli add }
}

# -----
# LSD
# -----
If (Get-Command lsd -ErrorAction SilentlyContinue) {
  ${function:lsa} = { & lsd -a }
}

# ----------------------
# System Utilities
# ----------------------

# WSLPATH from WSL
Function wslpath { wsl -e $args }

# Use WSL's `which` instead of provided Git `which.exe`:
Function which { wsl -e which $args }

# Check Disk
${function:Check-Disk} = { & chkdsk C: /f /r /x }

# Update Environment
${function:Update-Environment} = {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
  Write-Host -ForegroundColor Green "Sucessfully Refreshed Environment Variables For powershell.exe"
}

# Clean System
${function:Clean-System} = {
  Write-Host -Message 'Emptying Recycle Bin' -ForegroundColor Yellow
  (New-Object -ComObject Shell.Application).Namespace(0xA).items() | ForEach-Object { Remove-Item $_.path -Recurse -Confirm:$false }
  Write-Host 'Removing Windows %TEMP% files' -ForegroundColor Yellow
  Remove-Item c:\Windows\Temp\* -Recurse -Force -ErrorAction SilentlyContinue
  Write-Host 'Removing User %TEMP% files' -ForegroundColor Yellow
  Remove-Item “C:\Users\*\Appdata\Local\Temp\*” -Recurse -Force -ErrorAction SilentlyContinue
  Write-Host 'Removing Custome %TEMP% files (C:/Temp and C:/tmp)' -ForegroundColor Yellow
  Remove-Item c:\Temp\* -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item c:\Tmp\* -Recurse -Force -ErrorAction SilentlyContinue
  Write-Host 'Launchin cleanmgr' -ForegroundColor Yellow
  cleanmgr /sagerun:1 | Out-Null
  Write-Host '✔️ Done.' -ForegroundColor Green
}

# New File
${function:New-File} = { New-Item -Path $args -ItemType File -Force }

# New Directory
${function:New-Dir} = { New-Item -Path $args -ItemType Directory -Force }

# Net Directory and cd into
${function:CreateAndSet-Directory} = {
  New-Item -Path $args -ItemType Directory -Force
  Set-Location -Path "$args"
}

# Create Symlink
Function New-Link ($target, $link) {
  New-Item -Path $link -ItemType SymbolicLink -Value $target
}

# Take Ownership
Function Invoke-TakeOwnership ( $path ) {
  if ((Get-Item $path) -is [System.IO.DirectoryInfo]) {
    sudo TAKEOWN /F $path /R /D Y
  }
  else {
    sudo TAKEOWN /F $path
  }
}

# Force Delete
Function Invoke-ForceDelete ( $path ) {
  Take-Ownership $path
  sudo remove-item -path $path -Force -Recurse -ErrorAction SilentlyContinue
  if (!(Test-Path $path)) {
    Write-Host "✔️ Successfully Removed $path" -ForegroundColor Green
  }
  else {
    Write-Host "❌ Failed to Remove $path" -ForegroundColor Red
  }
}

# ------------------
# Network Utilities
# ------------------

# Get Public IP
${function:Get-PublicIP} = {
  $ip = Invoke-RestMethod -Uri 'https://api.ipify.org?format=json'
  "My public IP address is: $($ip.ip)"
}

# -----------------------
# Programs
# -----------------------

# Docker
${function:Start-Docker} = { Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" }
${function:Stop-Docker} = { foreach ($dock in (get-process *docker*).ProcessName) { sudo stop-process -name $dock } }

# Open GitKraken in Current Repo
${function:krak} = {
  $curpath = (get-location).ProviderPath
  If (!(Test-Path "$curpath\.git")) { Write-Error "Not a git repository. Run 'git init' or select a git tracked directory to open. Exiting.."; return }
  $logf = "$env:temp\krakstart.log"
  $newestExe = Resolve-Path "$env:localappdata\gitkraken\app-*\gitkraken.exe"
  If ($newestExe.Length -gt 1) { $newestExe = $newestExe[1] }
  Start-Process -filepath $newestExe -ArgumentList "--path $curpath" -redirectstandardoutput $logf
}

# Open RStudio in Current Repo
${function:rstudio} = {
  $curpath = (get-location).ProviderPath
  $logf = "$env:temp\rstudiostart.log"
  $exepath = "$env:programfiles\RStudio\bin\rstudio.exe"
  start-process -filepath $exepath -ArgumentList "--path $curpath" -redirectstandardoutput $logf
}

# --------------------------
# PowerShell Functions
# --------------------------

# Edit `profile.ps1`
${function:Edit-Profile} = { notepad.exe $PROFILE.CurrentUserAllHosts }

# Edit profile functions.ps1
${function:Edit-Functions} = {
  $prodir = Split-Path -Path $PROFILE -Parent
  $funcpath = "$prodir\Profile\functions.ps1"
  code $funcpath
}

# Edit profile aliases.ps1
${function:Edit-Aliases} = {
  $prodir = Split-Path -Path $PROFILE -Parent
  $funcpath = "$prodir\Profile\aliases.ps1"
  code $funcpath
}

# Edit profile completion.ps1
${function:Edit-Completion} = {
  $prodir = Split-Path -Path $PROFILE -Parent
  $funcpath = "$prodir\Profile\completion.ps1"
  code $funcpath
}

# Open Profile Directory in VSCode:
${function:Open-ProDir} = {
  $prodir = Split-Path -Path $PROFILE -Parent
  code $prodir
}

# ------------------
# Remoting
# ------------------

# Invoke Remote Script - Example: Invoke-RemoteScript <url>
Function Invoke-RemoteScript {
  [CmdletBinding()]
  param(
    [Parameter(Position = 0)]
    [string]$address,
    [Parameter(ValueFromRemainingArguments = $true)]
    $remainingArgs
  )
  Invoke-Expression "& { $(Invoke-RestMethod $address) } $remainingArgs"
}

# -----------
# Chocolatey
# -----------

${function:chocopkgs} = { & choco list --local-only }
${function:chococlean} = { & choco-cleaner }
${function:chocoupgrade} = { & choco upgrade all -y }
${function:chocobackup} = { & choco-package-list-backup }
${function:chocosearch} = { & choco search $args }

# ---------------
# R and RStudio
# ---------------

${function:rvanilla} = { & "C:\Program Files\R\R-4.1.1\bin\R.exe" --vanilla }
${function:radianvanilla} = { & "C:\Python39\Scripts\radian.exe" --vanilla }
${function:openrproj} = { & C:\bin\openrproject.bat }
${function:pakk} = { Rscript.exe "C:\bin\pakk.R" $args }
