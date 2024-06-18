---
external help file: Datto-DBPool_API-help.xml
Module Name: Datto-DBPool_API
online version:
schema: 2.0.0
---

# Set-DBPoolApiParameters

## SYNOPSIS
The Set-DBPoolApiParameters function is used to set parameters for the Datto DBPool API.

## SYNTAX

```
Set-DBPoolApiParameters [[-base_uri] <Uri>] [-apiKey] <SecureString> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-DBPoolApiParameters function is used to set the API URL and API Key for the Datto DBPool API.

## EXAMPLES

### EXAMPLE 1
```
Set-DBPoolApiParameters
```

Sets the default base URI and prompts for the API Key.

### EXAMPLE 2
```
Set-DBPoolApiParameters -base_uri "https://dbpool.example.com" -apiKey $secureString
```

Sets the base URI to https://dbpool.example.com and sets the API Key.

## PARAMETERS

### -base_uri
Provide the URL of the Datto DBPool API.
The default value is https://dbpool.datto.net.

```yaml
Type: System.Uri
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Https://dbpool.datto.net
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -apiKey
Provide Datto DBPool API Key for authorization.
   You can find your user API key at \[ /web/self \](https://dbpool.datto.net/web/self).

```yaml
Type: System.Security.SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
See Datto DBPool API help files for more information.

## RELATED LINKS

[N/A]()

