function Invoke-DBPoolContainer {
<#
    .SYNOPSIS
        The Invoke-DBPoolContainer function is used to interact with various container operations in the Datto DBPool API.

    .DESCRIPTION
        The Invoke-DBPoolContainer function is used to interact with various container operations in the Datto DBPool API.

        The function is designed to be used with the Datto DBPool API and is used to interact with the following operations:
        Parent Containers:
            - Get Parent Containers
            - Get Parent Container by ID
        Containers:
            - Get Containers
            - Get Container by ID
        Children:
            - Get Child Containers

    .PARAMETER Method
        The HTTP method to use for the API call. Default is 'GET'.

    .PARAMETER ListContainers
        Switch to list all containers.

    .PARAMETER ContainerId
        The ID of the container to access.

    .PARAMETER Status
        Switch to get the status of a container.

    .PARAMETER Actions
        Switch to get the actions of a container.

    .PARAMETER Access
        Switch to access a container.

    .PARAMETER Username
        The username to access the container.

    .PARAMETER ParentContainers
        Switch to get parent containers.

    .PARAMETER ChildContainers
        Switch to get child containers.

    .EXAMPLE
        Invoke-DBPoolContainer -ListContainers
        Invoke-DBPoolContainer -ContainerId '12345'
        Invoke-DBPoolContainer -ContainerId '12345' -Status
        Invoke-DBPoolContainer -ContainerId '12345' -Actions

    .EXAMPLE
        Invoke-DBPoolContainer -ContainerId '12345' -Access -Username 'user1'
        Invoke-DBPoolContainer -ContainerId '12345' -Access -Username 'user2' -Method 'PUT'
        Invoke-DBPoolContainer -ContainerId '12345' -Access -Username 'user2' -Method 'DELETE'

    .EXAMPLE
        Invoke-DBPoolContainer -ParentContainers
        Invoke-DBPoolContainer -ParentContainers -ContainerId '12345

    .EXAMPLE
        Invoke-DBPoolContainer -ChildContainers

    .NOTES
        N/A

    .LINK
        N/A

#>

    [CmdletBinding(DefaultParameterSetName = 'ListContainers')]
    param (
        [Parameter(ParameterSetName = 'ListContainers', Mandatory = $false)]
        [Parameter(ParameterSetName = 'ContainerAccess', Mandatory = $false)]
        [Parameter(ParameterSetName = 'ContainerActions', Mandatory = $false)]
        [ValidateSet('DELETE', 'GET', 'PATCH', 'POST', 'PUT')]
        [string]$Method = 'GET',

        [Parameter(ParameterSetName = 'ListContainers', Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$RequestBody,

        [Parameter(ParameterSetName = 'ListContainers')]
        [Switch]$ListContainers,

        [Parameter(ParameterSetName = 'ParentContainers', Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ListContainers', Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ContainerAccess', Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [int]$ContainerId,

        [Parameter(ParameterSetName = 'ListContainers', Mandatory = $false)]
        [Switch]$Status,

        [Parameter(ParameterSetName = 'ContainerAccess', Mandatory = $false)]
        [Switch]$Access,

        [Parameter(ParameterSetName = 'ContainerAccess', Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Username,

        [Parameter(ParameterSetName = 'ListContainers', Mandatory = $false)]
        [Switch]$Actions,

        [Parameter(ParameterSetName = 'ParentContainers')]
        [Switch]$ParentContainers,

        [Parameter(ParameterSetName = 'ChildContainers')]
        [Switch]$ChildContainers
        
    )
    
    begin {
        switch ($PSCmdlet.ParameterSetName) {
            'ParentContainers' {

                $method = 'GET'
                $requestPath = '/api/v2/parents'
                if ($PSBoundParameters.ContainsKey('ContainerId')) { $requestPath += "/$ContainerId" }

            }
            'ListContainers' {

                switch ($Method) {
                    'GET' {
                        $requestPath = "/api/v2/containers"
                        if ($PSBoundParameters.ContainsKey('ContainerId')) {
                            $requestPath += "/$ContainerId"
                            switch ($true) {
                                $Status {
                                    $requestPath += "/status" 
                                }
                                $Actions {
                                    $requestPath += "/actions" 
                                }
                            }
                        }
                    }
                    'POST' {
                        $requestPath = "/api/v2/containers"
                        if ($PSBoundParameters.ContainsKey('ContainerId')) {
                            $requestPath += "/$ContainerId"
                        }
                        $requestBody = $RequestBody
                    }
                }

            }
            'ContainerAccess' {
                $requestPath = "/api/v2/containers/$ContainerId/access/$Username"
            }
            'ChildContainers' {
                $method      = 'GET'
                $requestPath = "/api/v2/children"
            }
        }
    }
    
    process {

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Invoke-DBPoolRequest -method $method -resource_Uri $requestPath

    }
    
    end {}
}