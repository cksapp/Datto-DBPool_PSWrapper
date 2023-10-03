<#
.SYNOPSIS
   Checks the availability of an API using a HEAD request.

.DESCRIPTION
   This function sends a HEAD request to the specified API URL using Invoke-RestMethod
   and checks if the HTTP status code is 200, indicating that the API is available.

.PARAMETER ApiUrl
   The URL of the API to be checked.

.PARAMETER ApiKey
   Optional: Access token for authorization.

.EXAMPLE
   Test-ApiAvailability -ApiUrl "https://api.example.com" -ApiKey "your_access_token"
#>
function Test-ApiAvailability {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, HelpMessage="The URL of the API to be checked.")]
        [string]$ApiUrl,

        [Parameter(Mandatory=$true, Position=1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, HelpMessage="API Key for authorization.")]
        [string]$ApiKey
    )

# Check API Parameters
if (!$apiUrl -or !$apiKey) {
    Write-Host "API Parameters missing, please run Set-DdbpApiParameters first!"
    return
}

    try {
        $headers = @{
            "X-App-Apikey" = $ApiKey
        }

        $Response = Invoke-RestMethod -Uri $ApiUrl -Method Head -Headers $headers
        return $true
    } catch {
        if ($_.Exception.Response -ne $null -and $_.Exception.Response.StatusCode -eq 404) {
            Write-Error "Error 404: The webpage was not found.`nPlease make sure you are connected to the internal VPN."
        } else {
            Write-Error $_.Exception.Message
        }
        return $false
    }
}
