function Get-DBPoolContainer {
    <#
    .SYNOPSIS
        The Get-DBPoolContainer function retrieves container information from the DBPool API.

    .DESCRIPTION
        This function retrieves container details from the DBPool API.

        It can get containers, parent containers, or child containers, and also retrieve containers or container status by ID.
        This also can filter or exclude by container name or database.

    .PARAMETER Id
        The ID of the container details to get from the DBPool.

    .PARAMETER Status
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
        Accepts wildcard input.

    .PARAMETER DefaultDatabase
        Filters containers returned from the DBPool API by database.
        Accepts wildcard input.

    .PARAMETER NotLike
        Excludes containers returned from the DBPool API by Name or DefaultDatabase using the -NotLike switch.
        Requires the -Name or -DefaultDatabase parameter to be specified.

        Returns containers where the Name or DefaultDatabase does not match the provided filter.

    .INPUTS
        [int] - Id
        The ID of the container to get details for.

        [string] Name
        The name of the container to get details for.

        [string] - DefaultDatabase
        The database of the container to get details for.

    .OUTPUTS
        [PSCustomObject] - The response from the DBPool API.

    .EXAMPLE
        Get-DBPoolContainer

        Get a list of all containers from the DBPool API

    .EXAMPLE
        Get-DBPoolContainer -Id 12345

        Get a list of containers from the DBPool API by ID

    .EXAMPLE
        Get-DBPoolContainer -Status

        Get the status of all containers from the DBPool API

    .EXAMPLE
        Get-DBPoolContainer -Status -Id 12345, 67890

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
        Get-DBPoolContainer -ParentContainer -Name 'ParentContainer*'

        Uses 'Where-Object' to get a list of containers from the DBPool API, or parent containers by name
        Accepts wildcard input

    .EXAMPLE
        Get-DBPoolContainer -Name 'MyContainer' -NotLike
        Get-DBPoolContainer -ParentContainer -Name 'ParentContainer*' -NotLike

        Uses 'Where-Object' to get a list of containers from the DBPool API, or parent containers where the name does not match the filter
        Accepts wildcard input

    .EXAMPLE
        Get-DBPoolContainer -DefaultDatabase 'Database'
        Get-DBPoolContainer -ParentContainer -DefaultDatabase 'Database*'

        Get a list of containers from the DBPool API, or parent containers by database
        Accepts wildcard input

    .EXAMPLE
        Get-DBPoolContainer -DefaultDatabase 'Database' -NotLike
        Get-DBPoolContainer -ParentContainer -DefaultDatabase 'Database*' -NotLike

        Get a list of containers from the DBPool API, or parent containers where the database does not match the filter
        Accepts wildcard input

    .NOTES
        The -Name, and -DefaultDatabase parameters are not native endpoints of the DBPool API.
        This is a custom function which uses 'Where-Object', along with the optional -NotLike parameter to return the response using the provided filter.

        If no match is found an error is output, and the original response is returned.

        Equivalent API endpoint:
            - GET /api/v2/containers
            - GET /api/v2/parents
            - GET /api/v2/children
            - GET /api/v2/containers/{id}
            - GET /api/v2/containers/{id}/status

    .LINK
        https://datto-dbpool-api.kentsapp.com/Containers/Get-DBPoolContainer/
#>

    [CmdletBinding(DefaultParameterSetName = 'ListContainer')]
    [Alias('Get-DBPool')]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(ParameterSetName = 'ListContainer')]
        [switch]$ListContainer,

        [Parameter(ParameterSetName = 'ParentContainer')]
        [switch]$ParentContainer,

        [Parameter(ParameterSetName = 'ChildContainer')]
        [switch]$ChildContainer,

        [Parameter(ParameterSetName = 'ParentContainer', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ListContainer', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ContainerStatus', Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        #[ValidateRange(0, [int]::MaxValue)]
        [int[]]$Id,

        [Parameter(ParameterSetName = 'ContainerStatus')]
        [switch]$Status,

        [Parameter(ParameterSetName = 'ListContainer', ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ParentContainer', ValueFromPipelineByPropertyName = $true)]
        [SupportsWildcards()][string[]]$Name,

        [Parameter(ParameterSetName = 'ListContainer', ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ParentContainer', ValueFromPipelineByPropertyName = $true)]
        [Alias('Database')]
        [SupportsWildcards()][string[]]$DefaultDatabase,

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

        # Validate filter parameters for name or DefaultDatabase if -NotLike switch is used
        if ($PSCmdlet.ParameterSetName -eq 'ListContainer' -or $PSCmdlet.ParameterSetName -eq 'ParentContainer') {
            if ($NotLike -and -not ($Name -or $DefaultDatabase)) {
                Write-Error 'The -NotLike switch requires either the -Name or -DefaultDatabase parameter to be specified.' -ErrorAction Stop
            }
        }

        # Internal Function to filter the response by Container Name or DefaultDatabase if provided
        function Select-DBPoolContainer {
            param(
                [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
                [PSObject[]]$Container,

                [Parameter(Mandatory = $false)]
                [string[]]$Name,

                [Parameter(Mandatory = $false)]
                [string[]]$DefaultDatabase,

                [Parameter(Mandatory = $false)]
                [switch]$NotLike
            )

            process {
                # Verbose filter output
                $Filter = @()
                $filterParameter = @()

                if ($Name) {
                    $Filter += 'Name'
                    $filterParameter += ($Name -join ', ')
                }
                if ($DefaultDatabase) {
                    $Filter += 'DefaultDatabase'
                    $filterParameter += ($DefaultDatabase -join ', ')
                }

                $filterHeader = $Filter -join '; '
                $filterValues = @()

                if ($Name) {
                    $filterValues += ($Name -join ', ')
                }
                if ($DefaultDatabase) {
                    $filterValues += ($DefaultDatabase -join ', ')
                }

                if ($NotLike) {
                    Write-Verbose "Excluding response by containers matching $filterHeader [ $($filterValues -join '; ') ]"
                } else {
                    Write-Verbose "Filtering response by containers matching $filterHeader [ $($filterValues -join '; ') ]"
                }

                # Filter containers
                $FilteredContainers = $Container | Where-Object {
                    $matchesName = $true
                    $matchesDB = $true

                    # Handle Name filtering
                    if ($Name) {
                        $matchesName = $false
                        foreach ($n in $Name) {
                            if ($_.name -like $n) {
                                $matchesName = $true
                                break
                            }
                        }
                        if ($NotLike) {
                            $matchesName = -not $matchesName
                        }
                    }

                    # Handle DefaultDatabase filtering
                    if ($DefaultDatabase) {
                        $matchesDB = $false
                        foreach ($db in $DefaultDatabase) {
                            if ($_.defaultDatabase -like $db) {
                                $matchesDB = $true
                                break
                            }
                        }
                        if ($NotLike) {
                            $matchesDB = -not $matchesDB
                        }
                    }

                    # Return true if both conditions match
                    $matchesName -and $matchesDB
                }

                # Output filtered containers
                if (!$FilteredContainers) {
                    Write-Warning "No containers found matching the $filterHeader filter parameter [ $($filterValues -join '; ') ].`nReturning all containers."
                    return $Container
                }

                return $FilteredContainers
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
                    $uri += '/status'
                }

                try {
                    $requestResponse = Invoke-DBPoolRequest -method $method -resource_Uri $uri -ErrorAction Stop
                    if ($null -ne $requestResponse) {
                        $requestResponse | ConvertFrom-Json
                    }
                } catch {
                    Write-Error $_
                    continue
                }

            }
        # Get list of containers based on the parameter set, returns all listed containers
        } else {
            Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameter set"

            try {
                $requestResponse = Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -ErrorAction Stop
                # Convert the response to JSON, return the response based on the parameter set
                if ($null -ne $requestResponse) {
                    $response = $requestResponse | ConvertFrom-Json

                    if ($PSCmdlet.ParameterSetName -eq 'ParentContainer') {
                        $response = $response.parents
                    } elseif ($PSCmdlet.ParameterSetName -eq 'ListContainer') {
                        $response = $response.containers
                    } elseif ($PSCmdlet.ParameterSetName -eq 'ContainerStatus') {
                        foreach ($container in $($response.containers | Sort-Object -Property Name)) {
                            $requestResponse = $null
                            Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameter set for Container Name: [ $($container.name) ] - ID: $($container.id)"

                            $uri = "$requestPath/$($container.id)/status"

                            try {
                                $requestResponse = Invoke-DBPoolRequest -method $method -resource_Uri $uri -ErrorAction Stop -Verbose:$false
                                if ($null -ne $requestResponse) {
                                    $requestResponse | ConvertFrom-Json
                                }
                            } catch {
                                Write-Error $_
                                Write-Warning "If you need to report an error to the DBE team, include this request ID which can be used to search through the application logs for messages that were logged while processing your request [ X-App-Request-Id: $DBPool_appRequestId ]"
                                continue
                            }

                        }
                    }
                }
            } catch {
                Write-Error $_
            }

        }


        # Filter the response by Name or DefaultDatabase if provided using internal helper function
        if ($null -ne $response -and ($PSBoundParameters.ContainsKey('Name') -or $PSBoundParameters.ContainsKey('DefaultDatabase'))) {
            try {
                $response = Select-DBPoolContainer -Container $response -Name $Name -DefaultDatabase $DefaultDatabase -NotLike:$NotLike -ErrorAction Stop
            } catch {
                Write-Error $_
            }
        }

        # Return the response
        $response

    }

    end {}

}
