Function Get-Token {
    <#
.SYNOPSIS
    This cmdlet returns an Azure API access token for the Azure Service Bus Resource Provider
.OUTPUTS
    API Token Object
.NOTES
    This can technically also be used for other services.
#>

    [CmdletBinding()]
    param (
        #Your Azure Context. This will be discovered automatically if you have already logged in with Connect-AzAccount
        [Microsoft.Azure.Commands.Profile.Models.Core.PSAzureContext]
        $Context = (Get-AzContext | Select-Object -First 1),

        #The application resource principal you wish to request a token for. Defaults to the Undocumented Azure Portal API
        #Common Examples: https://management.core.windows.net/ https://graph.windows.net/
        $Resource = 'https://servicebus.azure.net'
    )

    if (-not $Context) {
        Connect-AzAccount -ErrorAction Stop
        $Context = (Get-AzContext | Select-Object -First 1)
    }

    return (Get-AzAccessToken -ResourceUrl $Resource).Token
}