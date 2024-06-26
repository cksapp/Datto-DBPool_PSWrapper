---
external help file: Datto-DBPool_API-help.xml
Module Name: Datto-DBPool_API
online version:
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
Type: System.String
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

## OUTPUTS

## NOTES
N/A

## RELATED LINKS

[N/A]()

