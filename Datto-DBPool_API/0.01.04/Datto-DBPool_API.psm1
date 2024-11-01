

#Region
function Set-DBPoolApiParameter {
<#
    .SYNOPSIS
        The Set-DBPoolApiParameter function is used to set parameters for the Datto DBPool API.

    .DESCRIPTION
        The Set-DBPoolApiParameter function is used to set the API URL and API Key for the Datto DBPool API.

    .PARAMETER base_uri
        Provide the URL of the Datto DBPool API.
        The default value is https://dbpool.datto.net.

    .PARAMETER apiKey
        Provide Datto DBPool API Key for authorization.
        You can find your user API key at [ /web/self ](https://dbpool.datto.net/web/self).

    .PARAMETER Force
        Force the operation without confirmation.

    .INPUTS
        [Uri] - The base URL of the DBPool API.
        [SecureString] - The API key for the DBPool.

    .OUTPUTS
        [void] - No output is returned.

    .EXAMPLE
        Set-DBPoolApiParameter

        Sets the default base URI and prompts for the API Key.

    .EXAMPLE
        Set-DBPoolApiParameter -base_uri "https://dbpool.example.com" -apiKey $secureString

        Sets the base URI to https://dbpool.example.com and sets the API Key.

    .NOTES
        See Datto DBPool API help files for more information.

    .LINK
        N/A
#>

    [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = 'Low')]
    [OutputType([void])]
    Param(
        [Parameter(Position = 0, Mandatory = $False, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True, HelpMessage = "Provide the base URL of the DBPool API.")]
        [Uri]$base_uri = "https://dbpool.datto.net",

        [Parameter(Position = 1, Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True, HelpMessage = "Provide Datto DBPool API Key for authorization.")]
        [securestring]$apiKey,

        [Parameter(Position = 2, Mandatory = $False, HelpMessage = "Force the operation without confirmation.")]
        [switch]$Force
    )

    Begin {

        # Cast URI Variable to string type
        [String]$base_uri = $base_uri.AbsoluteUri

        # Check for trailing slash and remove if present
        $base_uri = $base_uri.TrimEnd('/')

        # Check to replace existing variables
        if ((Get-Variable -Name DBPool_Base_URI -ErrorAction SilentlyContinue) -and (Get-Variable -Name DBPool_ApiKey -ErrorAction SilentlyContinue)) {
            if (-not ($Force -or $PSCmdlet.ShouldContinue("Variables 'DBPool_Base_URI' and '$DBPool_ApiKey' already exist. Do you want to replace them?", "Confirm overwrite"))) {
                Write-Warning "Existing variables were not replaced."
                break
            }
        }

    }

    Process {

        # Set or replace the parameters
        try {
            Add-DBPoolBaseURI -base_uri $base_uri -Verbose:$PSBoundParameters.ContainsKey('Verbose') -ErrorAction Stop
            Add-DBPoolAPIKey -apiKey $apiKey -Verbose:$PSBoundParameters.ContainsKey('Verbose') -ErrorAction Stop
        }
        catch {
            Write-Error $_
        }

    }

    End {}
}
#EndRegion

#Region
function Test-DBPoolApi {
<#
    .SYNOPSIS
        Checks the availability of the DBPool API using an HTTP HEAD request.

    .DESCRIPTION
        This function sends an HTTP HEAD request to the specified API URL using Invoke-WebRequest.
        Checks if the HTTP status code is 200, indicating that the API is available.

    .PARAMETER base_uri
        The base URL of the API to be checked.

    .PARAMETER resource_Uri
        The URI of the API resource to be checked.

        The default value is '/api/docs/openapi.json'.

    .PARAMETER ApiKey
        Optional: Access token for authorization.

    .INPUTS
        [string] - The base URI for the DBPool API connection.
        [SecureString] - The API key for the DBPool.

    .OUTPUTS
        [System.Boolean] - Returns $true if the API is available, $false if not.

    .EXAMPLE
        Test-DBPoolApi -base_uri "https://api.example.com"

        Checks the availability of the API at https://api.example.com
#>

    [CmdletBinding()]
    [OutputType([System.Boolean], ParameterSetName = "API_Available")]
    param (
        [Parameter(Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True, HelpMessage = "The URL of the API to be checked.")]
        [string]$base_uri = $DBPool_Base_URI,

        [Parameter(Position = 1, Mandatory = $false)]
        [string]$resource_Uri = '/api/docs/openapi.json',

        [Parameter(Position = 2, Mandatory = $false, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True, HelpMessage = "API Key for authorization.")]
        [securestring]$apiKey = $DBPool_ApiKey
    )

    begin {

        # Check if API Parameters are set
        Write-Debug -Message "Api URL is $base_uri"
        Write-Debug -Message "Api Key is $DBPool_ApiKey"
        if (!($base_uri -and $apiKey)) {
            Write-Warning "API parameters are missing. Please run Set-DBPoolApiParameters first!"
            #break
        }

        # Sets the variable for the document URI to check, filtered to replace ending with /v2 with openapi docs
        #$base_uri = $base_uri.TrimEnd('/')
        # Use 'Add-DBPoolBaseURI' to remove superfluous trailing slashes
        Add-DBPoolBaseURI -base_uri $base_uri
        #$apiUri = $base_uri + $resource_Uri

    }

    process {

        Write-Verbose -Message "Checking API availability for URL $apiUri"
        try {
            Invoke-DBPoolRequest -Method 'HEAD' -resource_Uri $resource_Uri -ErrorAction Stop | Out-Null
            $true
        } catch {
            if ($_.Exception.Response.StatusCode -ne 200) {
                Write-Error $_.Exception.Message
                $false
            }
        }

    }

    end {}


}
#EndRegion

#Region
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
#EndRegion

#Region
function Get-DBPoolMetaData {
<#
    .SYNOPSIS
        Gets various API metadata values

    .DESCRIPTION
        The Get-DBPoolMetaData cmdlet gets various API metadata values from an
        Invoke-WebRequest to assist in various troubleshooting scenarios such
        as rate-limiting.

    .PARAMETER base_uri
        Define the base URI for the DBPool API connection using Datto's DBPool URI or a custom URI.

        The default base URI is https://dbpool.datto.net

    .PARAMETER resource_uri
        Define the resource URI for the DBPool API connection.

        The default resource URI is /api/v2/self

    .INPUTS
        [string] - base_uri

    .OUTPUTS
        [PSCustomObject] - Various API metadata values

    .EXAMPLE
        Get-DBPoolMetaData

        Gets various API metadata values from an Invoke-WebRequest to assist
        in various troubleshooting scenarios such as rate-limiting.

        The default full base uri test path is:
            https://dbpool.datto.net

    .EXAMPLE
        Get-DBPoolMetaData -base_uri http://dbpool.example.com

        Gets various API metadata values from an Invoke-WebRequest to assist
        in various troubleshooting scenarios such as rate-limiting.

        The full base uri test path in this example is:
            http://dbpool.example.com/device

    .NOTES
        N/A

    .LINK
        N/A
#>

    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        [parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]$base_uri = $DBPool_Base_URI,

        [string]$resource_uri = '/api/v2/self'
    )

    begin {

        $method       = 'GET'

    }

    process {

        try {

            $api_Key = $(Get-DBPoolAPIKey -AsPlainText).'ApiKey'

            $DBPool_Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
            $DBPool_Headers.Add("Content-Type", 'application/json')
            $DBPool_Headers.Add('X-App-APIkey', $api_Key)

            $rest_output = Invoke-WebRequest -method $method -uri ($base_uri + $resource_uri) -headers $DBPool_Headers -ErrorAction Stop
        }
        catch {

            [PSCustomObject]@{
                URI               = $($base_uri + $resource_uri)
                Method            = $method
                StatusCode        = $_.Exception.Response.StatusCode.value__
                StatusDescription = $_.Exception.Response.ReasonPhrase
                Message           = $_.Exception.Message
            }

        }
        finally {
            Remove-Variable -Name DBPool_Headers -Force
        }

        if ($rest_output){
            $data = @{}
            $data = $rest_output

            [PSCustomObject]@{
                RequestUri              = $($DBPool_Base_URI + $resource_uri)
                StatusCode              = $data.StatusCode
                StatusDescription       = $data.StatusDescription
                'Content-Type'          = $data.headers.'Content-Type'
                <#'X-App-Request-Id'      = $data.headers.'X-App-Request-Id'
                'X-API-Limit-Remaining' = $data.headers.'X-API-Limit-Remaining'
                'X-API-Limit-Resets'    = $data.headers.'X-API-Limit-Resets'
                'X-API-Limit-Cost'      = $data.headers.'X-API-Limit-Cost'#>
                raw                     = $data
            }
        }

    }

    end {}
}
#EndRegion

#Region
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
#EndRegion

