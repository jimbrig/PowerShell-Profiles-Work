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
Remove-Alias r
${function:r} = { R.exe @args }

# Ensure GPG Points to GnuPG:
set-alias gpg 'C:\Program Files (x86)\gnupg\bin\gpg.exe'

# Apply 'ls' alias from WieldingLs Module
If (Get-Command Get-DirectoryContents) {
    Set-Alias -Name ls -Value Get-DirectoryContents
    ${function:lsl} = { Get-DirectoryContents -DisplayFormat Long $args }
    ${function:lsa} = { Get-DirectoryContents -ShowLong -ShowHidden }
}