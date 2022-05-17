Function Get-Token {
    <#
    .SYNOPSIS
        Refreshes the API token if required (by https://github.com/JustinGrote/Az.PortalAPI/blob/master/Az.PortalAPI/Public/Get-Token.ps1)
    .OUTPUTS
    API Token Object
    .NOTES
    Inspired by https://github.com/Azure/azure-powershell/issues/7525#issuecomment-432384270
    #>

        [CmdletBinding(SupportsShouldProcess)]
        param (
            #Your Azure Context. This will be discovered automatically if you have already logged in with Connect-AzAccount
            [Microsoft.Azure.Commands.Profile.Models.Core.PSAzureContext]
            $Context = (Get-AzContext | select -first 1),

            #The application resource principal you wish to request a token for. Defaults to the Undocumented Azure Portal API
            #Common Examples: https://management.core.windows.net/ https://graph.windows.net/
            $Resource = 'https://servicebus.azure.net'
        )

        if (-not $Context) {
            Connect-AZAccount -ErrorAction Stop
            $Context = (Get-AzContext | select -first 1)
        }

        return ([Microsoft.Azure.Commands.Common.Authentication.AzureSession]::Instance.AuthenticationFactory.Authenticate($context.Account, $context.Environment, $context.Tenant.Id, $null, "Never", $null, $Resource)).AccessToken
    }