function Invoke-DBPoolContainerAccess {
    <#
    .SYNOPSIS
        A short one-line action-based description, e.g. 'Tests if a function is valid'
    .DESCRIPTION
        A longer description of the function, its purpose, common use cases, etc.
    .NOTES
        Information or caveats about the function e.g. 'This function is not supported in Linux'
    .LINK
        Specify a URI to a help page, this will show when Get-Help -Online is used.
    .EXAMPLE
        Test-MyTestFunction -Verbose
        Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>

    [CmdletBinding(DefaultParameterSetName = 'GetAccess', SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'GetAccess')]
        [Parameter(Mandatory = $true, ParameterSetName = 'AddAccess')]
        [Parameter(Mandatory = $true, ParameterSetName = 'RemoveAccess')]
        [string]$Username,

        [Parameter(Mandatory = $false, ParameterSetName = 'AddAccess')]
        [Switch]$AddAccess,

        [Parameter(Mandatory = $false, ParameterSetName = 'RemoveAccess')]
        [Switch]$RemoveAccess
    )

    begin {

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
    }

    process {

        Invoke-DBPoolRequest -method $method -resource_Uri $requestPath
    }
    
    end {}
}