---
external help file: AzureServiceBusManagement-help.xml
Module Name: AzureServiceBusManagement
online version:
schema: 2.0.0
---

# Receive-SbMessage

## SYNOPSIS
Receive and delete a message from Azure Service Bus topic's subscription

## SYNTAX

```
Receive-SbMessage [-NameSpace] <String> [-TopicName] <String> [-SubscriptionName] <String>
 [[-BatchSize] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet will receive and delete a message from a given Azure Service Bus Namespace topic's subscription.
By default only the first message will be received, this can however be automatically repeated many more times using the RepeatCount parameter, clearing out a topic in only a few seconds.

## EXAMPLES

### EXAMPLE 1
```
Receive-SbMessage -NameSpace <ServiceBusNameSpaceName> -TopicName <TopicName> -SubscriptionName <SubscriptionName>
```

## PARAMETERS

### -NameSpace
The name of the Service Bus Namespace

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TopicName
The name of the Service Bus Namespace Topic

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubscriptionName
The name of the Service Bus Topic Subscription

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchSize
How many messages should we receive / delete?
Understand this as a batch size.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Output from this cmdlet (if any)
## NOTES
General notes

## RELATED LINKS
