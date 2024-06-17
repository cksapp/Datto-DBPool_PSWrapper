---
external help file: Datto-DBPool_API-help.xml
Module Name: Datto-DBPool_API
online version:
schema: 2.0.0
---

# Invoke-DBPoolRequest

## SYNOPSIS
Makes an API request to the DBPool

## SYNTAX

```
Invoke-DBPoolRequest [[-method] <String>] [-resource_Uri] <String> [[-data] <Hashtable>]
 [[-DBPool_JSON_Conversion_Depth] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-DBPoolRequest cmdlet invokes an API request to DBPool API

This is an internal function that is used by all public functions

## EXAMPLES

### EXAMPLE 1
```
Invoke-DBPoolRequest -method GET -resource_Uri '/api/v2/self' -uri_Filter $uri_Filter
```

Name                           Value
----                           -----
Method                         GET
Uri                            https://dbpool.datto.net/api/v2/self
Headers                        {X-App-Apikey = 3feb2b29-919c-409c-985d-e99cbae43a6d}
Body

Invoke a rest method against the defined resource using any of the provided parameters

### EXAMPLE 2
```
Invoke-DBPoolRequest -method GET -resource_Uri '/api/openapi.json' -uri_Filter $uri_Filter
```

Name                           Value
----                           -----
Method                         GET
Uri                            https://dbpool.datto.net/api/openapi.json
Headers                        {X-App-Apikey = 3feb2b29-919c-409c-985d-e99cbae43a6d}
Body

Invoke a rest method against the defined resource using any of the provided parameters

## PARAMETERS

### -method
Defines the type of API method to use

Allowed values:
'DEFAULT', 'DELETE', 'GET', 'HEAD', 'PATCH', 'POST', 'PUT'

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: DEFAULT
Accept pipeline input: False
Accept wildcard characters: False
```

### -resource_Uri
Defines the resource uri (url) to use when creating the API call

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -data
Defines the data to be sent with the API request body when using POST or PATCH

```yaml
Type: System.Collections.Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DBPool_JSON_Conversion_Depth
Defines the depth of the JSON conversion for the 'data' parameter request body

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 5
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

