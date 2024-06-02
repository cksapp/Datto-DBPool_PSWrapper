function Test-ApiAvailability {
<#
    .SYNOPSIS
    Checks the availability of an API using a HEAD request.

    .DESCRIPTION
    This function sends an HTTP HEAD request to the specified API URL using Invoke-WebRequest
    and checks if the HTTP status code is 200, indicating that the API is available.

    .PARAMETER apiUrl
    The URL of the API to be checked.

    .PARAMETER ApiKey
    Optional: Access token for authorization.

    .EXAMPLE
    Test-ApiAvailability -apiUrl "https://api.example.com" -ApiKey "your_access_token"
#>

    [CmdletBinding()]
    [OutputType([System.Boolean], ParameterSetName = "API Available")]
    param (
        <#[Parameter( 
            Position = 0, 
            Mandatory = $False, 
            ValueFromPipeline = $True, 
            ValueFromPipelineByPropertyName = $True, 
            HelpMessage="The URL of the API to be checked."
        )]
        [string]$DBPool_Base_URI = $global:DBPool_Base_URI,

        [Parameter( 
            Position = 1, 
            Mandatory = $False,
            ValueFromPipeline = $True, 
            ValueFromPipelineByPropertyName = $True, 
            HelpMessage="API Key for authorization."
        )]
        [string]$DBPool_ApiKey = $global:DBPool_ApiKey#>
    )

    begin {
        # Check if API Parameters are set
        Write-Verbose -Message "Api URL is $DBPool_Base_URI"
        Write-Verbose -Message "Api Key is $DBPool_ApiKey"
        if (!($DBPool_Base_URI -and $DBPool_ApiKey)) {
            Write-Output "API Parameters missing, please run Set-DBPoolApiParameters first!"
            break
        }

        # Sets the variable for the document URI to check, filtered to replace ending with /v2 with openapi docs
        #$DBPool_Base_URI = $DBPool_Base_URI -replace '/v2$', '/docs/openapi.json'
    }

    process {

        Write-Verbose -Message "Checking API availability for URL $DBPool_Base_URI"
        try {

            $Response = Invoke-DBPoolRequest -method 'HEAD' -resource_Uri '/api/docs/openapi.json'
            return $true

        } catch {
            if ($null -ne $_.Exception.Response -and $_.Exception.Response.StatusCode -eq 404) {
                Write-Error -Message "Error 404: Page not found.`nPlease check your parameters and try again."
            } <#elseif ($null -ne $_.Exception.Response -and $_.Exception.Contains("No such host is known")) {
                Write-Error "Error: No such host is known.`nPlease check your connection, VPN, and try again."
            }#> else {
                #Write-Error $_.Exception
                Write-Error $_.Exception.Message
            }

            return $false
        }
    }

    end {
        # Return the apiUrl variable without the openAPI docs URI
        $DBPool_Base_URI = $DBPool_Base_URI -replace 'api/docs/openapi.json', ''
        Set-Variable -name apiUrl -value $DBPool_Base_URI -Force -Scope global
    }


}
