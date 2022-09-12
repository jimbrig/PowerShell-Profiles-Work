# sqlpackage /a:extract /of:true /sdn:"dev" /sp:"KjqekNwI85" /ssn:"raphael.database.windows.net" /su:"renreadmin" /tf:"C:\Users\jbriggs010\Dev\dev.dacpac";

Function Extract-DacPacFromDB {

    <#
        .SYNOPSIS
            Extracts a dacpac from a database
        .PARAMETER ServerName
            The name of the server to connect to
        .PARAMETER DatabaseName
            The name of the database to extract the dacpac from on the server
        .PARAMETER UserName
            The username to use when connecting to the server
        .PARAMETER Password
            The password to use when connecting to the server
        .PARAMETER DacPacPath
            The path to output the created dacpac
        .PARAMETER Overwrite
            Whether or not to overwrite the dacpac if it already exists
        .DESCRIPTION
            Extracts a dacpac from a database
        .EXAMPLE
            Extract-DacPacFromDB -ServerName "mydb.database.windows.net" -DatabaseName "dev" -UserName "admin" -Password "P@ssword1" -DacPacPath "~\Desktop\mydb.dev.dacpac" -Overwrite $true
        .NOTES
            This function is used to extract a dacpac from a database and wraps the `sqlpackage` command line utility.
        .LINK
            https://docs.microsoft.com/en-us/sql/relational-databases/tools/sqlpackage
    #>

    param (
        [Parameter(Mandatory = $true)]
        [String]
        $ServerName,
        [Parameter(Mandatory = $true)]
        [String]
        $DatabaseName,
        [Parameter(Mandatory = $true)]
        [String]
        $UserName,
        [Parameter(Mandatory = $true)]
        [String]
        $Password,
        [Parameter(Mandatory = $true)]
        [String]
        $DacPacPath,
        [Parameter(Mandatory = $false)]
        [bool]
        $Overwrite = $true
    )

    If (!(Get-Command sqlpackage)) {
        throw "The sqlpackage command line utility is not installed or not found on your system PATH."
    }

    $DacPacPath = $DacPacPath.Replace('~', $HOME)    

    sqlpackage /a:extract /of:true /sdn:"$DatabaseName" /sp:"$Password" /ssn:"$ServerName" /su:"$UserName" /tf:"$DacPacPath";

}

