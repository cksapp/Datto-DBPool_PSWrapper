---
external help file: Datto-DBPool_API-help.xml
Module Name: Datto-DBPool_API
online version:
schema: 2.0.0
---

# Export-DBPoolModuleSetting

## SYNOPSIS
Exports the DBPool BaseURI, API Key, & JSON configuration information to file.

## SYNTAX

```
Export-DBPoolModuleSetting [-DBPoolConfPath <String>] [-DBPoolConfFile <String>] [<CommonParameters>]
```

## DESCRIPTION
The Export-DBPoolModuleSetting cmdlet exports the DBPool BaseURI, API Key, & JSON configuration information to file.

Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
that can only be unencrypted with the your Windows account as this encryption is tied to your user principal.
This means that you cannot copy your configuration file to another computer or user account and expect it to work.

## EXAMPLES

### EXAMPLE 1
```
Export-DBPoolModuleSetting
```

Validates that the BaseURI, API Key, and JSON depth are set then exports their values
to the current user's DBPool configuration file located at:
    $env:USERPROFILE\DBPoolAPI\config.psd1

### EXAMPLE 2
```
Export-DBPoolModuleSetting -DBPoolConfPath C:\DBPoolAPI -DBPoolConfFile MyConfig.psd1
```

Validates that the BaseURI, API Key, and JSON depth are set then exports their values
to the current user's DBPool configuration file located at:
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

### [void] - No output is returned.
## NOTES
N/A

## RELATED LINKS

[N/A]()

