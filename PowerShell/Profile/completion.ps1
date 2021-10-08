$psdir = (Split-Path -parent $profile)

# Chocolatey
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Winget

# Scoop

# Docker

# npm

# git

# Git Cliff
. $psdir\Profile\completions\git-cliff.ps1