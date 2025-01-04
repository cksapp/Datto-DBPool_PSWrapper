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
        Equivalent API endpoint:
            - GET /api/docs/openapi.json

    .LINK
        https://datto-dbpool-api.kentsapp.com/OpenAPI/Get-DBPoolOpenAPI/
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
            $response = Invoke-DBPoolRequest -method Get -resource_Uri $requestPath -WarningAction SilentlyContinue -ErrorAction Stop
            if ($null -ne $response) {
                $response | ConvertFrom-Json -ErrorAction Stop
            }
        } catch {
            Write-Error $_
        }

    }

    end {}
}
