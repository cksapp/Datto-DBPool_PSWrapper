---
external help file: Datto.DBPool.API-help.xml
Module Name: Datto.DBPool.API
online version: https://datto-dbpool-api.kentsapp.com/Containers/Rename-DBPoolContainer/
schema: 2.0.0
---

# Rename-DBPoolContainer

## SYNOPSIS

The Rename-DBPoolContainer function is used to update a container in the DBPool.

## SYNTAX

```PowerShell
Rename-DBPoolContainer [-Id] <Int32[]> [-Name] <String> [<CommonParameters>]
```

## DESCRIPTION

The Rename-DBPoolContainer function is used to change the name a container in the DBPool API.

## EXAMPLES

### EXAMPLE 1

```PowerShell
Rename-DBPoolContainer -Id 12345 -Name 'NewContainerName'
```

This will update the container with ID 12345 to have the name 'NewContainerName'

### EXAMPLE 2

```PowerShell
@( 12345, 56789 ) | Rename-DBPoolContainer -Name 'NewContainerName'
```

This will update the containers with ID 12345, and 56789 to have the name 'NewContainerName'

## PARAMETERS

### -Id

The ID of the container to update.
This accepts an array of integers.

```yaml
Type: Int32[]
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
Type: String
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

### [int] - The ID of the container to update

### [string] - The new name for the container

## OUTPUTS

### [PSCustomObject] - The response from the DBPool API

## NOTES

Equivalent API endpoint:

- PATCH `/api/v2/containers/{id}`

## RELATED LINKS

[https://datto-dbpool-api.kentsapp.com/Containers/Rename-DBPoolContainer/](https://datto-dbpool-api.kentsapp.com/Containers/Rename-DBPoolContainer/)
