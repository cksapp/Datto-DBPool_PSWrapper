function Invoke-DBPoolContainerAccess {
<#
    .SYNOPSIS
        The Invoke-DBPoolContainerAccess function is used to interact with various container access operations in the Datto DBPool API.

    .DESCRIPTION
        The Invoke-DBPoolContainerAccess function is used to Get, Add, or Remove access to a container in the Datto DBPool API based on a given username.

    .PARAMETER Id
        The ID of the container to access.
        This accepts an array of integers.

    .PARAMETER Username
        The username to access the container.
        This accepts an array of strings.

    .PARAMETER GetAccess
        Gets the current access to a container by ID for the given username.

    .PARAMETER AddAccess
        Adds access to a container by ID for the given username.

    .PARAMETER RemoveAccess
        Removes access to a container by ID for the given username.

    .INPUTS
        [int] - The ID of the container to access.
        [string] - The username to access the container.

    .OUTPUTS
        [PSCustomObject] - The response from the DBPool API.
        [void] - No output is returned.

    .EXAMPLE
        Invoke-DBPoolContainerAccess -Id '12345' -Username 'John.Doe'
        Invoke-DBPoolContainerAccess -Id '12345' -Username 'John.Doe' -GetAccess

        This will get access to the container with ID 12345 for the user "John.Doe"

    .EXAMPLE
        Invoke-DBPoolContainerAccess -Id @( '12345', '56789' ) -Username 'John.Doe' -AddAccess

        This will add access to the containers with ID 12345, and 56789 for the user "John.Doe"

    .EXAMPLE
        Invoke-DBPoolContainerAccess -Id '12345' -Username @( 'Jane.Doe', 'John.Doe' ) -RemoveAccess

        This will remove access to the container with ID 12345 for the users "Jane.Doe", and "John.Doe"

    .NOTES
        Equivalent API endpoint:
            - GET /api/v2/containers/{id}/access/{username}
            - PUT /api/v2/containers/{id}/access/{username}
            - DELETE /api/v2/containers/{id}/access/{username}

    .LINK
        https://datto-dbpool-api.kentsapp.com/Containers/access/Invoke-DBPoolContainerAccess/
#>

    [CmdletBinding(DefaultParameterSetName = 'GetAccess', SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    [OutputType([PSCustomObject], ParameterSetName = { 'GetAccess', 'AddAccess' })]
    [OutputType([void], ParameterSetName = 'RemoveAccess')]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        #[ValidateRange(1, [int]::MaxValue)]
        [Alias('ContainerId')]
        [int[]]$Id,

        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'GetAccess', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'AddAccess', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'RemoveAccess', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Username,

        [Parameter(Mandatory = $false, ParameterSetName = 'GetAccess')]
        [Switch]$GetAccess,

        [Parameter(Mandatory = $false, ParameterSetName = 'AddAccess')]
        [Switch]$AddAccess,

        [Parameter(Mandatory = $false, ParameterSetName = 'RemoveAccess')]
        [Switch]$RemoveAccess
    )

    begin {

        # Pass the InformationAction parameter if bound, default to 'Continue'
        if ($PSBoundParameters.ContainsKey('InformationAction')) {
            $InformationPreference = $PSBoundParameters['InformationAction']
        } else {
            $InformationPreference = 'Continue'
        }

    }

    process {

        $response = foreach ($n in $Id) {
            foreach ($uName in $Username) {
                $requestPath = "/api/v2/containers/$n/access/$uName"
                $method = $null
                $requestResponse = $null
                $responseContent = $null

                switch ($PSCmdlet.ParameterSetName) {
                    'GetAccess' {
                        $method = 'GET'
                    }
                    'AddAccess' {
                        if ($PSCmdlet.ShouldProcess("[ $uName ] for Container [ ID: $n ]", "[ $($PSCmdlet.ParameterSetName) ]")) {
                            $method = 'PUT'
                        }
                    }
                    'RemoveAccess' {
                        if ($PSCmdlet.ShouldProcess("[ $uName ] for Container [ ID: $n ]", "[ $($PSCmdlet.ParameterSetName) ]")) {
                            $method = 'DELETE'
                        }
                    }
                }

                if ($method) {

                    try {
                        $requestResponse = Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -ErrorAction Stop
                    }
                    catch {
                        $requestResponse = $null
                        Write-Error $_
                    }

                    if ($null -ne $requestResponse) {
                            $responseContent = $requestResponse.Content | ConvertFrom-Json
                        }

                    switch ($PSCmdlet.ParameterSetName) {
                                'GetAccess' {
                                    $responseContent
                                }
                                'AddAccess' {
                                    if ($requestResponse.StatusCode -eq 200) {
                                        Write-Information "User access on Container [ ID: $n ] already exists for [ $uName ]"
                                    } elseif ($requestResponse.StatusCode -eq 201) {
                                        Write-Information "User access on Container [ ID: $n ] successfully created for [ $uName ]"
                                    }
                                    $responseContent
                                }
                                'RemoveAccess' {
                                    if ($requestResponse.StatusCode -eq 204) {
                                        Write-Information "User access on Container [ ID: $n ] successfully removed for [ $uName ]"
                                    }
                                    $responseContent
                                }
                            }
                }
            }
        }

        # Return the responses
        $response

    }

    end {}

}
