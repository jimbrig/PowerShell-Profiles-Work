# PowerShell / Azure-CLI Script

# $ip = (Invoke-WebRequest -Uri 'https://api.ipify.org').Content

Function Get-MyIPv4Address {
    <#
    .SYNOPSIS
    Get the public IPv4 address of the current machine.
    .DESCRIPTION
    Get the public IPv4 address of the current machine.
    .EXAMPLE
    Get-MyIPv4Address
    #>

    Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $(Get-NetConnectionProfile | Select-Object -ExpandProperty InterfaceIndex) | `
        Select-Object -ExpandProperty IPAddress

}

Function Set-NewAzureServerFirewallRule {
    <#
    .SYNOPSIS
    Set a new firewall rule for an Azure SQL Server.
    .DESCRIPTION
    Set a new firewall rule for an Azure SQL Server.
    .PARAMETER RuleName
    The name of the firewall rule.
    .PARAMETER ServerName
    The name of the Azure SQL Server.
    .PARAMETER ResourceGroupName
    The name of the Azure Resource Group.
    .PARAMETER StartIPAddress
    The start IP address of the firewall rule.
    .PARAMETER EndIPAddress
    The end IP address of the firewall rule.
    .EXAMPLE
    # Set a new firewall rule for an Azure SQL Server
    # Exclude the -StartIPAddress and -EndIPAddress parameters to auto-detect the current machine's public IPv4 address:
    Set-NewAzureServerFirewallRule -RuleName 'DESKTOP' -ServerName 'MyServer' -ResourceGroupName 'MyResourceGroup'
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,Position=0)]
        [string]$RuleName,
        [Parameter(Mandatory=$true,Position=1)]
        [string]$ServerName,
        [Parameter(Mandatory=$true,Position=2)]
        [string]$ResourceGroupName,
        [Parameter(Mandatory=$false,Position=3)]
        [string]$StartIPAddress,
        [Parameter(Mandatory=$false,Position=4)]
        [string]$EndIPAddress = $StartIPAddress
    )

    If (-not $StartIPAddress) {
        $StartIPAddress = Get-MyIPv4Address
        $EndIPAddress = $StartIPAddress
    }

    If (!(Get-Command az -ErrorAction SilentlyContinue)) {
        throw "The Azure CLI is not installed. Please install it from https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest"
    }

    az sql server firewall-rule create --name $RuleName --server $ServerName --resource-group $ResourceGroupName `
        --start-ip-address $StartIPAddress --end-ip-address $EndIPAddress

}
