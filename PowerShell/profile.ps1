#Requires -Version 7

# ----------------------------------------------------
# Current User, All Hosts Powershell Core v7 $PROFILE:
# ----------------------------------------------------

# Trust PSGallery
$galleryinfo = Get-PSRepository | Where-Object { $_.Name -eq "PSGallery" }
if (-not($galleryinfo.InstallationPolicy.Equals("Trusted"))) { Set-PSRepository -Name PSGallery -InstallationPolicy Trusted }

# Load Functions, Aliases, and Completion
$psdir = (Split-Path -parent $profile)

If (Test-Path "$psdir\Profile\functions.ps1") { . "$psdir\Profile\functions.ps1" }
If (Test-Path "$psdir\Profile\aliases.ps1") { . "$psdir\Profile\aliases.ps1" }
If (Test-Path "$psdir\Profile\completion.ps1") { . "$psdir\Profile\completion.ps1" }
If (Test-Path "$psdir\Profile\modules.ps1") { . "$psdir\Profile\modules.ps1" }

Set-PSReadLineOption -PredictionSource History -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
Set-PSReadLineOption -PredictionViewStyle ListView -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

# Prompt
Set-PoshPrompt -Theme wopian -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

# ZLocation must be after all prompt changes:
Import-Module ZLocation
Write-Host -Foreground Green "`n[ZLocation] knows about $((Get-ZLocation).Keys.Count) locations.`n"
