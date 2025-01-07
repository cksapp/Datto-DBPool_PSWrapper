function Get-DBPoolUser {
<#
    .SYNOPSIS
        Get a user from DBPool

    .DESCRIPTION
        The Get-DBPoolUser function is used to get a user details from DBPool.
        Will retrieve the current authenticated user details, but can also be used to get other user details by username.

    .PARAMETER PlainTextAPIKey
        This switch will return the API Key in plain text.
        By default, the API Key is returned as a SecureString.

    .PARAMETER Username
        The username of the user to get details for.
        This accepts an array of strings.

    .INPUTS
        [string] - The username of the user to get details for.

    .OUTPUTS
        [PSCustomObject] - The user details from DBPool.

    .EXAMPLE
        Get-DBPoolUser

        This will get the user details for the current authenticated user.

        ----------------------------------------------------------------

        id          : 1234
        username    : john.doe
        displayName : John Doe
        email       : John.Doe@company.tld
        apiKey      : System.Security.SecureString

    .EXAMPLE
        Get-DBPoolUser -username "John.Doe"

        This will get the user details for the user "John.Doe".

        ----------------------------------------------------------------

        id username  displayName email
        -- --------  ----------- -----
        1234 john.doe John Doe   John.Doe@company.tld

    .NOTES
        Equivalent API endpoint:
            - GET /api/v2/self
            - GET /api/v2/users/{username}

    .LINK
        https://datto-dbpool-api.kentsapp.com/Users/Get-DBPoolUser/

#>

    [CmdletBinding(DefaultParameterSetName = 'Self')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')] # PSScriptAnalyzer - ignore creation of a SecureString using plain text rule for function
    [OutputType([PSCustomObject])]
    param (
        [Parameter(ParameterSetName = 'Self', Position = 0)]
        [switch]$PlainTextAPIKey,

        [Parameter(ParameterSetName = 'User', Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Username
    )

    begin {
        $method = 'GET'
    }

    process {

        if ($PSCmdlet.ParameterSetName -eq 'Self') {
            Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameter set"

            try {
                $response = Invoke-DBPoolRequest -Method $method -resource_Uri '/api/v2/self' -ErrorAction Stop
                if ($null -ne $response) {
                    $response = $response | ConvertFrom-Json
                    if ($response.ApiKey -and -not $PlainTextAPIKey) {
                        $response.ApiKey = $response.ApiKey | ConvertTo-SecureString -AsPlainText -Force
                    }
                    $response
                }
            }
            catch {
                Write-Error $_
            }

        } else {
            foreach ($uName in $Username) {
                $requestResponse = $null
                Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameter set for Username $uName"
                $requestPath = "/api/v2/users/$uName"

                try {
                    $requestResponse = Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -ErrorAction Stop
                    if ($null -ne $requestResponse) {
                        $requestResponse | ConvertFrom-Json | Write-Output
                    }
                } catch {
                    Write-Error $_
                }
            }
        }

    }

    end {

        Remove-Variable -Name response -Force -ErrorAction SilentlyContinue

    }
}
