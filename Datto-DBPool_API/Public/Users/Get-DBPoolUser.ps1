function Get-DBPoolUser {
<#
    .SYNOPSIS
        Get a user from DBPool

    .DESCRIPTION
        The Get-DBPoolUser function is used to get a user details from DBPool.
        Default will get the current authenticated user details, but can be used to get any user details by username.

    .PARAMETER username
        The username of the user to get details for.

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
        [string]$Username
    )
    
    begin {

        $requestPath = if ($Username) { "/api/v2/users/$Username" } else { '/api/v2/self' }

    }
    
    process {

        Invoke-DBPoolRequest -Method GET -resource_Uri $requestPath

    }
    
    end {}
}