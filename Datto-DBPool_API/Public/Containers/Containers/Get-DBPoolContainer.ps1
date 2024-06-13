function Get-DBPoolContainer {
<#
    .SYNOPSIS
        The Get-DBPoolContainer function retrieves container information from the DBPool API.

    .DESCRIPTION
        This function retrieves container details from the DBPool API.
        It can get containers, parent containers, or child containers, and also retrieve containers by ID and also filter by container name.

    .PARAMETER Id
        The ID of the container to get. This parameter is required when using the ParentContainer or ChildContainer parameter sets.

    .PARAMETER status
        Gets the status of a container by ID.
        Returns basic container details, and dockerContainerRunning, mysqlServiceResponding, and mysqlServiceRespondingCached statuses.

    .PARAMETER ListContainer
        Retrieves a list of containers from the DBPool API. This is the default parameter set.

    .PARAMETER ParentContainer
        Retrieves a list of parent containers from the DBPool API.

    .PARAMETER ChildContainer
        Retrieves a list of child containers from the DBPool API.

    .PARAMETER Name
        Filters containers returned from the DBPool API by name.
        Accepts '*' for wildcard input.

    .PARAMETER DefaultDatabase
        Filters containers returned from the DBPool API by database.
        Accepts '*' for wildcard input.

    .EXAMPLE
        Get-DBPoolContainer
        Get-DBPoolContainer -Id 12345

        Get a list of containers from the DBPool API, or by ID

    .EXAMPLE
        Get-DBPoolContainer -status
        Get-DBPoolContainer -status -Id 12345

        Get the status of a container by ID

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

    .EXAMPLE
        Get-DBPoolContainer -DefaultDatabase 'Database'
        Get-DBPoolContainer -ParentContainer -DefaultDatabase '*Database*'

        Get a list of containers from the DBPool API, or parent containers by database
        Accepts '*' for wildcard input
    .NOTES
        The '-Name', and -DefaultDatabase parameters are not native endpoints of the DBPool API.
        This is a custom method which uses 'Where-Object' to filter the response with the provided filter.
        If no match is found, the original response is returned.

    .LINK
        N/A
#>

    [CmdletBinding(DefaultParameterSetName = 'ListContainer')]
    param (
        [Parameter(ParameterSetName = 'ParentContainer', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ListContainer', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ContainerStatus', Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        #[ValidateRange(0, [int]::MaxValue)]
        [int[]]$Id,

        [Parameter(ParameterSetName = 'ListContainer')]
        [switch]$ListContainer,

        [Parameter(ParameterSetName = 'ParentContainer')]
        [switch]$ParentContainer,

        [Parameter(ParameterSetName = 'ChildContainer')]
        [switch]$ChildContainer,

        [Parameter(ParameterSetName = 'ContainerStatus')]
        [switch]$Status,

        [Parameter(ParameterSetName = 'ListContainer', ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ParentContainer', ValueFromPipelineByPropertyName = $true)]
        [string]$Name,

        [Parameter(ParameterSetName = 'ListContainer', ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ParentContainer', ValueFromPipelineByPropertyName = $true)]
        [Alias('Database')]
        [string]$DefaultDatabase
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
            'ContainerStatus' {
                $requestPath = '/api/v2/containers'
            }
        }

        # Internal Function to filter the response by Container Name or DefaultDatabase if provided
        function Select-DBPoolContainers {
            param(
                [Parameter(Mandatory = $true)]
                [PSObject]$Container,

                [Parameter(Mandatory = $false)]
                [string]$Name,

                [Parameter(Mandatory = $false)]
                [string]$DefaultDatabase,

                [Parameter(Mandatory = $false)]
                [int[]]$Id,

                [Parameter(Mandatory = $true)]
                [string]$ParameterSetName
            )

            $originalContainer = $Container

            if ($Name) {
                Write-Verbose "Filtering the response by name [ $Name ]"
                $Filter = 'Name'
                $filterParameter = $Name
            }
            if ($DefaultDatabase) {
                Write-Verbose "Filtering the response by database [ $DefaultDatabase ]"
                $Filter = 'DefaultDatabase'
                $filterParameter = $DefaultDatabase
            }

            $filterKey = switch ($ParameterSetName) {
                'ListContainer' {
                    'containers' 
                }
                'ParentContainer' {
                    'parents' 
                }
            }

            if ($Id) {
                $Container = $Container | Where-Object {
                    ($Name -and $_.name -like $Name) -or
                    ($DefaultDatabase -and $_.defaultDatabase -like $DefaultDatabase)
                }
            } else {
                $Container = $($Container.$filterKey) | Where-Object {
                    ($Name -and $_.name -like $Name) -or
                    ($DefaultDatabase -and $_.defaultDatabase -like $DefaultDatabase)
                }
            }

            if (!$Container) {
                Write-Error "No container found matching the [ $Filter ] filter parameter [ $filterParameter ] returning all fetched containers."
                $Container = $originalContainer
            }

            $Container
        }

    }

    process {

        if ($PSBoundParameters.ContainsKey('Id')) {
            $response = foreach ($n in $Id) {
                $requestResponse = $null
                Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameter set for ID $n"

                # Define the ContainerStatus parameter request path if set
                $uri = "$requestPath/$n"
                if ($Status) {
                    Write-Verbose "Getting the status of container ID $n"
                    $uri += '/status'
                }

                try {
                    $requestResponse = Invoke-DBPoolRequest -method $method -resource_Uri $uri -ErrorAction Stop
                }
                catch {
                    Write-Error $_
                    continue
                }

                if ($null -ne $requestResponse) {
                    $requestResponse | ConvertFrom-Json
                }
            }
        } else {
            Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameter set"

            try {
                $requestResponse = Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -ErrorAction Stop
            }
            catch {
                Write-Error $_
            }

            if ($null -ne $requestResponse) {
                $response = $requestResponse | ConvertFrom-Json
            }
        }

        # Filter the response by name or DefaultDatabase if provided
        if ($PSBoundParameters.ContainsKey('Name') -or $PSBoundParameters.ContainsKey('DefaultDatabase')) {
            try {
                $response = Select-DBPoolContainers -Container $response -Name $Name -DefaultDatabase $DefaultDatabase -Id $Id -ParameterSetName $PSCmdlet.ParameterSetName -ErrorAction Stop
            }
            catch {
                Write-Warning $_
            }
        }

        # Return the response
        $response

    }

    end {}

}