---
external help file: Datto.DBPool.API-help.xml
Module Name: Datto.DBPool.API
online version: https://datto-dbpool-api.kentsapp.com/Debug/Invoke-DBPoolDebug/
schema: 2.0.0
---

# Invoke-DBPoolDebug

## SYNOPSIS
Provides an example exception response from the DBPool API for debugging purposes.

## SYNTAX

```
Invoke-DBPoolDebug [[-method] <String>] [<CommonParameters>]
```

## DESCRIPTION
Uses the Invoke-DBPoolRequest function to make a request to the DBPool API.
Returns an example exception response for debugging and testing purposes.

## EXAMPLES

### EXAMPLE 1
```
Invoke-DBPoolDebug -method GET
```

Sends a 'GET' request to the DBPool API and returns a '418' exception response error.

## PARAMETERS

### -method
The HTTP method to use when making the request to the DBPool API.
Default is 'GET'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: GET
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### N/A
## OUTPUTS

### [System.Management.Automation.ErrorRecord] - Returns an example exception response from the DBPool API.
## NOTES
Equivalent API endpoint:
    - GET /api/docs/error
    - PATCH /api/docs/error
    - POST /api/docs/error
    - PUT /api/docs/error
    - DELETE /api/docs/error

## RELATED LINKS

[https://datto-dbpool-api.kentsapp.com/Debug/Invoke-DBPoolDebug/](https://datto-dbpool-api.kentsapp.com/Debug/Invoke-DBPoolDebug/)

