Function Get-OutdatedModules {
    <#
    .Synopsis
        Get a list of outdated PowerShell Modules
    .DESCRIPTION
        Get a list of outdated PowerShell Modules
    .EXAMPLE
        Get-OutdatedModules -Verbose
    #>
    [CmdletBinding()]
    Param ()

    $Modules = Get-InstalledModule

    # Create an empty array to store our results in.
    $modcheck = @();
    
    # Loop through all the modules.
    foreach ($mod in $Modules) {

        # get the information for the latest from PSGallery.
        $PSGalleryMod = Find-Module $mod.Name;
        
        # Compare the installed version to the PSGallery version.
        if ($PSGalleryMod.Version -ne $mod.version) {
        
            # if they're different, put the details in a PSCustomObject.
            $modversions = [pscustomobject]@{
                Name = $($mod.name)
                InstalledVersion = $($mod.Version);InstalledPubDate = $($mod.PublishedDate.tostring('MM/dd/yy'))
                AvailableVersion = $($PSGalleryMod.Version)
                NewPubDate = $($PSGalleryMod.PublishedDate.tostring('MM/dd/yy'))
            }
        
            # add the object to the array.
            $modcheck += $modversions;

            if ($Verbose) {
                Write-Verbose "Module $($mod.name) is outdated. Installed version: $($mod.Version) Available version: $($PSGalleryMod.Version)"
            }
        }
    }

    # return the array.
    return $modcheck | Format-Table -AutoSize;

} 

