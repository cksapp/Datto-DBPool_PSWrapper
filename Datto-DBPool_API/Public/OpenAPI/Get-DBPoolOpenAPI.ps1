function Get-DBPoolOpenAPI {
<#
    .SYNOPSIS
        Gets the DBPool OpenAPI documentation.

    .DESCRIPTION
        Gets the OpenAPI json spec for the DBPool API documentation.

    .PARAMETER OpenAPI_Path
        The path to the OpenAPI json spec.
        This defaults to '/api/docs/openapi.json'
    
    .EXAMPLE
        Get-DBPoolOpenAPI

        This will get the OpenAPI json spec for the DBPool API documentation.

    .NOTES
        N/A

    .LINK
        N/A
#>


    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$OpenAPI_Path = '/api/docs/openapi.json'
    )
    
    begin {
        $requestPath = $OpenAPI_Path
    }
    
    process {

        try {
            $response = Invoke-DBPoolRequest -Method Get -resource_Uri $requestPath -ErrorAction Stop
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