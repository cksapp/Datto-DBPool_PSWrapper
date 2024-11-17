---
external help file: Datto.DBPool.API-help.xml
Module Name: Datto.DBPool.API
online version:
schema: 2.0.0
---

# Test-DBPoolApi

## SYNOPSIS
Checks the availability of the DBPool API using an HTTP HEAD request.

## SYNTAX

```
Test-DBPoolApi [[-base_uri] <String>] [[-resource_Uri] <String>] [[-apiKey] <SecureString>]
 [<CommonParameters>]
```

## DESCRIPTION
This function sends an HTTP HEAD request to the specified API URL using Invoke-WebRequest.
Checks if the HTTP status code is 200, indicating that the API is available.

## EXAMPLES

### EXAMPLE 1
```
Test-DBPoolApi -base_uri "https://api.example.com"
```

Checks the availability of the API at https://api.example.com

## PARAMETERS

### -base_uri
The base URL of the API to be checked.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $DBPool_Base_URI
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -resource_Uri
The URI of the API resource to be checked.

The default value is '/api/docs/openapi.json'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: /api/docs/openapi.json
Accept pipeline input: False
Accept wildcard characters: False
```

### -apiKey
Optional: Access token for authorization.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $DBPool_ApiKey
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [string] - The base URI for the DBPool API connection.
### [SecureString] - The API key for the DBPool.
## OUTPUTS

### [System.Boolean] - Returns $true if the API is available, $false if not.
## NOTES

## RELATED LINKS
