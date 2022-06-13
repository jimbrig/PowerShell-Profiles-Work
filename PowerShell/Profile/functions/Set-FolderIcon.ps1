<#
.SYNOPSIS
This function sets a folder icon on specified folder.
.DESCRIPTION
This function sets a folder icon on specified folder. Needs the path to the icon file to be used and the path to the folder the icon is to be applied to. 
This function will create two files in the destination path, both set as Hidden files. DESKTOP.INI and FOLDER.ICO
.PARAMETER Icon
Path to the icon (*.ico) file to use.
.PARAMETER Path
Path to the folder to add the icon to.
.PARAMETER Recurse
[Boolean] Recurse sub-directories?
.EXAMPLE
Set-FolderIcon -Icon "C:\Users\Mark\Downloads\Radvisual-Holographic-Folder.ico" -Path "C:\Users\Mark"
Changes the default folder icon to the custom one I donwloaded from Google Images.
.EXAMPLE
Set-FolderIcon -Icon "C:\Users\Mark\Downloads\wii_folder.ico" -Path "\\FAMILY\Media\Wii"
Changes the default folder icon to custom one for a UNC Path.
.EXAMPLE
Set-FolderIcon -Icon "C:\Users\Mark\Downloads\Radvisual-Holographic-Folder.ico" -Path "C:\Test" -Recurse
Changes the default folder icon to custom one for all folders in specified folder and that folder itself.
#>
Function Set-FolderIcon {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $True, Position = 0)]
		[string[]]$Icon,
		[Parameter(Mandatory = $True, Position = 1)]
		[string]$Path
	)


	If (!(Test-Path $Icon)) {
		throw "[Error] Specified Icon Path not found: $Icon"
	}

	If (!(Test-Path $Path)) {
		throw "[Error] Specified Directory Path not found: $Path"
	}

	$TargetDirectory = Convert-Path $Path

	$DesktopIni = "[.ShellClassInfo]`n" + "IconResource=$Icon`n"

	If (Test-Path "$($TargetDirectory)\desktop.ini") {
		Write-Warning -Message "desktop.ini already found within directory."
	}
	
	Add-Content "$($TargetDirectory)\desktop.ini" -Value $DesktopIni
	(Get-Item "$($TargetDirectory)\desktop.ini" -Force).Attributes = 'Hidden, System, Archive'
	(Get-Item $TargetDirectory -Force).Attributes = 'ReadOnly, Directory'
	
}


