---
external help file: Datto-DBPool_API-help.xml
Module Name: Datto-DBPool_API
online version:
schema: 2.0.0
---

# Add-DBPoolApiKey

## SYNOPSIS
Sets the API key for the DBPool.

## SYNTAX

```
Add-DBPoolApiKey [-apiKey] <SecureString> [<CommonParameters>]
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
```

Read-Host "Enter your DBPool API Key" -AsSecureString | Add-DBPoolApiKey

Sets the API key for the DBPool.

## PARAMETERS

### -apiKey
Defines your API key for the DBPool.

```yaml
Type: System.Security.SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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

