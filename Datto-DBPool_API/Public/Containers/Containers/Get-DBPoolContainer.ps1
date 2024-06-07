function Get-DBPoolContainer {
<#
    .SYNOPSIS
        The Get-DBPoolContainer function is used to get container information from the DBPool API.

    .DESCRIPTION
        The Get-DBPoolContainer function is used to get container details from the DBPool API.
        This function is used to get the list of containers, parent containers, or child containers; and parent or child containers by ID.

    .PARAMETER Id
        The ID of the container to get. This parameter is required when using the ParentContainer or ChildContainer parameter sets.

    .PARAMETER ListContainer
        The ListContainer parameter is used to get a list of containers from the DBPool API.
        This is the default parameter set.

    .PARAMETER ParentContainer
        The ParentContainer parameter is used to get a list of parent containers from the DBPool API.

    .PARAMETER ChildContainer
        The ChildContainer parameter is used to get a list of child containers from the DBPool API.

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

    .NOTES
        N/A
    .LINK
        N/A
#>

    [CmdletBinding(DefaultParameterSetName = 'ListContainer')]
    param (
        [Parameter(ParameterSetName = 'ParentContainer', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ListContainer', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        #[ValidateNotNullOrEmpty()]
        #[ValidateRange(0, [int]::MaxValue)]
        [int[]]$Id,

        [Parameter(ParameterSetName = 'ListContainer')]
        [switch]$ListContainer,

        [Parameter(ParameterSetName = 'ParentContainer')]
        [switch]$ParentContainer,

        [Parameter(ParameterSetName = 'ChildContainer')]
        [switch]$ChildContainer
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
            foreach ($n in $Id) {
                Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet for ID $n"
                Invoke-DBPoolRequest -method $method -resource_Uri "$requestPath/$n"
            }
        } else {
            Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"
            Invoke-DBPoolRequest -method $method -resource_Uri $requestPath
        }
    }
    
    end {}
}