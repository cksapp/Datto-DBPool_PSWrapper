function Get-DBPoolContainer {
    <#
    .SYNOPSIS
        The Get-DBPoolContainer function retrieves container information from the DBPool API.

    .DESCRIPTION
        This function retrieves container details from the DBPool API.

        It can get containers, parent containers, or child containers, and also retrieve containers or container status by ID.
        This also can filter by container name or database.

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

    .PARAMETER NotLike
        Filters containers returned from the DBPool API by name or DefaultDatabase using the -NotLike switch.
        Requires the -Name or -DefaultDatabase parameter to be specified.

        Returns containers where the name or DefaultDatabase does not match the provided filter.

    .EXAMPLE
        Get-DBPoolContainer

        Get a list of all containers from the DBPool API

    .EXAMPLE
        Get-DBPoolContainer -Id 12345

        Get a list of containers from the DBPool API by ID

    .EXAMPLE
        Get-DBPoolContainer -Status -Id @( 12345, 67890 )

        Get the status of an array of containers by IDs

    .EXAMPLE
        Get-DBPoolContainer -ParentContainer

        Get a list of parent containers from the DBPool API

    .EXAMPLE
        Get-DBPoolContainer -ParentContainer -Id 12345

        Get a list of parent containers from the DBPool API by ID

    .EXAMPLE
        Get-DBPoolContainer -ChildContainer

        Get a list of child containers from the DBPool API

    .EXAMPLE
        Get-DBPoolContainer -Name 'MyContainer'
        Get-DBPoolContainer -ParentContainer -Name '*ParentContainer*'

        Get a list of containers from the DBPool API, or parent containers by name
        Accepts '*' for wildcard input

    .EXAMPLE
        Get-DBPoolContainer -Name 'MyContainer' -NotLike
        Get-DBPoolContainer -ParentContainer -Name '*ParentContainer*' -NotLike

        Get a list of containers from the DBPool API, or parent containers where the name does not match the filter
        Accepts '*' for wildcard input

    .EXAMPLE
        Get-DBPoolContainer -DefaultDatabase 'Database'
        Get-DBPoolContainer -ParentContainer -DefaultDatabase '*Database*'

        Get a list of containers from the DBPool API, or parent containers by database
        Accepts '*' for wildcard input

    .EXAMPLE
        Get-DBPoolContainer -DefaultDatabase 'Database' -NotLike
        Get-DBPoolContainer -ParentContainer -DefaultDatabase '*Database*' -NotLike

        Get a list of containers from the DBPool API, or parent containers where the database does not match the filter
        Accepts '*' for wildcard input

    .NOTES
        The '-Name', and -DefaultDatabase parameters are not native endpoints of the DBPool API.
        This is a custom function which uses 'Where-Object', along with the optional '-NotLike' parameter to return the response using the provided filter.
        
        If no match is found an error is thrown, and the original response is returned.

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
        [string]$DefaultDatabase,

        [Parameter(ParameterSetName = 'ListContainer')]
        [Parameter(ParameterSetName = 'ParentContainer')]
        [switch]$NotLike
    )

    begin {

        $method = 'GET'
        switch ($PSCmdlet.ParameterSetName) {
            'ListContainer' { $requestPath = '/api/v2/containers' }
            'ParentContainer' { $requestPath = '/api/v2/parents' }
            'ChildContainer' { $requestPath = '/api/v2/children' }
            'ContainerStatus' { $requestPath = '/api/v2/containers' }
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
                [string]$ParameterSetName,

                [Parameter(Mandatory = $false)]
                [switch]$NotLike
            )

            $Filter = $null
            $filterParameter = $null

            if ($Name) {
                $Filter = 'Name'
                $filterParameter = $Name
            } elseif ($DefaultDatabase) {
                $Filter = 'DefaultDatabase'
                $filterParameter = $DefaultDatabase
            }

            # Write verbose output for filter parameters include or exclude
            if ($NotLike) {
                Write-Verbose "Excluding the response by $Filter [ $filterParameter ]"
            } else {
                Write-Verbose "Filtering the response by $Filter [ $filterParameter ]"
            }

            $Container = $Container | Where-Object {
                if ($NotLike) {
                    ($Name -and $_.name -notlike $Name) -or
                    ($DefaultDatabase -and $_.defaultDatabase -notlike $DefaultDatabase)
                } else {
                    ($Name -and $_.name -like $Name) -or
                    ($DefaultDatabase -and $_.defaultDatabase -like $DefaultDatabase)
                }
            }

            if (!$Container) {
                Write-Error "No container found matching the [ $Filter ] filter parameter [ $filterParameter ]. Returning all fetched containers." -ErrorAction Stop
            }

            # Return the container
            $Container

        }

        # Validate filter parameters for name or DefaultDatabase if -NotLike switch is used
        if ($PSCmdlet.ParameterSetName -eq 'ListContainer' -or $PSCmdlet.ParameterSetName -eq 'ParentContainer') {
            if ($NotLike -and -not ($Name -or $DefaultDatabase)) {
                Write-Error "The -NotLike switch requires either the -Name or -DefaultDatabase parameter to be specified." -ErrorAction Stop
            }
        }

    }

    process {

        # Get list of containers by ID
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
                } catch {
                    Write-Error $_
                    continue
                }

                if ($null -ne $requestResponse) {
                    $requestResponse | ConvertFrom-Json
                }
            }
        # Get list of containers based on the parameter set, returns 
        } else {
            Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameter set"

            try {
                $requestResponse = Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -ErrorAction Stop
            } catch {
                Write-Error $_
            }

            # Convert the response to JSON, return the response based on the parameter set
            if ($null -ne $requestResponse) {
                $response = $requestResponse | ConvertFrom-Json

                if ($PSCmdlet.ParameterSetName -eq 'ParentContainer') {
                    $response = $response.parents
                } elseif ($PSCmdlet.ParameterSetName -eq 'ListContainer') {
                    $response = $response.containers
                }
            }
        }


        # Filter the response by Name or DefaultDatabase if provided
        if ($PSBoundParameters.ContainsKey('Name') -or $PSBoundParameters.ContainsKey('DefaultDatabase')) {
            try {
                $response = Select-DBPoolContainers -Container $response -Name $Name -DefaultDatabase $DefaultDatabase -Id $Id -ParameterSetName $PSCmdlet.ParameterSetName -NotLike:$NotLike -ErrorAction Stop
            } catch {
                Write-Error $_
            }
        }

        # Return the response
        $response

    }

    end {}

}