---
external help file: Datto.DBPool.API-help.xml
Module Name: Datto.DBPool.API
online version: https://datto-dbpool-api.kentsapp.com/Internal/baseUri/Add-DBPoolBaseURI/
schema: 2.0.0
---

# Add-DBPoolBaseURI

## SYNOPSIS
Sets the base URI for the DBPool API connection.

## SYNTAX

```
Add-DBPoolBaseURI [[-base_uri] <String>] [[-instance] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Add-DBPoolBaseURI cmdlet sets the base URI which is later used
to construct the full URI for all API calls.

## EXAMPLES

### EXAMPLE 1
```
Add-DBPoolBaseURI
```

The base URI will use https://dbpool.datto.net which is Datto's default DBPool URI.

### EXAMPLE 2
```
Add-DBPoolBaseURI -instance Datto
```

The base URI will use https://dbpool.datto.net which is DBPool's default URI.

### EXAMPLE 3
```
Add-DBPoolBaseURI -base_uri http://dbpool.example.com
```

A custom API gateway of http://dbpool.example.com will be used for all API calls to DBPool's API.

## PARAMETERS

### -base_uri
Define the base URI for the DBPool API connection using Datto's DBPool URI or a custom URI.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Https://dbpool.datto.net
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -instance
DBPool's URI connection point that can be one of the predefined data centers.

The accepted values for this parameter are:
\[ DEFAULT \]
    DEFAULT = https://dbpool.datto.net

Placeholder for other data centers.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [string] - The base URI for the DBPool API connection.
## OUTPUTS

### [void] - No output is returned.
## NOTES
N/A

## RELATED LINKS

[https://datto-dbpool-api.kentsapp.com/Internal/baseUri/Add-DBPoolBaseURI/](https://datto-dbpool-api.kentsapp.com/Internal/baseUri/Add-DBPoolBaseURI/)

