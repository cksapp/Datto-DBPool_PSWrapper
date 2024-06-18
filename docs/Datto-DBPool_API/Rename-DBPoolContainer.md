---
external help file: Datto-DBPool_API-help.xml
Module Name: Datto-DBPool_API
online version:
schema: 2.0.0
---

# Rename-DBPoolContainer

## SYNOPSIS
The Rename-DBPoolContainer function is used to update a container in the DBPool.

## SYNTAX

```
Rename-DBPoolContainer [-Id] <Int32[]> [-Name] <String> [<CommonParameters>]
```

## DESCRIPTION
The Rename-DBPoolContainer function is used to change the name a container in the DBPool API.

## EXAMPLES

### EXAMPLE 1
```
Rename-DBPoolContainer -Id 12345 -Name 'NewContainerName'
```

This will update the container with ID 12345 to have the name 'NewContainerName'

### EXAMPLE 2
```
@( 12345, 56789 ) | Rename-DBPoolContainer -Name 'NewContainerName'
```

This will update the containers with ID 12345, and 56789 to have the name 'NewContainerName'

## PARAMETERS

### -Id
The ID of the container to update.
This accepts an array of integers.

```yaml
Type: System.Int32[]
Parameter Sets: (All)
Aliases: ContainerId

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Name
The new name for the container.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N/A

## RELATED LINKS

[N/A]()