#Region
function Add-DBPoolApiKey {
<#
    .SYNOPSIS
        Sets the API key for the DBPool.

    .DESCRIPTION
        The Add-DBPoolApiKey cmdlet sets the API key which is used to authenticate API calls made to DBPool.

        Once the API key is defined, the secret key is encrypted using SecureString.

        The DBPool API key is retrieved via the DBPool UI at My Profile -> API key

    .PARAMETER ApiKey
        Defines your API key for the DBPool.

    .INPUTS
        [SecureString] - The API key for the DBPool.

    .OUTPUTS
        [void] - No output is returned.

    .EXAMPLE
        Add-DBPoolApiKey

        Prompts to enter in your personal API key.

    .EXAMPLE
        Add-DBPoolApiKey -ApiKey $secureString
        Read-Host "Enter your DBPool API Key" -AsSecureString | Add-DBPoolApiKey

        Sets the API key for the DBPool.

    .NOTES
        N/A

    .LINK
        N/A
#>

    [CmdletBinding()]
    [Alias("Set-DBPoolApiKey")]
    [OutputType([void])]
    param (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "API Key for authorization to DBPool.")]
        [ValidateNotNullOrEmpty()]
        [securestring]$apiKey
    )

    begin {}

    process {

        Write-Verbose "Setting the DBPool API Key."
        Set-Variable -Name "DBPool_ApiKey" -Value $apiKey -Option ReadOnly -Scope global -Force

    }

    end {}
}
#EndRegion

#Region
function Get-DBPoolApiKey {
<#
    .SYNOPSIS
        Gets the DBPool API key global variable.

    .DESCRIPTION
        The Get-DBPoolApiKey cmdlet gets the DBPool API key global variable and returns this as an object.

    .PARAMETER AsPlainText
        Decrypt and return the API key in plain text.

    .INPUTS
        N/A

    .OUTPUTS
        [PSCustomObject] - The DBPool API key global variable.

    .EXAMPLE
        Get-DBPoolApiKey

        Gets the DBPool API key global variable and returns this as an object with the secret key as a SecureString.

    .EXAMPLE
        Get-DBPoolApiKey -AsPlainText

        Gets the DBPool API key global variable and returns this as an object with the secret key as plain text.


    .NOTES
        N\A

    .LINK
        N/A
#>

    [cmdletbinding()]
    [OutputType([PSCustomObject])]
    Param (
        [Parameter( Mandatory = $false )]
        [Switch]$AsPlainText
    )

    begin {}

    process {

        try {

            if ($DBPool_ApiKey) {

                if ($AsPlainText) {
                    if ($isWindows -or $PSEdition -eq 'Desktop') {
                        $ApiKeyBSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DBPool_ApiKey)
                        try {
                            $ApiKeyPlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($ApiKeyBSTR)
                            [PSCustomObject]@{
                                "ApiKey" = $ApiKeyPlainText
                            }
                        } finally {
                            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ApiKeyBSTR)
                        }
                    } else {
                        $ApiKeyPlainText = ConvertFrom-SecureString -SecureString $DBPool_ApiKey -AsPlainText

                        [PSCustomObject]@{
                            "ApiKey" = $ApiKeyPlainText
                        }
                    }

                    $ApiKeyPlainText = $null

                } else {
                    [PSCustomObject]@{
                        "ApiKey" = $DBPool_ApiKey
                    }
                }

            } else {
                Write-Warning "The DBPool API [ secret ] key is not set. Run Add-DBPoolApiKey to set the API key."
            }

        } catch {
            Write-Error $_
        } finally {
            if ($ApiKeyBSTR) {
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ApiKeyBSTR)
            }
        }

    }

    end {}
}
#EndRegion

#Region
function Remove-DBPoolApiKey {
<#
    .SYNOPSIS
        Removes the DBPool API Key global variable.

    .DESCRIPTION
        The Remove-DBPoolAPIKey cmdlet removes the DBPool API Key global variable.

    .PARAMETER Force
        Forces the removal of the DBPool API Key global variable without prompting for confirmation.

    .INPUTS
        N/A

    .OUTPUTS
        [void] - No output is returned.

    .EXAMPLE
        Remove-DBPoolAPIKey

        Removes the DBPool API Key global variable.

    .NOTES
        N/A

    .LINK
        N/A
#>

    [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType([void])]
    Param (
        [switch]$Force
    )

    begin {}

    process {

        switch ([bool]$DBPool_ApiKey) {
            $true   {
                if ($Force -or $PSCmdlet.ShouldProcess('DBPool_ApiKey', 'Remove variable')) {
                    Write-Verbose 'Removing the DBPool API Key.'
                    try {
                        Remove-Variable -Name 'DBPool_ApiKey' -Scope Global -Force
                    }
                    catch {
                        Write-Error $_
                    }
                }
            }
            $false  {
                Write-Warning "The DBPool API [ secret ] key is not set. Nothing to remove"
            }
        }

    }

    end {}

}
#EndRegion

