# Install-Module yarn-completion -Scope CurrentUser
If (Get-Module -Name yarn-completion -ErrorAction SilentlyContinue) { 
    Import-Module yarn-completion
}