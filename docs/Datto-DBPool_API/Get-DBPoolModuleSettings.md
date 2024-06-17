---
external help file: Datto-DBPool_API-help.xml
Module Name: Datto-DBPool_API
online version:
schema: 2.0.0
---

# Get-DBPoolModuleSettings

## SYNOPSIS
Gets the saved DBPool configuration settings

## SYNTAX

### index (Default)
```
Get-DBPoolModuleSettings [-DBPoolConfPath <String>] [-DBPoolConfFile <String>] [<CommonParameters>]
```

### show
```
Get-DBPoolModuleSettings [-openConfFile] [<CommonParameters>]
```

## DESCRIPTION
The Get-DBPoolModuleSettings cmdlet gets the saved DBPool configuration settings
from the local system.

By default the configuration file is stored in the following location:
    $env:USERPROFILE\DBPoolAPI

## EXAMPLES

### EXAMPLE 1
```
Get-DBPoolModuleSettings
```

Gets the contents of the configuration file that was created with the
Export-DBPoolModuleSettings

The default location of the DBPool configuration file is:
    $env:USERPROFILE\DBPoolAPI\config.psd1

### EXAMPLE 2
```
Get-DBPoolModuleSettings -DBPoolConfPath C:\DBPoolAPI -DBPoolConfFile MyConfig.psd1 -openConfFile
```

Opens the configuration file from the defined location in the default editor

The location of the DBPool configuration file in this example is:
    C:\DBPoolAPI\MyConfig.psd1

## PARAMETERS

### -DBPoolConfPath
Define the location to store the DBPool configuration file.

By default the configuration file is stored in the following location:
    $env:USERPROFILE\DBPoolAPI

```yaml
Type: System.String
Parameter Sets: index
Aliases:

Required: False
Position: Named
Default value: $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"DBPoolAPI"}else{".DBPoolAPI"}) )
Accept pipeline input: False
Accept wildcard characters: False
```

### -DBPoolConfFile
Define the name of the DBPool configuration file.

By default the configuration file is named:
    config.psd1

```yaml
Type: System.String
Parameter Sets: index
Aliases:

Required: False
Position: Named
Default value: Config.psd1
Accept pipeline input: False
Accept wildcard characters: False
```

### -openConfFile
Opens the DBPool configuration file

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: show
Aliases:

Required: False
Position: Named
Default value: False
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

