# Example Publish:
# Publish-DbaDacPackage -SqlInstance 172.28.49.218 -SqlCredential sa -Path $exportFile -PublishXml C:\Users\jbriggs010\Dev\databases\PublishXml.xml -Database prod -GenerateDeploymentReport -Type Dacpac -OutputPath C:\Users\jbriggs010\Dev -Verbose

# Example Publish with SCRIPT:
# Publish-DbaDacPackage -SqlInstance 172.28.49.218 -SqlCredential sa -Path $exportFile -PublishXml C:\Users\jbriggs010\Dev\databases\PublishXml.xml -Database prod -GenerateDeploymentReport -ScriptOnly -Type Dacpac -OutputPath C:\Users\jbriggs010\Dev -Verbose

# Example Extract:
# Export-DbaDacPackage -SqlInstance raphael.database.windows.net -SqlCredential renreadmin -Database PROD -Path C:\Users\jbriggs010\Dev -ExtendedProperties "/p:IgnorePermissions=True /p:IgnoreUserLoginMappings=True"

Function Export-SqlDacPac {
    <#
    .Synopsis
        Extracts a SQL Server DACPAC file to a folder
    .DESCRIPTION
        Extracts a SQL Server DACPAC file to a folder
    .EXAMPLE
        Extract-SqlDacPac -DacPacPath 'C:\Temp\MyDacPac.dacpac' -DestinationPath 'C:\Temp\MyDacPac'
    .PARAMETER Server
        The name of the SQL Server to connect to
    .PARAMETER Database
        The name of the database to connect to
    .PARAMETER Path
        The path to the DACPAC file to extract
    .PARAMETER IncludeData
        Include data in the extracted DACPAC?
    #>
    [CmdletBinding()]
    Param (
        $Server,
        $Database,
        $Path,
        [switch]$IncludeData
    )

    # Prepare extraction properties string
    $exportProperties = "/p:IgnorePermissions=True /p:IgnoreUserLoginMappings=True" # Ignore permissions definition

    if ($IncludeData) {
        $exportProperties += " /p:ExtractAllTableData=True" #Extract data
    }
    
    Export-DbaDacPackage -SqlInstance $Server -Database $Database -Path C:\temp -ExtendedProperties $exportProperties

}

Function Sync-SqlDacPac {

    <#
        .Synopsis
            Synchronizes a SQL Server database using a DACPAC file between two servers.
        .DESCRIPTION
            This function will extract a DACPAC file from an existing SQL Server database and then deploy it to a 
            different server using a `publish.xml` file.
        .PARAMETER SourceServer
            The name of the SQL Server instance to extract the DACPAC file from.
        .PARAMETER SourceDatabase
            The name of the database to extract the DACPAC file from.
        .PARAMETER DestinationServer
            The name of the SQL Server instance to deploy the DACPAC file to.
        .PARAMETER DestinationDatabase
            The name of the database to deploy the DACPAC file to.
        .PARAMETER Path
            The path to the DACPAC file.
        .PARAMETER PublishXml
            The path to the `publish.xml` file to use for the deployment.
        .PARAMETER IncludeData
            Include data in the DACPAC file.
        .EXAMPLE
            Migrate-SqlDacPac -SourceServer sql1 -SourceDatabase MyDatabase -DestinationServer sql2 -DestinationDatabase MyDatabase -PublishXml C:\temp\publish.xml
        .EXAMPLE
            Migrate-SqlDacPac -SourceServer sql1 -SourceDatabase MyDatabase -DestinationServer sql2 -DestinationDatabase MyDatabase -PublishXml C:\temp\publish.xml -IncludeData
    #>

    [CmdletBinding()]

    Param (
        [Parameter(Mandatory=$true)]
        [string]$SourceServer,
        [Parameter(Mandatory=$true)]
        [string]$SourceDatabase,
        [Parameter(Mandatory=$true)]
        [string]$DestinationServer,
        [Parameter(Mandatory=$true)]
        [string]$DestinationDatabase,
        [Parameter(Mandatory=$false)]
        [string]$Path = $env:TEMP,
        [Parameter(Mandatory=$true)]
        [string]$PublishXml,
        [switch]$IncludeData
    )

    # Stop on Error
    $ErrorActionPreference = "Stop"

    # Construct Export Properties
    $exportProperties = "/p:IgnorePermissions=True /p:IgnoreUserLoginMappings=True"

    if ($IncludeData) {
        $exportProperties += " /p:ExtractAllTableData=True"
    }

    # Export Database to Path as DACPAC
    Write-Verbose "Exporting database $SourceDatabase from $SourceServer to $env:TEMP"
    $exportFile = Export-DbaDacPackage -SqlInstance $SourceServer -Database $SourceDatabase -Path $Path -ExtendedProperties $exportProperties -EnableException -Verbose
    Write-VeryVerbose "Exported database $SourceDatabase from $SourceServer to $Path\$exportFile"

    # Publish DACPAC to Destination Server
    Write-Verbose "Publishing database $DestinationDatabase to $DestinationServer"
    $xmlPath = (Get-Item $PublishXml).FullName # [xml](Get-Content $PublishXml).FullName
    Publish-DbaDacPackage -SqlInstance $DestinationServer -Database $DestinationDatabase -Path $exportFile.Path -PublishXml $xmlPath -EnableException -Verbose
    Write-Verbose "Published database $DestinationDatabase to $DestinationServer"

    # Cleanup DacPac
    If (Test-Path $exportFile.Path) {
        Write-Verbose "Removing DacPac File from $($exportFile.Path)"
        Remove-Item $exportFile.Path -Force
    }

}


# Example Usage
# Sync-SqlDacPac -SourceServer sql1 -SourceDatabase MyDatabase -DestinationServer sql2 -DestinationDatabase MyDatabase -PublishXml C:\temp\publish.xml
