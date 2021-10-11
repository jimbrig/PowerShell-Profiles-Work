# Shell Completion Modules
Import-Module Microsoft.PowerShell.Utility
Import-Module DockerCompletion
Import-Module scoop-completion

$psdir = (Split-Path -parent $profile)
$completionpath = "$HOME\Documents\PowerShell\Profile\completions"
$files = (Get-ChildItem -Path $completionpath).Name

ForEach ($file in $files) { . $psdir\Profile\completions\$file }