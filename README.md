# PowerShell Profiles - Work

My Customized Powershell Profiles for Work: 
- `~/Documents/PowerShell` (Core)
- `~/Documents/WindowsPowerShell` (Windows)

See the [Changelog](CHANGELOG.md) for details on this repository's development over time.

## Contents

- [PowerShell](#powershell)
  - [Contents](#contents)
  - [$PROFILE](#profile)
    - [Profile Features](#profile-features)
  - [Custom Functions](#custom-functions)
  - [Custom Aliases](#custom-aliases)
  - [Custom Shell Completions](#custom-shell-completions)
  - [Modules](#modules)
  - [Scripts](#scripts)
  - [Functions](#functions)

## $PROFILE

In this repository there are the following profile files:

- PowerShell Core (~/Documents/PowerShell):
  - [profile.ps1](PowerShell/profile.ps1) - *CurrentUserAllHosts* Profile
  - [Microsoft.PowerShell_profile.ps1](PowerShell/Microsoft.PowerShell_profile.ps1) - *CurrentUserCurrentHost* Profile - The Default `$PROFILE`
  - [Microsoft.VSCode_profile.ps1](PowerShell/Microsoft.VSCode_profile.ps1) - VSCode Specific Host Profile

Here are the `$PROFILE` path's to various PowerShell 7 Profile Locations on Windows 10 (note that I am currently *not* using OneDrive):

```powershell
➜ $PROFILE
C:\Users\jbriggs010\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
➜ $PROFILE.CurrentUserCurrentHost
C:\Users\jbriggs010\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
➜ $PROFILE.CurrentUserAllHosts
C:\Users\jbriggs010\Documents\PowerShell\profile.ps1
➜ $PROFILE.AllUsersCurrentHost
C:\Program Files\PowerShell\7-preview\Microsoft.PowerShell_profile.ps1
➜ $PROFILE.AllUsersAllHosts
C:\Program Files\PowerShell\7-preview\profile.ps1
```

### Profile Features

For [profile.ps1](PowerShell/profile.ps1):

- Trust `PSGallery`
- Import necessary modules in specific order
- Enable `posh-git`
- Set `prompt` theme via `oh-my-posh`
- Return a string with details for the `ZLocation` module's known locations.

<details><summary>🔎 View Code</summary>
 <p>

```powershell
#Requires -Version 7

# ----------------------------------------------------
# Current User, All Hosts Powershell Core v7 $PROFILE:
# ----------------------------------------------------

# Trust PSGallery
$galleryinfo = Get-PSRepository | Where-Object { $_.Name -eq "PSGallery" }
if (-not($galleryinfo.InstallationPolicy.Equals("Trusted"))) { Set-PSRepository -Name PSGallery -InstallationPolicy Trusted }

# Import Modules
Import-Module posh-git
Import-Module oh-my-posh
Import-Module Terminal-Icons
Import-Module WslInterop
Import-Module PSWindowsUpdate
Import-Module PSWriteColor

# Enable Posh-Git
$env:POSH_GIT_ENABLED = $true

# Prompt
Set-PoshPrompt -Theme wopian

# ZLocation must be after all prompt changes:
Import-Module ZLocation
Write-Host -Foreground Green "`n[ZLocation] knows about $((Get-ZLocation).Keys.Count) locations.`n"
```
   
  </p>
 </details> 
   
Optional:

- Import WSL Linux/BASH Interop Commands (ls, awk, tree, etc.)
- Set `PSReadLine` options
- Start custom log
- Map custom `PSDrive`'s to common folders
   
For [Microsoft.PowerShell_profile.ps1](PowerShell/Microsoft.PowerShell_profile.ps1):

- Load custom [Profile Completions - completion.ps1](PowerShell/Profile/completion.ps1)
- Load custom [Profile Functions - functions.ps1](PowerShell/Profile/functions.ps1)
- Load custom [Profile Aliases - aliases.ps1](PowerShell/Profile/aliases.ps1)
   
<details><summary>🔎 View Code</summary>
 <p>

```powershell
#Requires -Version 7

# -------------------------------------------------------
# Current User, Current Host Powershell Core v7 $PROFILE:
# -------------------------------------------------------

# Load Functions, Aliases, and Completion
$psdir = (Split-Path -parent $profile)

If (Test-Path "$psdir\Profile\functions.ps1") { . "$psdir\Profile\functions.ps1" }
If (Test-Path "$psdir\Profile\aliases.ps1") { . "$psdir\Profile\aliases.ps1" }
If (Test-Path "$psdir\Profile\completion.ps1") { . "$psdir\Profile\completion.ps1" }

```

</p>
</details>

   
## Custom Functions

My suite of custom functions to be loaded for every PowerShell session:
  - Search functions via [zquestz/s](https://github.com/zquestz/s)
  - Google Calendar functions via [gcalcli](https://github.com/insanum/gcalcli)
  - Directory listing functions for `lsd`
  - System Utility Functions
  - Symlinking Functions
  - Network Utilities
  - Programs
  - PowerShell helpers
  - Remoting
  - Chocolatey
  - R and RStudio
  - GitKraken
   
- See [functions.ps1](PowerShell/Profile/functions.ps1):
   
<details><summary>🔎 View Code</summary>
 <p>
   
```powershell
# ---------------------------------
# PowerShell Core Profile Functions
# ---------------------------------

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
   
```
   
 </p>
</details>
   
## Custom Aliases

- See [aliases.ps1](PowerShell/Profile/aliases.ps1):

<details><summary>🔎 View Code</summary>
 <p>
   
```powershell
Set-Alias -Name irs -Value Invoke-RemoteScript
Set-Alias -Name pro -Value Edit-Profile
Set-Alias -Name aliases -Value Get-Alias
Set-Alias -Name cpkgs -Value chocopkgs
Set-Alias -Name cclean -Value chococlean
Set-Alias -Name csearch -Value chocosearch
Set-Alias -Name cup -Value chocoupgrade
Set-Alias -Name cbackup -Value chocobackup
Set-Alias -Name refresh -Value refreshenv
Set-Alias -Name touch -Value New-File
Set-Alias -Name rproj -Value openrproj
Set-Alias -Name chkdisk -Value Check-Disk
Set-Alias -Name cdd -Value CreateAndSet-Directory
Set-Alias -Name emptytrash -Value Clear-RecycleBin
Set-Alias -Name codee -Value code-insiders
Set-Alias -Name cpkgs -Value chocopkgs
Set-Alias -Name cup -Value chocoupgrade
Set-Alias -Name gcal -Value gcalcli
Set-Alias -Name agenda -Value Get-Agenda
Set-Alias -Name gcalm -Value Get-CalendarMonth
Set-Alias -Name gcalw -Value Get-CalendarWeek
Set-Alias -Name gcalnew -Value New-CalendarEvent

# Ensure `R` is for launching an R Terminal:
if (Get-Command R.exe -ErrorAction SilentlyContinue | Test-Path) {
  Remove-Item Alias:r -ErrorAction SilentlyContinue
  ${function:r} = { R.exe @args }
}

# Ensure GPG Points to GnuPG:
set-alias gpg 'C:\Program Files (x86)\gnupg\bin\gpg.exe'
```
   
 </p>
</details>
   
## Custom Shell Completions

- Shell completion for:
  - Docker
  - PowerShell
  - Scoop
  - Chocolatey
  - WinGet
  - Github-CLI
  - Git Cliff (changelog generator)
  - Keep
  - DotNet

- See [completion.ps1](PowerShell/Profile/completion.ps1) and the [completions folder](PowerShell/Profile/completions):

<details><summary>🔎 View Code</summary>
 <p>
   
```powershell
# Shell Completion Modules
Import-Module Microsoft.PowerShell.Utility
Import-Module DockerCompletion
Import-Module scoop-completion

$psdir = (Split-Path -parent $profile)
$completionpath = "$HOME\Documents\PowerShell\Profile\completions"
$files = (Get-ChildItem -Path $completionpath).Name

ForEach ($file in $files) { . $psdir\Profile\completions\$file } 
```
   
 </p>
</details>
   
## Modules

## Scripts
   
## Other Functions