#Region
function Test-DBPoolApiKey {
<#
    .SYNOPSIS
        Test the DBPool API Key.

    .DESCRIPTION
        The Test-DBPoolApiKey cmdlet tests the base URI & API Key that were defined in the Add-DBPoolBaseURI & Add-DBPoolAPIKey cmdlets.

    .PARAMETER base_uri
        Define the base URI for the DBPool API connection using Datto's DBPool URI or a custom URI.

        The default base URI is https://dbpool.datto.net/api

    .INPUTS
        [string] - base_uri

    .OUTPUTS
        [PSCustomObject] - Various API metadata values

    .EXAMPLE
        Test-DBPoolApiKey

        Tests the base URI & API key that was defined in the Add-DBPoolBaseURI & Add-DBPoolAPIKey cmdlets.

        The default full base uri test path is:
            https://dbpool.datto.net/api/v2/self

    .EXAMPLE
        Test-DBPoolApiKey -base_uri http://dbpool.example.com

        Tests the base URI & API key that was defined in the Add-DBPoolBaseURI & Add-DBPoolAPIKey cmdlets.

        The full base uri test path in this example is:
            http://dbpool.example.com/api/v2/self

    .NOTES
        N/A

    .LINK
        N/A
#>

    [cmdletbinding()]
    [OutputType([PSCustomObject])]
    Param (
        [parameter( Position = 0, Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Define the base URI for the DBPool connection. Default is Datto's DBPool URI or set a custom URI." )]
        [string]$base_uri = $DBPool_Base_URI
    )

    begin { $resource_uri = "/api/v2/self" }

    process {

        try {

            $api_key = $(Get-DBPoolAPIKey -AsPlainText).'API_Key'
            $DBPool_Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"

            $DBPool_Headers.Add("Content-Type", 'application/json')
            $DBPool_Headers.Add('X-App-Apikey', $api_key)

            $rest_output = Invoke-WebRequest -method Get -uri ($base_uri + $resource_uri) -headers $DBPool_Headers -ErrorAction Stop
        }
        catch {

            [PSCustomObject]@{
                Method = $_.Exception.Response.Method
                StatusCode = $_.Exception.Response.StatusCode.value__
                StatusDescription = $_.Exception.Response.StatusDescription
                Message = $_.Exception.Message
                URI = $($DBPool_Base_URI + $resource_uri)
            }

        }
        finally {
            Remove-Variable -Name DBPool_Headers -Force
        }

        if ($rest_output){
            $data = @{}
            $data = $rest_output

            [PSCustomObject]@{
                StatusCode = $data.StatusCode
                StatusDescription = $data.StatusDescription
                URI = $($DBPool_Base_URI + $resource_uri)
            }
        }

    }

    end {}

}
#EndRegion

#Region
function Add-DBPoolBaseURI {
<#
    .SYNOPSIS
        Sets the base URI for the DBPool API connection.

    .DESCRIPTION
        The Add-DBPoolBaseURI cmdlet sets the base URI which is later used
        to construct the full URI for all API calls.

    .PARAMETER base_uri
        Define the base URI for the DBPool API connection using Datto's DBPool URI or a custom URI.

    .PARAMETER instance
        DBPool's URI connection point that can be one of the predefined data centers.

        The accepted values for this parameter are:
        [ DEFAULT ]
            DEFAULT = https://dbpool.datto.net

        Placeholder for other data centers.

    .INPUTS
        [string] - The base URI for the DBPool API connection.

    .OUTPUTS
        [void] - No output is returned.

    .EXAMPLE
        Add-DBPoolBaseURI

        The base URI will use https://dbpool.datto.net which is Datto's default DBPool URI.

    .EXAMPLE
        Add-DBPoolBaseURI -instance Datto

        The base URI will use https://dbpool.datto.net which is DBPool's default URI.

    .EXAMPLE
        Add-DBPoolBaseURI -base_uri http://dbpool.example.com

        A custom API gateway of http://dbpool.example.com will be used for all API calls to DBPool's API.

    .NOTES
        N/A

    .LINK
        N/A
#>

    [cmdletbinding()]
    [OutputType([void])]
    [Alias("Set-DBPoolBaseURI")]
    Param (
        [Parameter(Mandatory = $false , ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$base_uri = 'https://dbpool.datto.net',

        [ValidateSet('Datto')]
        [String]$instance
    )

    begin {}

    process {

        # Trim superfluous forward slash from address (if applicable)
        $base_uri = $base_uri.TrimEnd('/')

        switch ($instance) {
            'Datto' { $base_uri = 'https://dbpool.datto.net' }
        }

        Set-Variable -Name "DBPool_Base_URI" -Value $base_uri -Option ReadOnly -Scope Global -Force
        Write-Verbose "DBPool Base URI set to `'$base_uri`'."

    }

    end {}

}
#EndRegion

#Region
function Get-DBPoolBaseURI {
<#
    .SYNOPSIS
        Shows the DBPool base URI global variable.

    .DESCRIPTION
        The Get-DBPoolBaseURI cmdlet shows the DBPool base URI global variable value.

    .INPUTS
        N/A

    .OUTPUTS
        [void] - No output is returned.

    .EXAMPLE
        Get-DBPoolBaseURI

        Shows the DBPool base URI global variable value.

    .NOTES
        N/A

    .LINK
        N/A
#>

    [cmdletbinding()]
    [OutputType([void])]
    Param ()

    begin {}

    process {

        switch ([bool]$DBPool_Base_URI) {
            $true   { $DBPool_Base_URI }
            $false  { Write-Warning "The DBPool base URI is not set. Run Add-DBPoolBaseURI to set the base URI." }
        }

    }

    end {}

}
#EndRegion

#Region
function Remove-DBPoolBaseURI {
<#
    .SYNOPSIS
        Removes the DBPool base URI global variable.

    .DESCRIPTION
        The Remove-DBPoolBaseURI cmdlet removes the DBPool base URI global variable.

    .PARAMETER Force
        Forces the removal of the DBPool base URI global variable without prompting for confirmation.

    .INPUTS
        N/A

    .OUTPUTS
        [void] - No output is returned.

    .EXAMPLE
        Remove-DBPoolBaseURI

        Removes the DBPool base URI global variable.

    .NOTES
        N/A

    .LINK
        N/A
#>

    [cmdletbinding(SupportsShouldProcess)]
    [OutputType([void])]
    Param ()

    begin {}

    process {

        switch ([bool]$DBPool_Base_URI) {
            $true   { Remove-Variable -Name "DBPool_Base_URI" -Scope Global -Force }
            $false  { Write-Warning "The DBPool base URI variable is not set. Nothing to remove" }
        }

    }

    end {}

}
#EndRegion

#Region
function Export-DBPoolModuleSetting {
<#
    .SYNOPSIS
        Exports the DBPool BaseURI, API Key, & JSON configuration information to file.

    .DESCRIPTION
        The Export-DBPoolModuleSetting cmdlet exports the DBPool BaseURI, API Key, & JSON configuration information to file.

        Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
        that can only be unencrypted with the your Windows account as this encryption is tied to your user principal.
        This means that you cannot copy your configuration file to another computer or user account and expect it to work.

    .PARAMETER DBPoolConfPath
        Define the location to store the DBPool configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\DBPoolAPI

    .PARAMETER DBPoolConfFile
        Define the name of the DBPool configuration file.

        By default the configuration file is named:
            config.psd1

    .INPUTS
        N/A

    .OUTPUTS
        [void] - No output is returned.

    .EXAMPLE
        Export-DBPoolModuleSetting

        Validates that the BaseURI, API Key, and JSON depth are set then exports their values
        to the current user's DBPool configuration file located at:
            $env:USERPROFILE\DBPoolAPI\config.psd1

    .EXAMPLE
        Export-DBPoolModuleSetting -DBPoolConfPath C:\DBPoolAPI -DBPoolConfFile MyConfig.psd1

        Validates that the BaseURI, API Key, and JSON depth are set then exports their values
        to the current user's DBPool configuration file located at:
            C:\DBPoolAPI\MyConfig.psd1

    .NOTES
        N/A

    .LINK
        N/A
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    [OutputType([void])]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$DBPoolConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"DBPoolAPI"}else{".DBPoolAPI"}) ),

        [Parameter(ParameterSetName = 'set')]
        [string]$DBPoolConfFile = 'config.psd1'
    )

    begin {}

    process {

        if (-not ($IsWindows -or $PSEdition -eq 'Desktop') ) {
            Write-Warning "Secrets are stored using Windows Data Protection API (DPAPI)"
            Write-Warning "DPAPI provides user context encryption in Windows but NOT in other operating systems like Linux or UNIX. It is recommended to use a more secure & cross-platform storage method"
        }

        $DBPoolConfig = Join-Path -Path $DBPoolConfPath -ChildPath $DBPoolConfFile

        # Confirm variables exist and are not null before exporting
        if ($DBPool_Base_URI -and $DBPool_ApiKey -and $DBPool_JSON_Conversion_Depth) {
            $secureString = $DBPool_ApiKey | ConvertFrom-SecureString

            if ($IsWindows -or $PSEdition -eq 'Desktop') {
                New-Item -Path $DBPoolConfPath -ItemType Directory -Force | ForEach-Object { $_.Attributes = $_.Attributes -bor "Hidden" }
            } else {
                New-Item -Path $DBPoolConfPath -ItemType Directory -Force
            }
@"
    @{
        DBPool_Base_URI = '$DBPool_Base_URI'
        DBPool_ApiKey = '$secureString'
        DBPool_JSON_Conversion_Depth = '$DBPool_JSON_Conversion_Depth'
    }
"@ | Out-File -FilePath $DBPoolConfig -Force
            Write-Verbose "DBPool Module settings exported to [ $DBPoolConfig ]"
        } else {
            Write-Error "Failed to export DBPool Module settings to [ $DBPoolConfig ]"
            Write-Error $_ -ErrorAction Stop
        }

    }

    end {}

}
#EndRegion

#Region
function Get-DBPoolModuleSetting {
<#
    .SYNOPSIS
        Gets the saved DBPool configuration settings

    .DESCRIPTION
        The Get-DBPoolModuleSetting cmdlet gets the saved DBPool configuration settings
        from the local system.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\DBPoolAPI

    .PARAMETER DBPoolConfPath
        Define the location to store the DBPool configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\DBPoolAPI

    .PARAMETER DBPoolConfFile
        Define the name of the DBPool configuration file.

        By default the configuration file is named:
            config.psd1

    .PARAMETER openConfFile
        Opens the DBPool configuration file

    .INPUTS
        N/A

    .OUTPUTS
        [void] - No output is returned.

    .EXAMPLE
        Get-DBPoolModuleSetting

        Gets the contents of the configuration file that was created with the
        Export-DBPoolModuleSetting

        The default location of the DBPool configuration file is:
            $env:USERPROFILE\DBPoolAPI\config.psd1

    .EXAMPLE
        Get-DBPoolModuleSetting -DBPoolConfPath C:\DBPoolAPI -DBPoolConfFile MyConfig.psd1 -openConfFile

        Opens the configuration file from the defined location in the default editor

        The location of the DBPool configuration file in this example is:
            C:\DBPoolAPI\MyConfig.psd1

    .NOTES
        N/A

    .LINK
        N/A
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    [OutputType([void])]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [string]$DBPoolConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"DBPoolAPI"}else{".DBPoolAPI"}) ),

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [String]$DBPoolConfFile = 'config.psd1',

        [Parameter(Mandatory = $false, ParameterSetName = 'show')]
        [Switch]$openConfFile
    )

    begin {
        $DBPoolConfig = Join-Path -Path $DBPoolConfPath -ChildPath $DBPoolConfFile
    }

    process {

        if ( Test-Path -Path $DBPoolConfig ){

            if($openConfFile){
                Invoke-Item -Path $DBPoolConfig
            }
            else{
                Import-LocalizedData -BaseDirectory $DBPoolConfPath -FileName $DBPoolConfFile
            }

        }
        else{
            Write-Verbose "No configuration file found at [ $DBPoolConfig ]"
        }

    }

    end {}

}
#EndRegion

