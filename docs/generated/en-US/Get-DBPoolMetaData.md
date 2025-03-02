---
external help file: Datto.DBPool.API-help.xml
Module Name: Datto.DBPool.API
online version: https://datto-dbpool-api.kentsapp.com/Internal/apiCalls/Get-DBPoolMetaData/
schema: 2.0.0
---

# Get-DBPoolMetaData

## SYNOPSIS
Gets various API metadata values

## SYNTAX

```
Get-DBPoolMetaData [[-base_uri] <String>] [[-resource_uri] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Get-DBPoolMetaData cmdlet gets various API metadata values from an
Invoke-WebRequest to assist in various troubleshooting scenarios such
as rate-limiting.

## EXAMPLES

### EXAMPLE 1
```
Get-DBPoolMetaData
```

Gets various API metadata values from an Invoke-WebRequest to assist
in various troubleshooting scenarios such as rate-limiting.

The default full base uri test path is:
    https://dbpool.datto.net

### EXAMPLE 2
```
Get-DBPoolMetaData -base_uri http://dbpool.example.com
```

Gets various API metadata values from an Invoke-WebRequest to assist
in various troubleshooting scenarios such as rate-limiting.

The full base uri test path in this example is:
    http://dbpool.example.com/api/v2/self

## PARAMETERS

### -base_uri
Define the base URI for the DBPool API connection using Datto's DBPool URI or a custom URI.

The default base URI is https://dbpool.datto.net

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $DBPool_Base_URI
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -resource_uri
Define the resource URI for the DBPool API connection.

The default resource URI is /api/v2/self

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: /api/v2/self
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [string] - base_uri
## OUTPUTS

### [PSCustomObject] - Various API metadata values
## NOTES
N/A

## RELATED LINKS

[https://datto-dbpool-api.kentsapp.com/Internal/apiCalls/Get-DBPoolMetaData/](https://datto-dbpool-api.kentsapp.com/Internal/apiCalls/Get-DBPoolMetaData/)

