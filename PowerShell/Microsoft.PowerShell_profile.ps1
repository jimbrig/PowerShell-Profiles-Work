#Requires -Version 7

# -------------------------------------------------------
# Current User, Current Host Powershell Core v7 $PROFILE:
# -------------------------------------------------------

# Load Functions, Aliases, and Completion
$psdir = (Split-Path -parent $profile)

If (Test-Path "$psdir\Profile\functions.ps1") { . "$psdir\Profile\functions.ps1" }
If (Test-Path "$psdir\Profile\aliases.ps1") { . "$psdir\Profile\aliases.ps1" }
If (Test-Path "$psdir\Profile\completion.ps1") { . "$psdir\Profile\completion.ps1" }

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
