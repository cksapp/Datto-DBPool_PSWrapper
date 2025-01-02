---
external help file: Datto.DBPool.API-help.xml
Module Name: Datto.DBPool.API
online version: https://datto-dbpool-api.kentsapp.com/Containers/Remove-DBPoolContainer/
schema: 2.0.0
---

# Remove-DBPoolContainer

## SYNOPSIS
The Remove-DBPoolContainer function is used to delete a container in the DBPool.

## SYNTAX

```
Remove-DBPoolContainer [-Id] <Int32[]> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-DBPoolContainer function is used to delete containers in the DBPool based on the provided container ID.

!!
This is a destructive operation and will destory the container !!

## EXAMPLES

### EXAMPLE 1
```
Remove-DBPoolContainer -Id '12345'
```

This will delete the provided container by ID.

### EXAMPLE 2
```
@( 12345, 56789 ) | Remove-DBPoolContainer -Confirm:$false
```

This will delete the containers with ID 12345, and 56789.

## PARAMETERS

### -Id
The ID of the container to delete.
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

### -Force
Forces the removal of the container without prompting for confirmation.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [int] - The ID of the container to delete.
## OUTPUTS

### [void] - No output is returned.
## NOTES
Equivalent API endpoint:
    - DELETE /api/v2/containers/{id}

## RELATED LINKS

[https://datto-dbpool-api.kentsapp.com/Containers/Remove-DBPoolContainer/](https://datto-dbpool-api.kentsapp.com/Containers/Remove-DBPoolContainer/)

