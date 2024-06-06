function Invoke-DBPoolContainerAccess {
<#
    .SYNOPSIS
        The Invoke-DBPoolContainerAccess function is used to interact with various container access operations in the Datto DBPool API.

    .DESCRIPTION
        The Invoke-DBPoolContainerAccess function is used to Get, Add, or Remove access to a container in the Datto DBPool API based on a given username.

    .PARAMETER Id
        The ID of the container to access.

    .PARAMETER Username
        The username to access the container.

    .EXAMPLE
        Invoke-DBPoolContainerAccess -Id '12345' -Username 'John.Doe'
        Invoke-DBPoolContainerAccess -Id '12345' -Username 'John.Doe' -GetAccess

        This will get access to the container with ID 12345 for the user John.Doe

    .EXAMPLE
        Invoke-DBPoolContainerAccess -Id '12345' -Username 'John.Doe' -AddAccess

        This will add access to the container with ID 12345 for the user John.Doe

    .EXAMPLE
        Invoke-DBPoolContainerAccess -Id '12345' -Username 'John.Doe' -RemoveAccess

        This will remove access to the container with ID 12345 for the user John.Doe

    .NOTES
        N/A

    .LINK
        N/A
#>

    [CmdletBinding(DefaultParameterSetName = 'GetAccess', SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        #[ValidateRange(1, [int]::MaxValue)]
        [long]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'GetAccess', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'AddAccess', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'RemoveAccess', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Username,

        [Parameter(Mandatory = $false, ParameterSetName = 'GetAccess')]
        [Switch]$GetAccess,

        [Parameter(Mandatory = $false, ParameterSetName = 'AddAccess')]
        [Switch]$AddAccess,

        [Parameter(Mandatory = $false, ParameterSetName = 'RemoveAccess')]
        [Switch]$RemoveAccess
    )

    begin {}

    process {

        $requestPath = "/api/v2/containers/$Id/access/$Username"
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
    
    end {}
}