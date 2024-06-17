---
external help file: Datto-DBPool_API-help.xml
Module Name: Datto-DBPool_API
online version:
schema: 2.0.0
---

# Test-DBPoolApiKey

## SYNOPSIS
Test the DBPool API key.

## SYNTAX

```
Test-DBPoolApiKey [[-base_uri] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Test-DBPoolApiKey cmdlet tests the base URI & API key that were defined in the
Add-DBPoolBaseURI & Add-DBPoolAPIKey cmdlets.

## EXAMPLES

### EXAMPLE 1
```
Test-DBPoolBaseURI
```

Tests the base URI & API key that was defined in the
Add-DBPoolBaseURI & Add-DBPoolAPIKey cmdlets.

The default full base uri test path is:
    https://dbpool.datto.net/api/v2/self

### EXAMPLE 2
```
Test-DBPoolBaseURI -base_uri http://dbpool.example.com
```

Tests the base URI & API key that was defined in the
Add-DBPoolBaseURI & Add-DBPoolAPIKey cmdlets.

The full base uri test path in this example is:
    http://dbpool.example.com/api/v2/self

## PARAMETERS

### -base_uri
Define the base URI for the DBPool API connection using Datto's DBPool URI or a custom URI.

The default base URI is https://dbpool.datto.net/api

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $DBPool_Base_URI
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

