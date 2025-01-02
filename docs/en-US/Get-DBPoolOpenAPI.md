---
external help file: Datto.DBPool.API-help.xml
Module Name: Datto.DBPool.API
online version: https://datto-dbpool-api.kentsapp.com/OpenAPI/Get-DBPoolOpenAPI/
schema: 2.0.0
---

# Get-DBPoolOpenAPI

## SYNOPSIS
Gets the DBPool OpenAPI documentation.

## SYNTAX

```
Get-DBPoolOpenAPI [[-OpenAPI_Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets the OpenAPI json spec for the DBPool API documentation.

## EXAMPLES

### EXAMPLE 1
```
Get-DBPoolOpenAPI
```

This will get the OpenAPI json spec for the DBPool API documentation.

## PARAMETERS

### -OpenAPI_Path
The path to the OpenAPI json spec.
This defaults to '/api/docs/openapi.json'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: /api/docs/openapi.json
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### N/A
## OUTPUTS

### [PSCustomObject] - The OpenAPI json spec for the DBPool API documentation.
## NOTES
Equivalent API endpoint:
    - GET /api/docs/openapi.json

## RELATED LINKS

[https://datto-dbpool-api.kentsapp.com/OpenAPI/Get-DBPoolOpenAPI/](https://datto-dbpool-api.kentsapp.com/OpenAPI/Get-DBPoolOpenAPI/)

