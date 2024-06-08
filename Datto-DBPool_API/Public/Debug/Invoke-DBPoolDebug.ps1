function Invoke-DBPoolDebug {
<#
    .SYNOPSIS
        Provides an example exception response from the DBPool for debugging purposes.

    .DESCRIPTION
        Uses the Invoke-DBPoolRequest function to make a request to the DBPool API.
        Returns an example exception response for debugging and testing purposes.

    .EXAMPLE
        Invoke-DBPoolDebug -method GET
        Sends a 'GET' request to the DBPool API and returns a '418' exception response error.

    .NOTES
        N/A

    .LINK
        N/A

#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateSet('DELETE', 'GET', 'PATCH', 'POST')]
        [string]$method = 'GET'
    )
    
    begin {
        $requestPath = '/api/docs/error'
    }
    
    process {

        Invoke-DBPoolRequest -method $method -resource_Uri $requestPath

    }
    
    end {}
}