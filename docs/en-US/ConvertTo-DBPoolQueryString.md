---
external help file: Datto.DBPool.API-help.xml
Module Name: Datto.DBPool.API
online version:
schema: 2.0.0
---

# ConvertTo-DBPoolQueryString

## SYNOPSIS
Converts uri filter parameters

As of June 2024, DBPool does not support any query parameters.
This is only provided to allow forward compatibility

## SYNTAX

```
ConvertTo-DBPoolQueryString [[-uri_Filter] <Hashtable>] [-resource_Uri] <String> [<CommonParameters>]
```

## DESCRIPTION
The ConvertTo-DBPoolQueryString cmdlet converts & formats uri filter parameters
from a function which are later used to make the full resource uri for
an API call

This is an internal helper function the ties in directly with the
Invoke-DBPoolRequest & any public functions that define parameters

As of June 2024, DBPool does not support any query parameters.
This is only provided to allow forward compatibility

## EXAMPLES

### EXAMPLE 1
```
ConvertTo-DBPoolQueryString -uri_Filter $uri_Filter -resource_Uri '/api/v2/containers'
```

Example: (From public function)
    $uri_Filter = @{}

    ForEach ( $Key in $PSBoundParameters.GetEnumerator() ){
        if( $excludedParameters -contains $Key.Key ){$null}
        else{ $uri_Filter += @{ $Key.Key = $Key.Value } }
    }

    1x key = https://api.DBPool.com/v1/api/v2/containers?parentId=12345
    2x key = https://api.DBPool.com/v1/api/v2/containers?parentId=12345&power=True

## PARAMETERS

### -uri_Filter
Hashtable of values to combine a functions parameters with
the resource_Uri parameter.

This allows for the full uri query to occur

As of June 2024, DBPool does not support any query parameters.
This is only provided to allow forward compatibility

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -resource_Uri
Defines the short resource uri (url) to use when creating the API call

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [hashtable] - uri_Filter
## OUTPUTS

### [System.UriBuilder] - uri_Request
## NOTES
N/A

## RELATED LINKS

[N/A]()

