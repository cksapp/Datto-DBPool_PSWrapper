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


    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Username
    )
    
    begin {
        $method = 'GET'
    }
    
    process {

        if ($null -eq $Username -or $Username.Count -eq 0) {
            Invoke-DBPoolRequest -Method $method -resource_Uri '/api/v2/self'
        } else {
            foreach ($user in $Username) {
                $requestPath = "/api/v2/users/$user"
                Invoke-DBPoolRequest -Method $method -resource_Uri $requestPath
            }
        }

    }
    
    end {}
}