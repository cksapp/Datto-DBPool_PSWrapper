---
external help file: Datto.DBPool.API-help.xml
Module Name: Datto.DBPool.API
online version:
schema: 2.0.0
---

# Add-DBPoolApiKey

## SYNOPSIS
Sets the API key for the DBPool.

## SYNTAX

```
Add-DBPoolApiKey [-apiKey] <SecureString> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Add-DBPoolApiKey cmdlet sets the API key which is used to authenticate API calls made to DBPool.

Once the API key is defined, the secret key is encrypted using SecureString.

The DBPool API key is retrieved via the DBPool UI at My Profile -\> API key

## EXAMPLES

### EXAMPLE 1
```
Add-DBPoolApiKey
```

Prompts to enter in your personal API key.

### EXAMPLE 2
```
Add-DBPoolApiKey -ApiKey $secureString
Read-Host "Enter your DBPool API Key" -AsSecureString | Add-DBPoolApiKey
```

Sets the API key for the DBPool.

## PARAMETERS

### -apiKey
Defines your API key for the DBPool.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Force
Forces the setting of the DBPool API key.

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
Shows what would happen if the cmdlet runs. The cmdlet is not run.

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

### [SecureString] - The API key for the DBPool.
## OUTPUTS

### [void] - No output is returned.
## NOTES
N/A

## RELATED LINKS

[N/A]()

