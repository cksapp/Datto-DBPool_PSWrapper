---
external help file: Datto-DBPool_API-help.xml
Module Name: Datto-DBPool_API
online version:
schema: 2.0.0
---

# Remove-DBPoolContainer

## SYNOPSIS
The Remove-DBPoolContainer function is used to delete a container in the DBPool.

## SYNTAX

```
Remove-DBPoolContainer [-Id] <Int32[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-DBPoolContainer function is used to delete containers in the DBPool based on the provided container ID.
This is a destructive operation and will destory the container.

## EXAMPLES

### EXAMPLE 1
```
Remove-DBPoolContainer -Id '12345'
```

@( 12345, 98765 ) | Remove-DBPoolContainer -Confirm:$false

This will delete the provided containers by ID.

## PARAMETERS

### -Id
The ID of the container to delete.
This accepts an array of integers.

```yaml
Type: System.Int32[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: System.Management.Automation.SwitchParameter
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
Type: System.Management.Automation.SwitchParameter
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

## OUTPUTS

## NOTES
N/A

## RELATED LINKS

[N/A]()

