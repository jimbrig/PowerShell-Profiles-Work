# Install-Module npm-completion -Scope CurrentUser
If (Get-Module -Name npm-completion -ErrorAction SilentlyContinue) { 
    Import-Module npm-completion
}