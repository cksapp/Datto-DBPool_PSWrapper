---
external help file: Datto.DBPool.API-help.xml
Module Name: Datto.DBPool.API
online version: https://datto-dbpool-api.kentsapp.com/Internal/Set-DBPoolApiParameter/
schema: 2.0.0
---

# Set-DBPoolApiParameter

## SYNOPSIS

The Set-DBPoolApiParameter function is used to set parameters for the Datto DBPool API.

## SYNTAX

```PowerShell
Set-DBPoolApiParameter [[-base_uri] <Uri>] [-apiKey] <SecureString> [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

The Set-DBPoolApiParameter function is used to set the API URL and API Key for the Datto DBPool API.

## EXAMPLES

### EXAMPLE 1

```PowerShell
Set-DBPoolApiParameter
```

Sets the default base URI and prompts for the API Key.

### EXAMPLE 2

```PowerShell
Set-DBPoolApiParameter -base_uri "https://dbpool.example.com" -apiKey $secureString
```

Sets the base URI to [https://dbpool.example.com](https://dbpool.example.com) and sets the API Key.

## PARAMETERS

### -base_uri

Provide the URL of the Datto DBPool API.
The default value is [https://dbpool.datto.net](https://dbpool.datto.net).

```yaml
Type: Uri
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
You can find your user API key at [/web/self](https://dbpool.datto.net/web/self).

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Force

Force the operation without confirmation.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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

### [Uri] - The base URL of the DBPool API

### [SecureString] - The API key for the DBPool

## OUTPUTS

### [void] - No output is returned

## NOTES

See Datto DBPool API help files for more information.

## RELATED LINKS

[https://datto-dbpool-api.kentsapp.com/Internal/Set-DBPoolApiParameter/](https://datto-dbpool-api.kentsapp.com/Internal/Set-DBPoolApiParameter/)
