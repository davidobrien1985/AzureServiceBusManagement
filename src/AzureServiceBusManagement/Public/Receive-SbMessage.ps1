<#
.SYNOPSIS
    Receive and delete a message from Azure Service Bus topic's subscription
.DESCRIPTION
    This cmdlet will receive and delete a message from a given Azure Service Bus Namespace topic's subscription. By default only the first message will be received, this can however be automatically repeated many more times using the BatchSize parameter, clearing out a topic in only a few seconds.
.EXAMPLE
    C:\PS> Receive-SbMessage -NameSpace <ServiceBusNameSpaceName> -TopicName <TopicName> -SubscriptionName <SubscriptionName>
.PARAMETER InputObject
    Specifies the object to be processed.  You can also pipe the objects to this command.
.OUTPUTS
    Output from this cmdlet (if any)
.NOTES
    General notes
.COMPONENT
    AzureServiceBusManagement
#>
function Receive-SbMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'The name of the Service Bus Namespace')]
        [ValidateNotNullOrEmpty()]
        [string]$NameSpace,
        [Parameter(Mandatory = $true,
            HelpMessage = 'The name of the Service Bus Namespace Topic')]
        [ValidateNotNullOrEmpty()]
        [string]$TopicName,
        [Parameter(Mandatory = $true,
            HelpMessage = 'The name of the Service Bus Topic Subscription')]
        [ValidateNotNullOrEmpty()]
        [string]$SubscriptionName,
        [Parameter(HelpMessage = 'How many messages should we receive / delete? Understand this as a batch size.')]
        [int]$BatchSize=1
    )

    $token = Get-SbApiToken
    $headers = @{
        'Authorization' = 'Bearer ' + $token
    }

    $stopWatch = [system.diagnostics.stopwatch]::startNew()

    $Scriptblock = {
        param($NameSpace, $TopicName, $SubscriptionName, $headers)
        Invoke-RestMethod -Uri "https://$($NameSpace).servicebus.windows.net//$($TopicName)/subscriptions/$($SubscriptionName)/messages/head?api-version=2015-01" -Method Delete -Headers $headers
    }

    $MaxThreads = 5
    $RunspacePool = [runspacefactory]::CreateRunspacePool(1, $MaxThreads)
    $RunspacePool.Open()
    $Jobs = @()

    Write-Verbose "Calling the Azure Service Bus API endpoint for Service Bus Namespace $($NameSpace), Topic $($TopicName) and Subscription $($SubscriptionName)."

    1..$BatchSize | ForEach-Object {
        $PowerShell = [powershell]::Create().AddScript($ScriptBlock).AddParameter('NameSpace', $NameSpace).AddParameter('TopicName', $TopicName).AddParameter('SubscriptionName', $SubscriptionName).AddParameter('headers', $headers)
        $PowerShell.RunspacePool = $RunspacePool
        $Jobs += $PowerShell.BeginInvoke()
    }

    while ($Jobs.IsCompleted -contains $false) {
        Start-Sleep 1
    }

    $stopWatch.Stop()
    return $stopWatch.Elapsed

} #Receive-SbMessage
