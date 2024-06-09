function Get-DBPoolContainer {
<#
    .SYNOPSIS
        The Get-DBPoolContainer function retrieves container information from the DBPool API.

    .DESCRIPTION
        This function retrieves container details from the DBPool API.
        It can get containers, parent containers, or child containers, and also retrieve containers by ID and also filter by container name.

    .PARAMETER Id
        The ID of the container to get. This parameter is required when using the ParentContainer or ChildContainer parameter sets.

    .PARAMETER ListContainer
        Retrieves a list of containers from the DBPool API. This is the default parameter set.

    .PARAMETER ParentContainer
        Retrieves a list of parent containers from the DBPool API.

    .PARAMETER ChildContainer
        Retrieves a list of child containers from the DBPool API.

    .PARAMETER Name
        Filters containers returned from the DBPool API by name.
        Accepts '*' for wildcard input.

    .EXAMPLE
        Get-DBPoolContainer
        Get-DBPoolContainer -Id 12345

        Get a list of containers from the DBPool API, or by ID

    .EXAMPLE
        Get-DBPoolContainer -ParentContainer
        Get-DBPoolContainer -ParentContainer -Id 12345

        Get a list of parent containers from the DBPool API, or by ID

    .EXAMPLE
        Get-DBPoolContainer -ChildContainer

        Get a list of child containers from the DBPool API

    .EXAMPLE
        Get-DBPoolContainer -Name 'MyContainer'
        Get-DBPoolContainer -ParentContainer -Name '*ParentContainer*'

        Get a list of containers from the DBPool API, or parent containers by name
        Accepts '*' for wildcard input

    .NOTES
        The '-Name' parameter is not a native endpoint of the DBPool API.
        This is a custom method which uses 'Where-Object' to filter the response with the provided name.
        If no match is found, the original response is returned.

    .LINK
        N/A
#>

    [CmdletBinding(DefaultParameterSetName = 'ListContainer')]
    param (
        [Parameter(ParameterSetName = 'ParentContainer', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ListContainer', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        #[ValidateRange(0, [int]::MaxValue)]
        [int[]]$Id,

        [Parameter(ParameterSetName = 'ListContainer')]
        [switch]$ListContainer,

        [Parameter(ParameterSetName = 'ParentContainer')]
        [switch]$ParentContainer,

        [Parameter(ParameterSetName = 'ChildContainer')]
        [switch]$ChildContainer,

        [Parameter(ParameterSetName = 'ListContainer')]
        [Parameter(ParameterSetName = 'ParentContainer')]
        [string]$Name
    )

    begin {

        $method = 'GET'
        switch ($PSCmdlet.ParameterSetName) {
            'ListContainer' {
                $requestPath = '/api/v2/containers'
            }
            'ParentContainer' {
                $requestPath = '/api/v2/parents'
            }
            'ChildContainer' {
                $requestPath = '/api/v2/children'
            }
        }

    }

    process {

        if ($PSBoundParameters.ContainsKey('Id')) {
            $response = foreach ($n in $Id) {
                Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameter set for ID $n"
                $requestResponse = Invoke-DBPoolRequest -method $method -resource_Uri "$requestPath/$n"
                if ($null -ne $requestResponse) {
                    $requestResponse | ConvertFrom-Json
                }
            }
        } else {
            Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameter set"
            $requestResponse = Invoke-DBPoolRequest -method $method -resource_Uri $requestPath
            if ($null -ne $requestResponse) {
                $response = $requestResponse | ConvertFrom-Json
            }
        }

        # Filter the response by name if provided
        if ($PSBoundParameters.ContainsKey('Name')) {
            $originalResponse = $response

            Write-Verbose "Filtering the response by name [ $Name ]"

            $filterKey = switch ($PSCmdlet.ParameterSetName) {
                'ListContainer' {
                    'containers' 
                }
                'ParentContainer' {
                    'parents' 
                }
            }

            if ($PSBoundParameters.ContainsKey('Id')) {
                $response = $response | Where-Object { $_.name -like $Name }
            } else {
                $response = $($response.$filterKey) | Where-Object { $_.name -like $Name }
            }

            if (!$response) {
                Write-Error "No container found matching the name [ $Name ] returning fetched containers."
                $response = $originalResponse
            }
        }

        # Return the response
        $response

    }

    end {}

}