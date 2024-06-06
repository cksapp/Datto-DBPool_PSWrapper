function Get-DBPoolOpenAPI {
<#
    .SYNOPSIS
        Gets the DBPool OpenAPI documentation.

    .DESCRIPTION
        Gets the OpenAPI json spec for the DBPool API documentation.

    .NOTES
        N/A

    .LINK
        N/A

    .EXAMPLE
        Get-DBPoolOpenAPI
        This will get the OpenAPI json spec for the DBPool API documentation.
#>


    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $requestPath = '/api/docs/openapi.json'
    }
    
    process {
        Invoke-DBPoolRequest -Method Get -resource_Uri $requestPath
    }
    
    end {}
}