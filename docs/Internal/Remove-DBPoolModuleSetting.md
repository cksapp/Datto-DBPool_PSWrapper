---
external help file: Datto-DBPool_API-help.xml
Module Name: Datto-DBPool_API
online version:
schema: 2.0.0
---

# Remove-DBPoolModuleSetting

## SYNOPSIS
Removes the stored DBPool configuration folder.

## SYNTAX

```
Remove-DBPoolModuleSetting [-DBPoolConfPath <String>] [-andVariables] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-DBPoolModuleSetting cmdlet removes the DBPool folder and its files.
This cmdlet also has the option to remove sensitive DBPool variables as well.

By default configuration files are stored in the following location and will be removed:
    $env:USERPROFILE\DBPoolAPI

## EXAMPLES

### EXAMPLE 1
```
Remove-DBPoolModuleSetting
```

Checks to see if the default configuration folder exists and removes it if it does.

The default location of the DBPool configuration folder is:
    $env:USERPROFILE\DBPoolAPI

### EXAMPLE 2
```
Remove-DBPoolModuleSetting -DBPoolConfPath C:\DBPoolAPI -andVariables
```

Checks to see if the defined configuration folder exists and removes it if it does.
If sensitive DBPool variables exist then they are removed as well.

The location of the DBPool configuration folder in this example is:
    C:\DBPoolAPI

## PARAMETERS

### -DBPoolConfPath
Define the location of the DBPool configuration folder.

By default the configuration folder is located at:
    $env:USERPROFILE\DBPoolAPI

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"DBPoolAPI"}else{".DBPoolAPI"}) )
Accept pipeline input: False
Accept wildcard characters: False
```

### -andVariables
Define if sensitive DBPool variables should be removed as well.

By default the variables are not removed.

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

### N/A
## OUTPUTS

### [void] - No output is returned.
## NOTES
N/A

## RELATED LINKS

[N/A]()