#Region
function Import-DBPoolModuleSetting {
<#
    .SYNOPSIS
        Imports the DBPool BaseURI, API Key, & JSON configuration information to the current session.

    .DESCRIPTION
        The Import-DBPoolModuleSetting cmdlet imports the DBPool BaseURI, API Key, & JSON configuration
        information stored in the DBPool configuration file to the users current session.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\DBPoolAPI

    .PARAMETER DBPoolConfPath
        Define the location to store the DBPool configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\DBPoolAPI

    .PARAMETER DBPoolConfFile
        Define the name of the DBPool configuration file.

        By default the configuration file is named:
            config.psd1

    .INPUTS
        N/A

    .OUTPUTS
        N/A

    .EXAMPLE
        Import-DBPoolModuleSetting

        Validates that the configuration file created with the Export-DBPoolModuleSetting cmdlet exists
        then imports the stored data into the current users session.

        The default location of the DBPool configuration file is:
            $env:USERPROFILE\DBPoolAPI\config.psd1

    .EXAMPLE
        Import-DBPoolModuleSetting -DBPoolConfPath C:\DBPoolAPI -DBPoolConfFile MyConfig.psd1

        Validates that the configuration file created with the Export-DBPoolModuleSetting cmdlet exists
        then imports the stored data into the current users session.

        The location of the DBPool configuration file in this example is:
            C:\DBPoolAPI\MyConfig.psd1

    .NOTES
        N/A

    .LINK
        N/A
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$DBPoolConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"DBPoolAPI"}else{".DBPoolAPI"}) ),

        [Parameter(ParameterSetName = 'set')]
        [string]$DBPoolConfFile = 'config.psd1'
    )

    begin {
        $DBPoolConfig = Join-Path -Path $DBPoolConfPath -ChildPath $DBPoolConfFile
    }

    process {

        if ( Test-Path $DBPoolConfig ) {
            $tmp_config = Import-LocalizedData -BaseDirectory $DBPoolConfPath -FileName $DBPoolConfFile

            # Send to function to strip potentially superfluous slash (/)
            Add-DBPoolBaseURI $tmp_config.DBPool_Base_URI

            $tmp_config.DBPool_ApiKey = ConvertTo-SecureString $tmp_config.DBPool_ApiKey

            Set-Variable -Name "DBPool_ApiKey" -Value $tmp_config.DBPool_ApiKey -Option ReadOnly -Scope global -Force

            Set-Variable -Name "DBPool_JSON_Conversion_Depth" -Value $tmp_config.DBPool_JSON_Conversion_Depth -Scope global -Force

            Write-Verbose "DBPoolAPI Module configuration loaded successfully from [ $DBPoolConfig ]"

            # Clean things up
            Remove-Variable "tmp_config"
        }
        else {
            Write-Verbose "No configuration file found at [ $DBPoolConfig ] run Add-DBPoolAPIKey to get started."

            Add-DBPoolBaseURI

            Set-Variable -Name "DBPool_Base_URI" -Value $(Get-DBPoolBaseURI) -Option ReadOnly -Scope global -Force
            Set-Variable -Name "DBPool_JSON_Conversion_Depth" -Value 100 -Scope global -Force
        }

    }

    end {}

}
#EndRegion

#Region
function Remove-DBPoolModuleSetting {
<#
    .SYNOPSIS
        Removes the stored DBPool configuration folder.

    .DESCRIPTION
        The Remove-DBPoolModuleSetting cmdlet removes the DBPool folder and its files.
        This cmdlet also has the option to remove sensitive DBPool variables as well.

        By default configuration files are stored in the following location and will be removed:
            $env:USERPROFILE\DBPoolAPI

    .PARAMETER DBPoolConfPath
        Define the location of the DBPool configuration folder.

        By default the configuration folder is located at:
            $env:USERPROFILE\DBPoolAPI

    .PARAMETER andVariables
        Define if sensitive DBPool variables should be removed as well.

        By default the variables are not removed.

    .INPUTS
        N/A

    .OUTPUTS
        [void] - No output is returned.

    .EXAMPLE
        Remove-DBPoolModuleSetting

        Checks to see if the default configuration folder exists and removes it if it does.

        The default location of the DBPool configuration folder is:
            $env:USERPROFILE\DBPoolAPI

    .EXAMPLE
        Remove-DBPoolModuleSetting -DBPoolConfPath C:\DBPoolAPI -andVariables

        Checks to see if the defined configuration folder exists and removes it if it does.
        If sensitive DBPool variables exist then they are removed as well.

        The location of the DBPool configuration folder in this example is:
            C:\DBPoolAPI

    .NOTES
        N/A

    .LINK
        N/A
#>

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'set')]
    [OutputType([void])]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$DBPoolConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"DBPoolAPI"}else{".DBPoolAPI"}) ),

        [Parameter(ParameterSetName = 'set')]
        [switch]$andVariables
    )

    begin {}

    process {

        if (Test-Path $DBPoolConfPath) {

            Remove-Item -Path $DBPoolConfPath -Recurse -Force -WhatIf:$WhatIfPreference

            If ($andVariables) {
                Remove-DBPoolAPIKey
                Remove-DBPoolBaseURI
            }

            if (!(Test-Path $DBPoolConfPath)) {
                Write-Output "The DBPoolAPI configuration folder has been removed successfully from [ $DBPoolConfPath ]"
            }
            else {
                Write-Error "The DBPoolAPI configuration folder could not be removed from [ $DBPoolConfPath ]"
            }

        }
        else {
            Write-Warning "No configuration folder found at [ $DBPoolConfPath ]"
        }

    }

    end {}

}
#EndRegion

