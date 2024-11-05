---
external help file: Datto-DBPool_API-help.xml
Module Name: Datto-DBPool_API
online version:
schema: 2.0.0
---

# Import-DBPoolModuleSetting

## SYNOPSIS
Imports the DBPool BaseURI, API Key, & JSON configuration information to the current session.

## SYNTAX

```
Import-DBPoolModuleSetting [-DBPoolConfPath <String>] [-DBPoolConfFile <String>] [<CommonParameters>]
```

## DESCRIPTION
The Import-DBPoolModuleSetting cmdlet imports the DBPool BaseURI, API Key, & JSON configuration
information stored in the DBPool configuration file to the users current session.

By default the configuration file is stored in the following location:
    $env:USERPROFILE\DBPoolAPI

## EXAMPLES

### EXAMPLE 1
```
Import-DBPoolModuleSetting
```

Validates that the configuration file created with the Export-DBPoolModuleSetting cmdlet exists
then imports the stored data into the current users session.

The default location of the DBPool configuration file is:
    $env:USERPROFILE\DBPoolAPI\config.psd1

### EXAMPLE 2
```
Import-DBPoolModuleSetting -DBPoolConfPath C:\DBPoolAPI -DBPoolConfFile MyConfig.psd1
```

Validates that the configuration file created with the Export-DBPoolModuleSetting cmdlet exists
then imports the stored data into the current users session.

The location of the DBPool configuration file in this example is:
    C:\DBPoolAPI\MyConfig.psd1

## PARAMETERS

### -DBPoolConfPath
Define the location to store the DBPool configuration file.

By default the configuration file is stored in the following location:
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

### -DBPoolConfFile
Define the name of the DBPool configuration file.

By default the configuration file is named:
    config.psd1

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Config.psd1
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### N/A
## OUTPUTS

### N/A
## NOTES
N/A

## RELATED LINKS

[N/A]()

