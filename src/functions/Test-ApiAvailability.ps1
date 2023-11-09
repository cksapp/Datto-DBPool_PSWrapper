<#
.SYNOPSIS
   Checks the availability of an API using a HEAD request.

.DESCRIPTION
   This function sends a HEAD request to the specified API URL using Invoke-RestMethod
   and checks if the HTTP status code is 200, indicating that the API is available.

.PARAMETER apiUrl
   The URL of the API to be checked.

.PARAMETER ApiKey
   Optional: Access token for authorization.

.EXAMPLE
   Test-ApiAvailability -apiUrl "https://api.example.com" -ApiKey "your_access_token"
#>
function Test-ApiAvailability {
    [CmdletBinding()]
    [OutputType([System.Boolean], ParameterSetName = "API Available")]
    param (
        [Parameter( 
            Position = 0, 
            Mandatory = $False, 
            ValueFromPipeline = $True, 
            ValueFromPipelineByPropertyName = $True, 
            HelpMessage="The URL of the API to be checked."
        )]
        [string]$apiUrl,

        [Parameter( 
            Position = 1, 
            Mandatory = $False,
            ValueFromPipeline = $True, 
            ValueFromPipelineByPropertyName = $True, 
            HelpMessage="API Key for authorization."
        )]
        [string]$apiKey
    )

    begin {
        # Check if API Parameters are set
        #Write-Verbose -Message "Api URL is $apiUrl"
        if (!($apiUrl) -or !($apiKey)) {
            Write-Output "API Parameters missing, please run Set-DdbpApiParameters first!"
            break
        }

        # Sets the variable for the document URI to check, filtered to replace ending with /v2 with openapi docs
        $apiUrl = $apiUrl -replace '/v2$', '/docs/openapi.json'
    }

    process {
        Write-Verbose -Message "Checking API availability for URL $apiUrl"
        try
        {
            <#$Response = Invoke-RestMethod -Uri $apiUrl -Method Head
            Write-Output "$Response"#>

            $Response = Invoke-WebRequest -Uri $apiUrl -Method Head
            Write-Output "$Response"

            return $true
        }
        catch
        {
            if ($null -ne $_.Exception.Response -and $_.Exception.Response.StatusCode -eq 404)
            {
                Write-Error -Message "Error 404: Page not found.`nPlease check your parameters and try again."
            }
            <#elseif ($null -ne $_.Exception.Response -and $_.Exception.Contains("No such host is known"))
            {
                Write-Error "Error: No such host is known.`nPlease check your connection, VPN, and try again."
            }#>
            else
            {
                #Write-Error $_.Exception
                Write-Error $_.Exception.Message
            }
            return $false
        }
    }

    end {
        # Return the apiUrl variable without the openAPI docs URI
        $apiUrl = $apiUrl -replace 'api/docs/openapi.json', ''
        Set-Variable -name apiUrl -value $apiUrl -Force -Scope global
    }


}
