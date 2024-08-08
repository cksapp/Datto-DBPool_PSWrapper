---
external help file: Datto-DBPool_API-help.xml
Module Name: Datto-DBPool_API
online version:
schema: 2.0.0
---

# New-DBPoolContainer

## SYNOPSIS
The New-DBPoolContainer function is used to create a new container from the DBPool API.

## SYNTAX

```
New-DBPoolContainer [-ContainerName] <String> [-ParentId <Int32>] [-ParentName <String>]
 [-ParentDefaultDatabase <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-DBPoolContainer function is used to create a new container in the DBPool based on the provided container name and parent container information.

This requires a container name and at least one at least one of the parent* fields must be specified.
If multiple parent fields are specified, both conditions will have to match a parent for it to be selected.

## EXAMPLES

### EXAMPLE 1
```
New-DBPoolContainer -ContainerName 'MyNewContainer' -ParentId 12345
```

This will create a new container named 'MyNewContainer' based on the parent container with ID 12345.

### EXAMPLE 2
```
Get-DBPoolContainer -ParentContainer -Id 1 | New-DBPoolContainer -ContainerName 'MyNewContainer'
```

This will create a new container named 'MyNewContainer' based on the piped in parent container.

## PARAMETERS

### -ContainerName
The name for the container to create.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ParentId
The ID of the parent container to clone.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: Id

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ParentName
The name of the parent container to clone.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ParentDefaultDatabase
The default database of the parent container to clone.

```yaml
Type: String
Parameter Sets: (All)
Aliases: DefaultDatabase

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

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

