#Requires -Version 7

# ----------------------------------------------------
# Current User, All Hosts Powershell Core v7 $PROFILE:
# ----------------------------------------------------

# Trust PSGallery
$galleryinfo = Get-PSRepository | Where-Object { $_.Name -eq "PSGallery" }
if (-not($galleryinfo.InstallationPolicy.Equals("Trusted"))) { Set-PSRepository -Name PSGallery -InstallationPolicy Trusted }

# Import Modules
# Import-Module posh-git
# Import-Module oh-my-posh
# Import-Module Terminal-Icons
# Import-Module WslInterop
# Import-Module PSWindowsUpdate
# Import-Module PSWriteColor
# Import-Module WieldingLs

# Enable Posh-Git
$env:POSH_GIT_ENABLED = $true

# Prompt
Set-PoshPrompt -Theme wopian

# ZLocation must be after all prompt changes:
Import-Module ZLocation
Write-Host -Foreground Green "`n[ZLocation] knows about $((Get-ZLocation).Keys.Count) locations.`n"
