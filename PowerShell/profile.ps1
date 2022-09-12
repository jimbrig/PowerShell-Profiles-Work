#Requires -Version 7

# ----------------------------------------------------
# Current User, All Hosts Powershell Core v7 $PROFILE:
# ----------------------------------------------------

# Set System to use TLS 1.2 for .NET:
If ([Net.ServicePointManager]::SecurityProtocol -ne 'Tls12') {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}

# Loop through and dot-source `Profile` files:
$psfiles = Join-Path (Split-Path -Parent $profile) "Profile" | Get-ChildItem -Filter "*.ps1"
ForEach ($file in $psfiles) { . $file }
