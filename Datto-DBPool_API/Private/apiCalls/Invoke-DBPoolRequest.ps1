function Invoke-DBPoolRequest {
<#
    .SYNOPSIS
        Internal function to make an API request to the DBPool API

    .DESCRIPTION
        The Invoke-DBPoolRequest cmdlet invokes an API request to DBPool API

        This is an internal function that is used by all public functions

    .PARAMETER method
        Defines the type of API method to use

        Allowed values:
        'DEFAULT', 'DELETE', 'GET', 'HEAD', 'PATCH', 'POST', 'PUT'

    .PARAMETER resource_Uri
        Defines the resource uri (url) to use when creating the API call

    .PARAMETER uri_Filter
        Used with the internal function [ ConvertTo-DBPoolQueryString ] to combine
        a functions parameters with the resource_Uri parameter.

        This allows for the full uri query to occur

        The full resource path is made with the following data
        $DBPool_Base_URI + $resource_Uri + ConvertTo-DBPoolQueryString

        As of June 2024, DBPool does not support any query parameters.
        This is only provided to allow forward compatibility

    .PARAMETER data
        Defines the data to be sent with the API request body when using POST or PATCH

    .PARAMETER DBPool_JSON_Conversion_Depth
        Defines the depth of the JSON conversion for the 'data' parameter request body

    .PARAMETER allPages
        Returns all items from an endpoint

        When using this parameter there is no need to use either the page or perPage
        parameters

        As of June 2024, DBPool does not support any paging parameters.
        This is only provided to allow forward compatibility

    .INPUTS
        N/A

    .OUTPUTS
        [Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject] - The response from the DBPool API

    .EXAMPLE
        Invoke-DBPoolRequest -method GET -resource_Uri '/api/v2/self' -uri_Filter $uri_Filter

        Name                           Value
        ----                           -----
        Method                         GET
        Uri                            https://dbpool.datto.net/api/v2/self
        Headers                        {X-App-Apikey = 3feb2b29-919c-409c-985d-e99cbae43a6d}
        Body

        Invoke an API request against the defined resource using any of the provided parameters

    .EXAMPLE
        Invoke-DBPoolRequest -method GET -resource_Uri '/api/openapi.json' -uri_Filter $uri_Filter
        Name                           Value
        ----                           -----
        Method                         GET
        Uri                            https://dbpool.datto.net/api/openapi.json
        Headers                        {X-App-Apikey = 3feb2b29-919c-409c-985d-e99cbae43a6d}
        Body

        Invoke an API request against the defined resource using any of the provided parameters

    .NOTES
        N/A

    .LINK
        N/A

#>

    [CmdletBinding()]
    [OutputType([Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject])]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateSet('DEFAULT', 'DELETE', 'GET', 'HEAD', 'PATCH', 'POST', 'PUT')]
        [String]$method = 'DEFAULT',

        [Parameter(Mandatory = $true)]
        [String]$resource_Uri,

        [Parameter(DontShow = $true, Mandatory = $false)]
        [Hashtable]$uri_Filter = $null,

        [Parameter(Mandatory = $false)]
        [Hashtable]$data = $null,

        [Parameter(Mandatory = $false)]
        #[ValidateRange(0, [int]::MaxValue)]
        [int]$DBPool_JSON_Conversion_Depth = 5,

        [Parameter(DontShow = $true, Mandatory = $false)]
        [Switch]$allPages

    )

    begin {
        $ConfirmPreference = 'None'
    }

    process {

        # Load Web assembly when needed as PowerShell Core has the assembly preloaded
        if ( !('System.Web.HttpUtility' -as [Type]) ) {
            Add-Type -Assembly System.Web
        }

        if (!($DBPool_base_URI)) {
            Write-Warning 'The DBPool base URI is not set. Run Add-DBPoolBaseURI to set the base URI.'
        }

        $query_String = ConvertTo-DBPoolQueryString -resource_Uri $resource_Uri -uri_Filter $uri_Filter

        Set-Variable -Name 'DBPool_queryString' -Value $query_String -Scope Global -Force

        if ($null -eq $data) {
            $request_Body = $null
        } else {
            $request_Body = $data | ConvertTo-Json -Depth $DBPool_JSON_Conversion_Depth
        }

        try {
            $api_Key = $(Get-DBPoolAPIKey -AsPlainText).'ApiKey'

            $parameters = [ordered] @{
                'Method'  = $method
                'Uri'     = $query_String.Uri
                'Headers' = @{ 'X-App-Apikey' = "$api_Key" }
                'Body'    = $request_Body
            }

            if ( $method -ne 'GET' ) {
                $parameters['ContentType'] = 'application/json; charset=utf-8'
            }

            Set-Variable -Name 'DBPool_invokeParameters' -Value $parameters -Scope Global -Force

            if ($allPages) {

                Write-Verbose "Gathering all items from [  $( $DBPool_Base_URI + $resource_Uri ) ] "

                $page_Number = 1
                $all_responseData = [System.Collections.Generic.List[object]]::new()

                do {

                    $parameters['Uri'] = $query_String.Uri -replace '_page=\d+', "_page=$page_Number"

                    Write-Verbose "Making API request to Uri: [ $($parameters['Uri']) ]"
                    $current_Page = Invoke-WebRequest @parameters -ErrorAction Stop

                    Write-Verbose "[ $page_Number ] of [ $($current_Page.pagination.totalPages) ] pages"

                    foreach ($item in $current_Page.items) {
                        $all_responseData.add($item)
                    }

                    $page_Number++

                } while ($current_Page.pagination.totalPages -ne $page_Number - 1 -and $current_Page.pagination.totalPages -ne 0)

            } else {
                Write-Verbose "Making API request to Uri: [ $($parameters['Uri']) ]"
                $api_Response = Invoke-WebRequest @parameters -ErrorAction Stop
                $appRequestId = $api_Response.Headers['X-App-Request-Id']
                Write-Debug "If you need to report an error to the DBE team, include this request ID which can be used to search through the application logs for messages that were logged while processing your request [ X-App-Request-Id: $appRequestId ]"
                Set-Variable -Name 'DBPool_appRequestId' -Value $appRequestId -Scope Global -Force
            }

        } catch {
            
            $exceptionError = $_
            Write-Warning 'The [ DBPool_invokeParameters, DBPool_queryString, DBPool_appRequestId, & DBPool_CmdletNameParameters ] variables can provide extra details'

            # Extract the 'X-App-Request-Id' header if needed for reporting to DBE team
            $appRequestId = $null
            if ($_.Exception.Response -and $_.Exception.Response.Headers) {
                $appRequestId = $_.Exception.Response.Headers.GetValues('X-App-Request-Id')
                Set-Variable -Name 'DBPool_appRequestId' -Value $appRequestId -Scope Global -Force
                Write-Debug "If you need to report an error to the DBE team, include this request ID which can be used to search through the application logs for messages that were logged while processing your request [ X-App-Request-Id: $appRequestId ]"
            }

            switch -Wildcard ( $($exceptionError.Exception.Message) ) {
                '*401*' { Write-Error 'Status 401 : Unauthorized. Invalid API key' }
                '*404*' { Write-Error "Status 404 : [ $( $DBPool_base_URI + $resource_Uri ) ] not found!" }
                '*429*' { Write-Error 'Status 429 : API rate limited' }
                '*500*' {
                    $e = $($exceptionError.ErrorDetails.Message)
                    if ($null -ne $e) {
                        [string]$e = $( $e | ConvertFrom-Json -ErrorAction SilentlyContinue ).error.message
                    }
                    Write-Error "Status 500 : Internal Server Error. $e"
                }
                '*504*' { Write-Error "Status 504 : Gateway Timeout" }
                default { Write-Error $_ }
            }
        } finally {

            $Auth = $DBPool_invokeParameters['headers']['X-App-Apikey']
            $DBPool_invokeParameters['headers']['X-App-Apikey'] = $Auth.Substring( 0, [Math]::Min($Auth.Length, 9) ) + '*******'

        }


        if($allPages){

            #Making output consistent
            if( [string]::IsNullOrEmpty($all_responseData.data) ){
                $api_Response = $null
            }
            else{
                $api_Response = [PSCustomObject]@{
                    pagination  = $null
                    items       = $all_responseData
                }
            }

            # Return the response
            $api_Response

        }
        else{ $api_Response }

    }

    end {
        # Variables to remove
        $var = @(
            'api_Key',
            'parameters',
            'Auth'
        )
        foreach ($v in $var) {
            Remove-Variable -Name $v -ErrorAction SilentlyContinue -Force
        }
    }

}