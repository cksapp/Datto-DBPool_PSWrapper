---
external help file: Datto.DBPool.API-help.xml
Module Name: Datto.DBPool.API
online version:
schema: 2.0.0
---

# Invoke-DBPoolContainerAccess

## SYNOPSIS
The Invoke-DBPoolContainerAccess function is used to interact with various container access operations in the Datto DBPool API.

## SYNTAX

### GetAccess (Default)
```
Invoke-DBPoolContainerAccess [-Id] <Int32[]> [-Username] <String[]> [-GetAccess] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### RemoveAccess
```
Invoke-DBPoolContainerAccess [-Id] <Int32[]> [-Username] <String[]> [-RemoveAccess] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### AddAccess
```
Invoke-DBPoolContainerAccess [-Id] <Int32[]> [-Username] <String[]> [-AddAccess] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Invoke-DBPoolContainerAccess function is used to Get, Add, or Remove access to a container in the Datto DBPool API based on a given username.

## EXAMPLES

### EXAMPLE 1
```
Invoke-DBPoolContainerAccess -Id '12345' -Username 'John.Doe'
Invoke-DBPoolContainerAccess -Id '12345' -Username 'John.Doe' -GetAccess
```

This will get access to the container with ID 12345 for the user "John.Doe"

### EXAMPLE 2
```
Invoke-DBPoolContainerAccess -Id @( '12345', '56789' ) -Username 'John.Doe' -AddAccess
```

This will add access to the containers with ID 12345, and 56789 for the user "John.Doe"

### EXAMPLE 3
```
Invoke-DBPoolContainerAccess -Id '12345' -Username @( 'Jane.Doe', 'John.Doe' ) -RemoveAccess
```

This will remove access to the container with ID 12345 for the users "Jane.Doe", and "John.Doe"

## PARAMETERS

### -Id
The ID of the container to access.
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

### -Username
The username to access the container.
This accepts an array of strings.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -GetAccess
Gets the current access to a container by ID for the given username.

```yaml
Type: SwitchParameter
Parameter Sets: GetAccess
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AddAccess
Adds access to a container by ID for the given username.

```yaml
Type: SwitchParameter
Parameter Sets: AddAccess
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemoveAccess
Removes access to a container by ID for the given username.

```yaml
Type: SwitchParameter
Parameter Sets: RemoveAccess
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

### [int] - The ID of the container to access.
### [string] - The username to access the container.
## OUTPUTS

### [PSCustomObject] - The response from the DBPool API.
### [void] - No output is returned.
## NOTES
N/A

## RELATED LINKS

[N/A]()

