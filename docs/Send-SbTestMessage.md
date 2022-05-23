---
external help file: AzureServiceBusManagement-help.xml
Module Name: AzureServiceBusManagement
online version:
schema: 2.0.0
---

# Send-SbTestMessage

## SYNOPSIS
Send a message to Azure Service Bus topic

## SYNTAX

```
Send-SbTestMessage [-NameSpace] <String> [-TopicName] <String> [[-message] <String>] [[-BatchSize] <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
This cmdlet will send a message to a given Azure Service Bus Namespace topic.

## EXAMPLES

### EXAMPLE 1
```
Send-SbTestMessage -NameSpace <ServiceBusNameSpaceName> -TopicName <TopicName>
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

### -message
Message that should be put onto the Service Bus Topic.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchSize
How many messages should we send?
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