#Region
function Get-DBPoolContainer {
    <#
    .SYNOPSIS
        The Get-DBPoolContainer function retrieves container information from the DBPool API.

    .DESCRIPTION
        This function retrieves container details from the DBPool API.

        It can get containers, parent containers, or child containers, and also retrieve containers or container status by ID.
        This also can filter or exclude by container name or database.

    .PARAMETER Id
        The ID of the container details to get from the DBPool.
        This parameter is required when using the 'ContainerStatus' parameter set.

    .PARAMETER Status
        Gets the status of a container by ID.
        Returns basic container details, and dockerContainerRunning, mysqlServiceResponding, and mysqlServiceRespondingCached statuses.

    .PARAMETER ListContainer
        Retrieves a list of containers from the DBPool API. This is the default parameter set.

    .PARAMETER ParentContainer
        Retrieves a list of parent containers from the DBPool API.

    .PARAMETER ChildContainer
        Retrieves a list of child containers from the DBPool API.

    .PARAMETER Name
        Filters containers returned from the DBPool API by name.
        Accepts wildcard input.

    .PARAMETER DefaultDatabase
        Filters containers returned from the DBPool API by database.
        Accepts wildcard input.

    .PARAMETER NotLike
        Excludes containers returned from the DBPool API by Name or DefaultDatabase using the -NotLike switch.
        Requires the -Name or -DefaultDatabase parameter to be specified.

        Returns containers where the Name or DefaultDatabase does not match the provided filter.

    .INPUTS
        [int] - The ID of the container to get details for.
        [string] - The name of the container to get details for.
        [string] - The database of the container to get details for.

    .OUTPUTS
        [PSCustomObject] - The response from the DBPool API.

    .EXAMPLE
        Get-DBPoolContainer

        Get a list of all containers from the DBPool API

    .EXAMPLE
        Get-DBPoolContainer -Id 12345

        Get a list of containers from the DBPool API by ID

    .EXAMPLE
        Get-DBPoolContainer -Status -Id @( 12345, 67890 )

        Get the status of an array of containers by IDs

    .EXAMPLE
        Get-DBPoolContainer -ParentContainer

        Get a list of parent containers from the DBPool API

    .EXAMPLE
        Get-DBPoolContainer -ParentContainer -Id 12345

        Get a list of parent containers from the DBPool API by ID

    .EXAMPLE
        Get-DBPoolContainer -ChildContainer

        Get a list of child containers from the DBPool API

    .EXAMPLE
        Get-DBPoolContainer -Name 'MyContainer'
        Get-DBPoolContainer -ParentContainer -Name 'ParentContainer*'

        Uses 'Where-Object' to get a list of containers from the DBPool API, or parent containers by name
        Accepts wildcard input

    .EXAMPLE
        Get-DBPoolContainer -Name 'MyContainer' -NotLike
        Get-DBPoolContainer -ParentContainer -Name 'ParentContainer*' -NotLike

        Uses 'Where-Object' to get a list of containers from the DBPool API, or parent containers where the name does not match the filter
        Accepts wildcard input

    .EXAMPLE
        Get-DBPoolContainer -DefaultDatabase 'Database'
        Get-DBPoolContainer -ParentContainer -DefaultDatabase 'Database*'

        Get a list of containers from the DBPool API, or parent containers by database
        Accepts wildcard input

    .EXAMPLE
        Get-DBPoolContainer -DefaultDatabase 'Database' -NotLike
        Get-DBPoolContainer -ParentContainer -DefaultDatabase 'Database*' -NotLike

        Get a list of containers from the DBPool API, or parent containers where the database does not match the filter
        Accepts wildcard input

    .NOTES
        The -Name, and -DefaultDatabase parameters are not native endpoints of the DBPool API.
        This is a custom function which uses 'Where-Object', along with the optional -NotLike parameter to return the response using the provided filter.

        If no match is found an error is output, and the original response is returned.

    .LINK
        N/A
#>

    [CmdletBinding(DefaultParameterSetName = 'ListContainer')]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(ParameterSetName = 'ListContainer')]
        [switch]$ListContainer,

        [Parameter(ParameterSetName = 'ParentContainer')]
        [switch]$ParentContainer,

        [Parameter(ParameterSetName = 'ChildContainer')]
        [switch]$ChildContainer,

        [Parameter(ParameterSetName = 'ParentContainer', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ListContainer', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ContainerStatus', Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        #[ValidateRange(0, [int]::MaxValue)]
        [int[]]$Id,

        [Parameter(ParameterSetName = 'ContainerStatus')]
        [switch]$Status,

        [Parameter(ParameterSetName = 'ListContainer', ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ParentContainer', ValueFromPipelineByPropertyName = $true)]
        [SupportsWildcards()][string[]]$Name,

        [Parameter(ParameterSetName = 'ListContainer', ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ParentContainer', ValueFromPipelineByPropertyName = $true)]
        [Alias('Database')]
        [SupportsWildcards()][string[]]$DefaultDatabase,

        [Parameter(ParameterSetName = 'ListContainer')]
        [Parameter(ParameterSetName = 'ParentContainer')]
        [switch]$NotLike
    )

    begin {

        $method = 'GET'
        switch ($PSCmdlet.ParameterSetName) {
            'ListContainer' { $requestPath = '/api/v2/containers' }
            'ParentContainer' { $requestPath = '/api/v2/parents' }
            'ChildContainer' { $requestPath = '/api/v2/children' }
            'ContainerStatus' { $requestPath = '/api/v2/containers' }
        }

        # Validate filter parameters for name or DefaultDatabase if -NotLike switch is used
        if ($PSCmdlet.ParameterSetName -eq 'ListContainer' -or $PSCmdlet.ParameterSetName -eq 'ParentContainer') {
            if ($NotLike -and -not ($Name -or $DefaultDatabase)) {
                Write-Error 'The -NotLike switch requires either the -Name or -DefaultDatabase parameter to be specified.' -ErrorAction Stop
            }
        }

        # Internal Function to filter the response by Container Name or DefaultDatabase if provided
        function Select-DBPoolContainer {
            param(
                [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
                [PSObject[]]$Container,

                [Parameter(Mandatory = $false)]
                [string[]]$Name,

                [Parameter(Mandatory = $false)]
                [string[]]$DefaultDatabase,

                [Parameter(Mandatory = $false)]
                [switch]$NotLike
            )

            process {
                # Verbose filter output
                $Filter = @()
                $filterParameter = @()

                if ($Name) {
                    $Filter += 'Name'
                    $filterParameter += ($Name -join ', ')
                }
                if ($DefaultDatabase) {
                    $Filter += 'DefaultDatabase'
                    $filterParameter += ($DefaultDatabase -join ', ')
                }

                $filterHeader = $Filter -join '; '
                $filterValues = @()

                if ($Name) {
                    $filterValues += ($Name -join ', ')
                }
                if ($DefaultDatabase) {
                    $filterValues += ($DefaultDatabase -join ', ')
                }

                if ($NotLike) {
                    Write-Verbose "Excluding response by containers matching $filterHeader [ $($filterValues -join '; ') ]"
                } else {
                    Write-Verbose "Filtering response by containers matching $filterHeader [ $($filterValues -join '; ') ]"
                }

                # Filter containers
                $FilteredContainers = $Container | Where-Object {
                    $matchesName = $true
                    $matchesDB = $true

                    # Handle Name filtering
                    if ($Name) {
                        $matchesName = $false
                        foreach ($n in $Name) {
                            if ($_.name -like $n) {
                                $matchesName = $true
                                break
                            }
                        }
                        if ($NotLike) {
                            $matchesName = -not $matchesName
                        }
                    }

                    # Handle DefaultDatabase filtering
                    if ($DefaultDatabase) {
                        $matchesDB = $false
                        foreach ($db in $DefaultDatabase) {
                            if ($_.defaultDatabase -like $db) {
                                $matchesDB = $true
                                break
                            }
                        }
                        if ($NotLike) {
                            $matchesDB = -not $matchesDB
                        }
                    }

                    # Return true if both conditions match
                    $matchesName -and $matchesDB
                }

                # Output filtered containers
                if (!$FilteredContainers) {
                    Write-Warning "No containers found matching the $filterHeader filter parameter [ $($filterValues -join '; ') ]. Returning all containers."
                    return $Container
                }

                return $FilteredContainers
            }
        }

    }

    process {

        # Get list of containers by ID
        if ($PSBoundParameters.ContainsKey('Id')) {
            $response = foreach ($n in $Id) {
                $requestResponse = $null
                Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameter set for ID $n"

                # Define the ContainerStatus parameter request path if set
                $uri = "$requestPath/$n"
                if ($Status) {
                    $uri += '/status'
                }

                try {
                    $requestResponse = Invoke-DBPoolRequest -method $method -resource_Uri $uri -ErrorAction Stop
                } catch {
                    Write-Error $_
                    continue
                }

                if ($null -ne $requestResponse) {
                    $requestResponse | ConvertFrom-Json
                }
            }
        # Get list of containers based on the parameter set, returns all listed containers
        } else {
            Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameter set"

            try {
                $requestResponse = Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -ErrorAction Stop
            } catch {
                Write-Error $_
            }

            # Convert the response to JSON, return the response based on the parameter set
            if ($null -ne $requestResponse) {
                $response = $requestResponse | ConvertFrom-Json

                if ($PSCmdlet.ParameterSetName -eq 'ParentContainer') {
                    $response = $response.parents
                } elseif ($PSCmdlet.ParameterSetName -eq 'ListContainer') {
                    $response = $response.containers
                }
            }
        }


        # Filter the response by Name or DefaultDatabase if provided using internal helper function
        if ($PSBoundParameters.ContainsKey('Name') -or $PSBoundParameters.ContainsKey('DefaultDatabase')) {
            try {
                $response = Select-DBPoolContainer -Container $response -Name $Name -DefaultDatabase $DefaultDatabase -NotLike:$NotLike -ErrorAction Stop
            } catch {
                Write-Error $_
            }
        }

        # Return the response
        $response

    }

    end {}

}
#EndRegion

#Region
function New-DBPoolContainer {
<#
    .SYNOPSIS
        The New-DBPoolContainer function is used to create a new container from the DBPool API.

    .DESCRIPTION
        This function creates a new container in the DBPool based on the provided container name and parent container information.
        The ContainerName parameter is mandatory, and at least one of the parent parameters (ParentId, ParentName, or ParentDefaultDatabase) must be specified.

    .PARAMETER ContainerName
        The name for the new container.

    .PARAMETER ParentId
        The ID of the parent container to clone.

    .PARAMETER ParentName
        The name of the parent container to clone.

    .PARAMETER ParentDefaultDatabase
        The default database of the parent container to clone.

    .PARAMETER Force
        Force the operation without confirmation.

    .INPUTS
        [string] - The name for the new container.
        [int] - The ID of the parent container to clone.
        [string] - The name of the parent container to clone.
        [string] - The default database of the parent container to clone.

    .OUTPUTS
        [PSCustomObject] - The response from the DBPool API.

    .EXAMPLE
        New-DBPoolContainer -ContainerName 'MyNewContainer' -ParentId 12345

        This will create a new container named 'MyNewContainer' based on the parent container with ID 12345.

    .EXAMPLE
        Get-DBPoolContainer -ParentContainer -Id 1 | New-DBPoolContainer -ContainerName 'MyNewContainer'

        This will create a new container named 'MyNewContainer' based on the piped in parent container.

    .NOTES
        N/A

    .LINK
        N/A
#>

    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$ContainerName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [Alias("Id")]
        [int]$ParentId,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Alias("Name")]
        [string]$ParentName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Alias("DefaultDatabase")]
        [string]$ParentDefaultDatabase,

        [Parameter(Mandatory = $false, DontShow = $true)]
        [Switch]$Force
    )

    begin {

        $method = 'POST'
        $requestPath = "/api/v2/containers"
        $body = @{}

    }

    process {

        $body['name'] = $ContainerName

        # Check that at least one parent parameter is provided
        # This is done rather than using parameter sets or mandatory parameters to allow for multiple parent parameters to be provided as API accepts multiple parent parameter inputs
        # If multiple fields are specified, both conditions will have to match a parent for it to be selected.
        if (-not ($PSBoundParameters.ContainsKey('ParentId') -or $PSBoundParameters.ContainsKey('ParentName') -or $PSBoundParameters.ContainsKey('ParentDefaultDatabase'))) {
            Write-Error "At least one parent parameter (ParentId, ParentName, or ParentDefaultDatabase) must be provided." -ErrorAction Stop
        }

        # Insert specified parent parameters into the request body
        if ($PSBoundParameters.ContainsKey('ParentId')) {
            $body.'parent.id' = $ParentId
        }
        if ($PSBoundParameters.ContainsKey('ParentName')) {
            $body.'parent.name' = $ParentName
        }
        if ($PSBoundParameters.ContainsKey('ParentDefaultDatabase')) {
            $body.'parent.defaultDatabase' = $ParentDefaultDatabase
        }

        try {
            if ($Force -or $PSCmdlet.ShouldProcess("Container Name: $ContainerName", "Create new Container")) {
                $response = Invoke-DBPoolRequest -Method $method -resource_Uri $requestPath -data $body -ErrorAction Stop
            }

            if ($null -ne $response) {
                $response = $response | ConvertFrom-Json
            }
        }
        catch {
            Write-Error $_
        }

        # Return the response
        $response

    }

    end {}

}
#EndRegion

#Region
function Remove-DBPoolContainer {
    <#
    .SYNOPSIS
        The Remove-DBPoolContainer function is used to delete a container in the DBPool.

    .DESCRIPTION
        The Remove-DBPoolContainer function is used to delete containers in the DBPool based on the provided container ID.

        !! This is a destructive operation and will destory the container !!

    .PARAMETER Id
        The ID of the container to delete.
        This accepts an array of integers.

    .PARAMETER Force
        Forces the removal of the container without prompting for confirmation.

    .INPUTS
        [int] - The ID of the container to delete.

    .OUTPUTS
        [void] - No output is returned.

    .EXAMPLE
        Remove-DBPoolContainer -Id '12345'

        This will delete the provided container by ID.

    .EXAMPLE
        @( 12345, 56789 ) | Remove-DBPoolContainer -Confirm:$false

        This will delete the containers with ID 12345, and 56789.

    .NOTES
        N/A

    .LINK
        N/A
#>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [Alias('ContainerId')]
        [int[]]$Id,

        [switch]$Force
    )

    begin {

        $method = 'DELETE'

        # Pass the InformationAction parameter if bound, default to 'Continue'
        if ($PSBoundParameters.ContainsKey('InformationAction')) {
            $InformationPreference = $PSBoundParameters['InformationAction']
        } else {
            $InformationPreference = 'Continue'
        }

    }

    process {

        foreach ($n in $Id) {
            $response = $null
            $requestPath = "/api/v2/containers/$n"

            # Try to get the container name to output for the ID when using the Verbose preference
            if ($VerbosePreference -eq 'Continue') {
                try {
                    $containerName = (Get-DBPoolContainer -Id $n -ErrorAction Stop).name
                } catch {
                    Write-Warning "Failed to get the container name for ID $n. $_"
                    $containerName = '## FailedToGetContainerName ##'
                }
            }

            if ($Force -or $PSCmdlet.ShouldProcess("Container [ ID: $n ]", 'Destroy')) {
                Write-Verbose "Destroying Container [ ID: $n, Name: $containerName ]"

                try {
                    $response = Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -ErrorAction Stop
                }
                catch {
                    Write-Error $_
                }

                if ($response.StatusCode -eq 204) {
                    Write-Information "Success: Container [ ID: $n ] destroyed."
                }
            }
        }

    }

    end {}
}
#EndRegion

#Region
function Rename-DBPoolContainer {
    <#
    .SYNOPSIS
        The Rename-DBPoolContainer function is used to update a container in the DBPool.

    .DESCRIPTION
        The Rename-DBPoolContainer function is used to change the name a container in the DBPool API.

    .PARAMETER Id
        The ID of the container to update.
        This accepts an array of integers.

    .PARAMETER Name
        The new name for the container.

    .INPUTS
        [int] - The ID of the container to update.
        [string] - The new name for the container.

    .OUTPUTS
        [PSCustomObject] - The response from the DBPool API.

    .EXAMPLE
        Rename-DBPoolContainer -Id 12345 -Name 'NewContainerName'

        This will update the container with ID 12345 to have the name 'NewContainerName'

    .EXAMPLE
        @( 12345, 56789 ) | Rename-DBPoolContainer -Name 'NewContainerName'

        This will update the containers with ID 12345, and 56789 to have the name 'NewContainerName'

    .NOTES
        N/A

    .LINK
        N/A
#>

    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [Alias('ContainerId')]
        [int[]]$Id,

        [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Name
    )

    begin {

        $method = 'PATCH'
        $body = @{
            name = $Name
        }

        # Pass the InformationAction parameter if bound, default to 'Continue'
        if ($PSBoundParameters.ContainsKey('InformationAction')) {
            $InformationPreference = $PSBoundParameters['InformationAction']
        } else {
            $InformationPreference = 'Continue'
        }

    }

    process {

        $response = foreach ($n in $Id) {
            $requestResponse = $null
            $requestPath = "/api/v2/containers/$n"

            # Try to get the container name to output for the ID when using the Verbose preference
            if ($VerbosePreference -eq 'Continue') {
                try {
                    $containerName = (Get-DBPoolContainer -Id $n -ErrorAction Stop).name
                } catch {
                    Write-Warning "Failed to get the container name for ID $n. $_"
                    $containerName = '## FailedToGetContainerName ##'
                }
            }

            try {
                Write-Verbose "Updating Container [ ID: $n, Name: $containerName ]"
                $requestResponse = Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -data $body -ErrorAction Stop
                if ($requestResponse.StatusCode -eq 200) {
                    Write-Information "Successfully updated Container [ ID: $n ]"
                }
            }
            catch {
                Write-Error $_
            }

            if ($null -ne $requestResponse) {
                $requestResponse | ConvertFrom-Json
            }

        }

        # Return the response
        $response

    }

    end {}
}
#EndRegion

#Region
function Invoke-DBPoolContainerAccess {
<#
    .SYNOPSIS
        The Invoke-DBPoolContainerAccess function is used to interact with various container access operations in the Datto DBPool API.

    .DESCRIPTION
        The Invoke-DBPoolContainerAccess function is used to Get, Add, or Remove access to a container in the Datto DBPool API based on a given username.

    .PARAMETER Id
        The ID of the container to access.
        This accepts an array of integers.

    .PARAMETER Username
        The username to access the container.
        This accepts an array of strings.

    .PARAMETER GetAccess
        Gets the current access to a container by ID for the given username.

    .PARAMETER AddAccess
        Adds access to a container by ID for the given username.

    .PARAMETER RemoveAccess
        Removes access to a container by ID for the given username.

    .INPUTS
        [int] - The ID of the container to access.
        [string] - The username to access the container.

    .OUTPUTS
        [PSCustomObject] - The response from the DBPool API.
        [void] - No output is returned.

    .EXAMPLE
        Invoke-DBPoolContainerAccess -Id '12345' -Username 'John.Doe'
        Invoke-DBPoolContainerAccess -Id '12345' -Username 'John.Doe' -GetAccess

        This will get access to the container with ID 12345 for the user "John.Doe"

    .EXAMPLE
        Invoke-DBPoolContainerAccess -Id @( '12345', '56789' ) -Username 'John.Doe' -AddAccess

        This will add access to the containers with ID 12345, and 56789 for the user "John.Doe"

    .EXAMPLE
        Invoke-DBPoolContainerAccess -Id '12345' -Username @( 'Jane.Doe', 'John.Doe' ) -RemoveAccess

        This will remove access to the container with ID 12345 for the users "Jane.Doe", and "John.Doe"

    .NOTES
        N/A

    .LINK
        N/A
#>

    [CmdletBinding(DefaultParameterSetName = 'GetAccess', SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    [OutputType([PSCustomObject], ParameterSetName = { 'GetAccess', 'AddAccess' })]
    [OutputType([void], ParameterSetName = 'RemoveAccess')]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        #[ValidateRange(1, [int]::MaxValue)]
        [Alias('ContainerId')]
        [int[]]$Id,

        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'GetAccess', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'AddAccess', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'RemoveAccess', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Username,

        [Parameter(Mandatory = $false, ParameterSetName = 'GetAccess')]
        [Switch]$GetAccess,

        [Parameter(Mandatory = $false, ParameterSetName = 'AddAccess')]
        [Switch]$AddAccess,

        [Parameter(Mandatory = $false, ParameterSetName = 'RemoveAccess')]
        [Switch]$RemoveAccess
    )

    begin {

        # Pass the InformationAction parameter if bound, default to 'Continue'
        if ($PSBoundParameters.ContainsKey('InformationAction')) {
            $InformationPreference = $PSBoundParameters['InformationAction']
        } else {
            $InformationPreference = 'Continue'
        }

    }

    process {

        $response = foreach ($n in $Id) {
            foreach ($uName in $Username) {
                $requestPath = "/api/v2/containers/$n/access/$uName"
                $method = $null
                $requestResponse = $null
                $responseContent = $null

                switch ($PSCmdlet.ParameterSetName) {
                    'GetAccess' {
                        $method = 'GET'
                    }
                    'AddAccess' {
                        if ($PSCmdlet.ShouldProcess("[ $uName ] for Container [ ID: $n ]", "[ $($PSCmdlet.ParameterSetName) ]")) {
                            $method = 'PUT'
                        }
                    }
                    'RemoveAccess' {
                        if ($PSCmdlet.ShouldProcess("[ $uName ] for Container [ ID: $n ]", "[ $($PSCmdlet.ParameterSetName) ]")) {
                            $method = 'DELETE'
                        }
                    }
                }

                if ($method) {

                    try {
                        $requestResponse = Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -ErrorAction Stop
                    }
                    catch {
                        $requestResponse = $null
                        Write-Error $_
                    }

                    if ($null -ne $requestResponse) {
                            $responseContent = $requestResponse.Content | ConvertFrom-Json
                        }

                    switch ($PSCmdlet.ParameterSetName) {
                                'GetAccess' {
                                    $responseContent
                                }
                                'AddAccess' {
                                    if ($requestResponse.StatusCode -eq 200) {
                                        Write-Information "User access on Container [ ID: $n ] already exists for [ $uName ]"
                                    } elseif ($requestResponse.StatusCode -eq 201) {
                                        Write-Information "User access on Container [ ID: $n ] successfully created for [ $uName ]"
                                    }
                                    $responseContent
                                }
                                'RemoveAccess' {
                                    if ($requestResponse.StatusCode -eq 204) {
                                        Write-Information "User access on Container [ ID: $n ] successfully removed for [ $uName ]"
                                    }
                                    $responseContent
                                }
                            }
                }
            }
        }

        # Return the responses
        $response

    }

    end {}

}
#EndRegion

#Region
function Invoke-DBPoolContainerAction {
    <#
    .SYNOPSIS
        The Invoke-DBPoolContainerAction function is used to interact with various container action operations in the Datto DBPool API.

    .DESCRIPTION
        The Invoke-DBPoolContainerAction function is used to perform actions on a container such as refresh, schema-merge, start, restart, or stop.

    .PARAMETER Id
        The ID(s) of the container(s) to perform the action on.

    .PARAMETER Action
        The action to perform on the container. Valid actions are: refresh, schema-merge, start, restart, or stop.

        Start, Stop, and Restart are all considered minor actions and will not require a confirmation prompt.
        Refresh and Schema-Merge are considered major actions and will require a confirmation prompt.

    .PARAMETER Force
        Skip the confirmation prompt for major actions, such as 'Refresh' and 'Schema-Merge'.

    .PARAMETER TimeoutSeconds
        The maximum time in seconds to wait for the action to complete. Default is 3600 seconds (60 minutes).

    .PARAMETER ThrottleLimit
        The maximum number of containers to process in parallel. Default is twice the number of processor cores.

    .INPUTS
        [int] - The ID of the container to perform the action on.
        [string] - The action to perform on the container.

    .OUTPUTS
        [void] - No output is returned.

    .EXAMPLE
        Invoke-DBPoolContainerAction -Id '12345' -Action 'restart'

        This will restart the container with ID 12345

    .EXAMPLE
        Invoke-DBPoolContainerAction -Id @( '12345', '56789' ) -Action 'refresh'

        This will refresh the containers with ID 12345, and 56789

    .NOTES
        Actions:

            refresh:
                Recreate the Docker container and ZFS snapshot for the container.

            schema-merge:
                Attempt to apply upstream changes to the parent container to this child container.
                This may break your container. Refreshing a container is the supported way to update a child container's database schema.

            start:
                Start the Docker container for the container.

            restart:
                Stop and start the Docker container.

            stop:
                Stop the Docker container.

    .LINK
        N/A
#>

    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateSet('refresh', 'schema-merge', 'start', 'restart', 'stop', IgnoreCase = $false)]
        [string]$Action,

        [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [Alias('ContainerId')]
        [int[]]$Id,

        [switch]$Force,

        [Parameter(DontShow = $true)]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$TimeoutSeconds = 3600,  # Default timeout of 60 minutes (3600 seconds) for longer running actions

        [Parameter(DontShow = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$ThrottleLimit = ([Environment]::ProcessorCount * 2)
    )

    begin {

        $method = 'POST'

        # Pass the InformationAction parameter if bound, default to 'Continue'
        if ($PSBoundParameters.ContainsKey('InformationAction')) {
            $InformationPreference = $PSBoundParameters['InformationAction']
        } else {
            $InformationPreference = 'Continue'
        }

        # Write warning when using deprecated 'schema-merge' action, otherwise set confirmation prompt for 'major' actions
        if ($Action -eq 'schema-merge') {
            Write-Warning 'The action [ schema-merge ] is deprecated! Use the [ refresh ] action as the supported way to update a container.'
            $ConfirmPreference = 'Medium'
        } elseif ($Action -eq 'refresh' -and -not $Force) {
            $ConfirmPreference = 'Medium'
        }

        $moduleName = $MyInvocation.MyCommand.Module.Name
        if ([string]::IsNullOrEmpty($moduleName)) {
            Write-Error 'This function is not loaded as part of a module or the module name is unavailable.' -ErrorAction Stop
        }
        $modulePath = (Get-Module -Name $moduleName).Path

        # Check if the ForEach-Object cmdlet supports the Parallel parameter
        $supportsParallel = ((Get-Command ForEach-Object).Parameters.keys) -contains 'Parallel'

        # Create shared runspace pool for parallel tasks
        if (!$supportsParallel) {
            $runspacePool = [runspacefactory]::CreateRunspacePool(1, $ThrottleLimit)
            $runspacePool.Open()
            $runspaceQueue = [System.Collections.Concurrent.ConcurrentQueue[PSCustomObject]]::new()
        }

    }

    process {

        if ($supportsParallel) {

            $IdsToProcess = [System.Collections.ArrayList]::new()
            foreach ($n in $Id) {
                if ($Force -or $PSCmdlet.ShouldProcess("Container [ ID: $n ]", "[ $Action ]")) {
                    $IdsToProcess.Add($n) | Out-Null
                }
            }

            if ($IdsToProcess.Count -gt 0) {
                $IdsToProcess | ForEach-Object -Parallel {
                    $n = $_

                    Import-Module $using:modulePath
                    Add-DBPoolBaseURI -base_uri $using:DBPool_Base_URI
                    Add-DBPoolApiKey -apiKey $using:DBPool_ApiKey

                    $requestPath = "/api/v2/containers/$n/actions/$using:Action"

                    # Try to get the container name to output for the ID when using the Verbose preference
                    if ($using:VerbosePreference -eq 'Continue') {
                        try {
                            $containerName = (Get-DBPoolContainer -Id $n -ErrorAction Stop).name
                        } catch {
                            Write-Error "Failed to get the container name for ID $n. $_"
                            $containerName = '## FailedToGetContainerName ##'
                        }
                    }
                    Write-Verbose "Performing action [ $using:Action ] on Container [ ID: $n, Name: $containerName ]" -Verbose:($using:VerbosePreference -eq 'Continue')

                    try {
                        $requestResponse = Invoke-DBPoolRequest -method $using:method -resource_Uri $requestPath -ErrorAction Stop -WarningAction:SilentlyContinue
                        if ($requestResponse.StatusCode -eq 204) {
                            Write-Information "Success: Invoking Action [ $using:Action ] on Container [ ID: $n ]."
                        }
                    } catch {
                        Write-Error $_
                    }
                } -ThrottleLimit $ThrottleLimit -TimeoutSeconds $TimeoutSeconds
            }

        } else {
            # Process each container ID in parallel using runspaces where the ForEach-Object cmdlet does not support the Parallel parameter in Windows PowerShell 5.1 _(or version prior to [PowerShell 7.0](https://devblogs.microsoft.com/powershell/powershell-foreach-object-parallel-feature/))_
            # This is a manual implementation workaround of parallel processing using runspaces
            # TODO: Refactor to use [Invoke-Parallel](https://github.com/RamblingCookieMonster/Invoke-Parallel), or [PSParallelPipeline](https://github.com/santisq/PSParallelPipeline) module for parallel processing for better performance optimization as current implementation appears to have high performance overheard
            foreach ($n in $Id) {
                $requestPath = "/api/v2/containers/$n/actions/$Action"

                if ($Force -or $PSCmdlet.ShouldProcess("Container [ ID: $n ]", "[ $Action ]")) {
                    # Try to get the container name to output for the ID when using the Verbose preference
                    if ($VerbosePreference -eq 'Continue') {
                        try {
                            $containerName = (Get-DBPoolContainer -Id $n -ErrorAction stop -Verbose:($VerbosePreference -eq 'SilentlyContinue')).name
                        } catch {
                            Write-Error "Failed to get the container name for ID $n. $_"
                            $containerName = '## FailedToGetContainerName ##'
                        }
                    }
                    Write-Verbose "Performing action [ $Action ] on Container [ ID: $n, Name: $containerName ]"

                    $runspace = [powershell]::Create().AddScript({
                            param ($method, $requestPath, $modulePath, $baseUri, $apiKey, $containerId)

                            Import-Module $modulePath
                            Add-DBPoolBaseURI -base_uri $baseUri
                            Add-DBPoolApiKey -apiKey $apiKey

                            $VerbosePreference = $VerbosePreference

                            try {
                                $requestResponse = Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -ErrorAction Stop
                                return [pscustomobject]@{
                                    Success     = $true
                                    StatusCode  = $requestResponse.StatusCode
                                    Content     = $requestResponse.Content
                                    ContainerId = $containerId
                                }
                            } catch {
                                return [pscustomobject]@{
                                    Success      = $false
                                    ErrorMessage = $_.Exception.Message
                                    ErrorDetails = $_.Exception.ToString()
                                    ContainerId  = $containerId
                                }
                            }
                        }).AddArgument($method).AddArgument($requestPath).AddArgument($modulePath).AddArgument($DBPool_Base_URI).AddArgument($DBPool_ApiKey).AddArgument($n)

                    $runspaceQueue.Enqueue([PSCustomObject]@{ Pipe = $runspace; ContainerId = $n; Status = $runspace.BeginInvoke(); StartTime = [datetime]::Now })
                }
            }

            # Initialize sleep control variables
            $sleepDuration = 1 # Initial sleep duration in seconds
            $i = 0 # Counter to track iterations
            $initialThreshold = 10 # Initial threshold to increase sleep duration
            $maxSleepDuration = 60 # Maximum sleep duration in seconds

            # Process results as they complete or timeout
            while ($runspaceQueue.Count -gt 0) {
                $task = $null
                while ($runspaceQueue.TryDequeue([ref]$task)) {
                    if ($task.Status.IsCompleted) {
                        $result = $task.Pipe.EndInvoke($task.Status)
                        $task.Pipe.Dispose()

                        if ($result.Success) {
                            $statusCode = $result.StatusCode
                            if ($statusCode -eq 204) {
                                Write-Information "Success: Invoking Action [ $Action ] on Container [ ID: $($result.ContainerId) ]."
                            } else {
                                Write-Error "Failed: Status $statusCode. Response: $($result.Content)"
                            }
                        } else {
                            Write-Error "$($result.ErrorMessage)"
                        }
                    } elseif ($TimeoutSeconds -gt 0 -and $(([datetime]::Now - $task.StartTime).TotalSeconds) -ge $TimeoutSeconds) {
                        Write-Error "Action [ $Action ] on Container [ ID: $($task.ContainerId) ] exceeded timeout of $TimeoutSeconds seconds."
                        $task.Pipe.Stop()
                        $task.Pipe.Dispose()
                    } else {
                        # If task has neither completed nor timed out, re-enqueue it
                        $runspaceQueue.Enqueue($task)
                    }
                }

                Start-Sleep -Seconds $sleepDuration

                # Increment the counter
                $i++

                # Check if the counter has reached the dynamic threshold
                if ($i -ge $threshold) {
                    # Increase the sleep duration exponentially
                    $sleepDuration = [math]::Min($sleepDuration * 2, $maxSleepDuration)
                    # Increase the threshold linearly
                    $threshold += $initialThreshold
                    # Reset the counter
                    $i = 0
                }
            }

        }

    }

    end {

        # Close and dispose of the runspace pool
        if (!$supportsParallel) {
            $runspacePool.Close()
            $runspacePool.Dispose()
        }

    }

}
#EndRegion

#Region
function Invoke-DBPoolDebug {
<#
    .SYNOPSIS
        Provides an example exception response from the DBPool API for debugging purposes.

    .DESCRIPTION
        Uses the Invoke-DBPoolRequest function to make a request to the DBPool API.
        Returns an example exception response for debugging and testing purposes.

    .PARAMETER method
        The HTTP method to use when making the request to the DBPool API.
        Default is 'GET'.

    .INPUTS
        N/A

    .OUTPUTS
        [System.Management.Automation.ErrorRecord] - Returns an example exception response from the DBPool API.

    .EXAMPLE
        Invoke-DBPoolDebug -method GET

        Sends a 'GET' request to the DBPool API and returns a '418' exception response error.

    .NOTES
        N/A

    .LINK
        N/A

#>

    [CmdletBinding()]
    [OutputType([System.Management.Automation.ErrorRecord])]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateSet('DELETE', 'GET', 'PATCH', 'POST')]
        [string]$method = 'GET'
    )

    begin {
        $requestPath = '/api/docs/error'
    }

    process {

        Write-Debug "Invoking DBPool Debug Exception API with method [ $method ]"

        try {
            $response = Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -ErrorAction Stop
        } catch {
            Write-Error $_
        }

        if ($null -ne $response) {
                $response = $response | ConvertFrom-Json
            }

        # Return the response
        $response

    }

    end {}
}
#EndRegion

#Region
function Get-DBPoolOpenAPI {
<#
    .SYNOPSIS
        Gets the DBPool OpenAPI documentation.

    .DESCRIPTION
        Gets the OpenAPI json spec for the DBPool API documentation.

    .PARAMETER OpenAPI_Path
        The path to the OpenAPI json spec.
        This defaults to '/api/docs/openapi.json'

    .INPUTS
        N/A

    .OUTPUTS
        [PSCustomObject] - The OpenAPI json spec for the DBPool API documentation.

    .EXAMPLE
        Get-DBPoolOpenAPI

        This will get the OpenAPI json spec for the DBPool API documentation.

    .NOTES
        N/A

    .LINK
        N/A
#>


    [CmdletBinding()]
    [Alias("Get-DBPoolApiSpec", "Get-DBPoolSwagger")]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Mandatory = $false)]
        [string]$OpenAPI_Path = '/api/docs/openapi.json'
    )

    begin {
        $requestPath = $OpenAPI_Path
    }

    process {

        try {
            $response = Invoke-DBPoolRequest -Method Get -resource_Uri $requestPath -ErrorAction Stop -WarningAction SilentlyContinue
        }
        catch {
            Write-Error $_
        }

        if ($null -ne $response) {
            $response = $response | ConvertFrom-Json
        }

        # Return the response
        $response

    }

    end {}
}
#EndRegion

