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
                $response = $response | ConvertFrom-Json | ForEach-Object {
                    [DBPoolAuthUser]::new($_.id, $_.username, $_.displayName, $_.email, $( $_.apiKey | ConvertTo-SecureString -AsPlainText -Force ))
                }
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
                    $requestResponse | ConvertFrom-Json | ForEach-Object {
                        $user = [DBPoolUser]::new($_.id, $_.username, $_.displayName, $_.email)
                        $user
                    }
                }
            }
        }

        # Return the response
        $response

    }
    
    end {}
}