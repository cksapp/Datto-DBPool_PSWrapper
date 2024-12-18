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
