<#
.SYNOPSIS
    Send a message to Azure Service Bus topic
.DESCRIPTION
    This cmdlet will send a message to a given Azure Service Bus Namespace topic.
.EXAMPLE
    C:\PS> Send-SbTestMessage -NameSpace <ServiceBusNameSpaceName> -TopicName <TopicName>
.PARAMETER InputObject
    Specifies the object to be processed.  You can also pipe the objects to this command.
.OUTPUTS
    Output from this cmdlet (if any)
.NOTES
    General notes
.COMPONENT
    AzureServiceBusManagement
#>
function Send-SbTestMessage {
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
        [Parameter(HelpMessage = 'Message that should be put onto the Service Bus Topic.')]
        [ValidateNotNullOrEmpty()]
        [string]$message,
        [Parameter(HelpMessage = 'How many messages should we send? Understand this as a batch size.')]
        [int]$BatchSize = 1
    )

    $token = Get-SbApiToken
    $headers = @{
        'Authorization'    = 'Bearer ' + $token
        'Content-Type'     = 'application/atom+xml;type=entry;charset=utf-8'
        'BrokerProperties' = '{"Label":"M1","State":"Active","TimeToLive":10}'
    }

    $stopWatch = [system.diagnostics.stopwatch]::startNew()

    $Scriptblock = {
        param($NameSpace, $TopicName, $message, $headers)
        Invoke-RestMethod -Uri "https://$($NameSpace).servicebus.windows.net//$($TopicName)/messages/?api-version=2015-01" -Body $message -Method Post -Headers $headers
    }

    $MaxThreads = 10
    $RunspacePool = [runspacefactory]::CreateRunspacePool(1, $MaxThreads)
    $RunspacePool.Open()
    $Jobs = @()

    Write-Verbose "Calling the Azure Service Bus API endpoint for Service Bus Namespace $($NameSpace), Topic $($TopicName) and sending the following $($message)."

    1..$BatchSize | ForEach-Object {
        $PowerShell = [powershell]::Create().AddScript($ScriptBlock).AddParameter('NameSpace', $NameSpace).AddParameter('TopicName', $TopicName).AddParameter('message', $message).AddParameter('headers', $headers)
        $PowerShell.RunspacePool = $RunspacePool
        $Jobs += $PowerShell.BeginInvoke()
    }

    while ($Jobs.IsCompleted -contains $false) {
        Start-Sleep 1
    }

    $stopWatch.Stop()
    return $stopWatch.Elapsed

}
