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
        Equivalent API endpoint:
            - GET /api/docs/error
            - PATCH /api/docs/error
            - POST /api/docs/error
            - PUT /api/docs/error
            - DELETE /api/docs/error

    .LINK
        https://datto-dbpool-api.kentsapp.com/Debug/Invoke-DBPoolDebug/

#>

    [CmdletBinding()]
    [OutputType([System.Management.Automation.ErrorRecord])]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateSet('DELETE', 'GET', 'PATCH', 'POST' , 'PUT')]
        [string]$method = 'GET'
    )

    begin {
        $requestPath = '/api/docs/error'
    }

    process {

        Write-Debug "Invoking DBPool Debug Exception API with method [ $method ]"

        try {
            $response = Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -ErrorAction Stop
            if ($null -ne $response) {
                $response | ConvertFrom-Json -ErrorAction Stop
            }
        } catch {
            Write-Error $_
        }

    }

    end {}
}