#Region
function Get-DBPoolUser {
<#
    .SYNOPSIS
        Get a user from DBPool

    .DESCRIPTION
        The Get-DBPoolUser function is used to get a user details from DBPool.
        Default will get the current authenticated user details, but can be used to get any user details by username.

    .PARAMETER username
        The username of the user to get details for.
        This accepts an array of strings.

    .INPUTS
        [string] - The username of the user to get details for.

    .OUTPUTS
        [PSCustomObject] - The user details from DBPool.

    .EXAMPLE
        Get-DBPoolUser

        This will get the user details for the current authenticated user.

    .EXAMPLE
        Get-DBPoolUser -username "John.Doe"

        This will get the user details for the user "John.Doe".

    .NOTES
        N/A

    .LINK
        N/A

#>


    [CmdletBinding(DefaultParameterSetName = 'Self')]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(ParameterSetName = 'User', Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Username
    )

    begin {
        $method = 'GET'
    }

    process {

        if ($null -eq $Username -or $Username.Count -eq 0) {
            Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameter set"

            try {
                $response = Invoke-DBPoolRequest -Method $method -resource_Uri '/api/v2/self' -ErrorAction Stop
            }
            catch {
                Write-Error $_
            }

            if ($null -ne $response) {
                    $response = $response | ConvertFrom-Json
                }
        } else {
            $response = foreach ($uName in $Username) {
                $requestResponse = $null
                Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameter set for Username $uName"
                $requestPath = "/api/v2/users/$uName"

                try {
                    $requestResponse = Invoke-DBPoolRequest -Method $method -resource_Uri $requestPath -ErrorAction Stop
                }
                catch {
                    Write-Error $_
                }

                if ($null -ne $requestResponse) {
                    $requestResponse | ConvertFrom-Json
                }
            }
        }

        # Return the response
        $response

    }

    end {}
}
#EndRegion

#Region
# Used to auto load either baseline settings or saved configurations when the module is imported
Import-DBPoolModuleSetting -Verbose:$false
#EndRegion
