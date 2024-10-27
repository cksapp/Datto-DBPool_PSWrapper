function ConvertTo-DBPoolQueryString {
<#
    .SYNOPSIS
        Converts uri filter parameters

        As of June 2024, DBPool does not support any query parameters.
        This is only provided to allow forward compatibility

    .DESCRIPTION
        The ConvertTo-DBPoolQueryString cmdlet converts & formats uri filter parameters
        from a function which are later used to make the full resource uri for
        an API call

        This is an internal helper function the ties in directly with the
        Invoke-DBPoolRequest & any public functions that define parameters

        As of June 2024, DBPool does not support any query parameters.
        This is only provided to allow forward compatibility

    .PARAMETER uri_Filter
        Hashtable of values to combine a functions parameters with
        the resource_Uri parameter.

        This allows for the full uri query to occur

        As of June 2024, DBPool does not support any query parameters.
        This is only provided to allow forward compatibility

    .PARAMETER resource_Uri
        Defines the short resource uri (url) to use when creating the API call

    .INPUTS
        [hashtable] - uri_Filter

    .OUTPUTS
        [System.UriBuilder] - uri_Request

    .EXAMPLE
        ConvertTo-DBPoolQueryString -uri_Filter $uri_Filter -resource_Uri '/api/v2/containers'

        Example: (From public function)
            $uri_Filter = @{}

            ForEach ( $Key in $PSBoundParameters.GetEnumerator() ){
                if( $excludedParameters -contains $Key.Key ){$null}
                else{ $uri_Filter += @{ $Key.Key = $Key.Value } }
            }

            1x key = https://api.DBPool.com/v1/api/v2/containers?parentId=12345
            2x key = https://api.DBPool.com/v1/api/v2/containers?parentId=12345&power=True

    .NOTES
        N/A

    .LINK
        N/A

#>

    [CmdletBinding()]
    [OutputType([System.UriBuilder])]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [hashtable]$uri_Filter,

        [Parameter(Mandatory = $true)]
        [String]$resource_Uri
    )

    begin {}

    process {

        $excludedParameters = 'Debug', 'ErrorAction', 'ErrorVariable', 'InformationAction', 'InformationVariable',
        'OutBuffer', 'OutVariable', 'PipelineVariable', 'Verbose', 'WarningAction', 'WarningVariable',
        'allPages', 'page', 'perPage'

        $query_Parameters = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)

        if ($uri_Filter) {
            ForEach ( $Key in $uri_Filter.GetEnumerator() ) {

                if ( $excludedParameters -contains $Key.Key ){$null} 
                elseif ( $Key.Value.GetType().IsArray ) {
                    Write-Verbose "[ $($Key.Key) ] is an array parameter"
                    foreach ($Value in $Key.Value) {
                        $query_Parameters.Add($Key.Key, $Value)
                    }
                } else {
                    $query_Parameters.Add($Key.Key, $Key.Value)
                }

            }
        }

        # Build the request and load it with the query string.
        $uri_Request = [System.UriBuilder]($DBPool_Base_URI + $resource_Uri)
        $uri_Request.Query = $query_Parameters.ToString()

        # Return the full uri
        $uri_Request

    }

    end {}

}