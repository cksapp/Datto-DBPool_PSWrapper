---
external help file: Datto.DBPool.API-help.xml
Module Name: Datto.DBPool.API
online version: https://datto-dbpool-api.kentsapp.com/Internal/apiCalls/Invoke-DBPoolRequest/
schema: 2.0.0
---

# Invoke-DBPoolRequest

## SYNOPSIS
Internal function to make an API request to the DBPool API

## SYNTAX

```
Invoke-DBPoolRequest [[-method] <String>] [-resource_Uri] <String> [[-uri_Filter] <Hashtable>]
 [[-data] <Hashtable>] [[-jsonDepth] <Int32>] [-allPages] [<CommonParameters>]
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

Invoke an API request against the defined resource using any of the provided parameters

### EXAMPLE 2
```
Invoke-DBPoolRequest -method GET -resource_Uri '/api/openapi.json' -uri_Filter $uri_Filter
Name                           Value
----                           -----
Method                         GET
Uri                            https://dbpool.datto.net/api/openapi.json
Headers                        {X-App-Apikey = 3feb2b29-919c-409c-985d-e99cbae43a6d}
Body
```

Invoke an API request against the defined resource using any of the provided parameters

## PARAMETERS

### -method
Defines the type of API method to use

Allowed values:
'DEFAULT', 'DELETE', 'GET', 'HEAD', 'PATCH', 'POST', 'PUT'

```yaml
Type: String
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
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -uri_Filter
Used with the internal function 'ConvertTo-DBPoolQueryString' to combine
a functions parameters with the resource_Uri parameter.

This allows for the full uri query to occur

The full resource path is made with the following data
$DBPool_Base_URI + $resource_Uri + ConvertTo-DBPoolQueryString

As of June 2024, DBPool does not support any query parameters.
This is only provided to allow forward compatibility

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -data
Defines the data to be sent with the API request body when using POST or PATCH

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -jsonDepth
Defines the depth of the JSON conversion for the 'data' parameter request body

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: $DBPool_JSON_Conversion_Depth
Accept pipeline input: False
Accept wildcard characters: False
```

### -allPages
Returns all items from an endpoint

When using this parameter there is no need to use either the page or perPage
parameters

As of June 2024, DBPool does not support any paging parameters.
This is only provided to allow forward compatibility

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### N/A
## OUTPUTS

### [Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject] - The response from the DBPool API
## NOTES
N/A

## RELATED LINKS

[https://datto-dbpool-api.kentsapp.com/Internal/apiCalls/Invoke-DBPoolRequest/](https://datto-dbpool-api.kentsapp.com/Internal/apiCalls/Invoke-DBPoolRequest/)

