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

    .EXAMPLE
        Test-DBPoolApi -base_uri "https://api.example.com" -resource_Uri "/api/docs"

        Checks the availability of the API at https://api.example.com/api/docs

    .NOTES
        N/A

    .LINK
        https://datto-dbpool-api.kentsapp.com/Internal/Test-DBPoolApi/
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
            Write-Warning "API parameters are missing. Please run 'Set-DBPoolApiParameter' first!"
        }

        # Use 'Add-DBPoolBaseURI' to remove superfluous trailing slashes
        Add-DBPoolBaseURI -base_uri $base_uri -Verbose:$false

    }

    process {

        Write-Verbose -Message "Checking Uri: [ $($base_uri + $resource_Uri) ]"
        try {
            Invoke-DBPoolRequest -Method 'HEAD' -resource_Uri $resource_Uri -ErrorAction Stop -Verbose:$false | Out-Null
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
