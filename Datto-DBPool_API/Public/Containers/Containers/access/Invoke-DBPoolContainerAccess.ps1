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

    .EXAMPLE
        Invoke-DBPoolContainerAccess -Id '12345' -Username 'John.Doe'
        Invoke-DBPoolContainerAccess -Id '12345' -Username 'John.Doe' -GetAccess

        This will get access to the container with ID 12345 for the user John.Doe

    .EXAMPLE
        Invoke-DBPoolContainerAccess -Id @('12345', '56789') -Username 'John.Doe' -AddAccess

        This will add access to the containers with ID 12345, and 56789 for the user John.Doe

    .EXAMPLE
        Invoke-DBPoolContainerAccess -Id '12345' -Username @('Jane.Doe', 'John.Doe') -RemoveAccess

        This will remove access to the container with ID 12345 for the users Jane.Doe, and John.Doe

    .NOTES
        N/A

    .LINK
        N/A
#>

    [CmdletBinding(DefaultParameterSetName = 'GetAccess', SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        #[ValidateRange(1, [int]::MaxValue)]
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

    begin {}

    process {
        foreach ($n in $Id) {
            foreach ($uName in $Username) {
                $requestPath = "/api/v2/containers/$n/access/$uName"

                switch ($PSCmdlet.ParameterSetName) {
                    'GetAccess' {
                        $method = 'GET'
                    }
                    'AddAccess' {
                        if ($PSCmdlet.ShouldProcess("Target", "Operation")) {
                            $method = 'PUT'   
                        }
                    }
                    'RemoveAccess' {
                        if ($PSCmdlet.ShouldProcess("Target", "Operation")) {
                            $method = 'DELETE'   
                        }
                    }
                }

                Invoke-DBPoolRequest -method $method -resource_Uri $requestPath
            }
        }
    }
    
    end {}
}