<#
.SYNOPSIS
    Receive and delete a message from Azure Service Bus topic's subscription
.DESCRIPTION
    This cmdlet will receive and delete a message from a given Azure Service Bus Namespace topic's subscription. By default only the first message will be received, this can however be automatically repeated many more times using the RepeatCount parameter, clearing out a topic in only a few seconds.
.EXAMPLE
    C:\PS> Receive-SbMessage -NameSpace <ServiceBusNameSpaceName> -TopicName <TopicName> -SubscriptionName <SubscriptionName>
.EXAMPLE
    C:\PS>
    Another example of how to use this cmdlet
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
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$NameSpace,
        [Parameter(Mandatory = $true,
            HelpMessage = 'The name of the Service Bus Namespace Topic')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$TopicName,
        [Parameter(Mandatory = $true,
            HelpMessage = 'The name of the Service Bus Topic Subscription')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$SubscriptionName,
        [Parameter(HelpMessage = 'How many messages should we receive / delete? Understand this as a batch size.')]
        [int]$BatchSize=1
    )

    $token = Get-Token
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

    1..$BatchSize | Foreach-Object {
        $PowerShell = [powershell]::Create()
        $PowerShell.RunspacePool = $RunspacePool
        $PowerShell.AddScript($ScriptBlock).AddArgument($_)
        $Jobs += $PowerShell.BeginInvoke()
    }

    while ($Jobs.IsCompleted -contains $false) {
        Start-Sleep 1
    }

    $stopWatch.Stop()
    return $stopWatch.Elapsed

} #Receive-SbMessage

