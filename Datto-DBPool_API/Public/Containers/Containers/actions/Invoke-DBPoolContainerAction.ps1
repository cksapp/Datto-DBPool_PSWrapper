function Invoke-DBPoolContainerAction {
    <#
    .SYNOPSIS
        The Invoke-DBPoolContainerAction function is used to interact with various container action operations in the Datto DBPool API.

    .DESCRIPTION
        The Invoke-DBPoolContainerAction function is used to perform actions on a container such as refresh, schema-merge, start, restart, or stop.

    .PARAMETER Id
        The ID of the container to perform the action on.
    
    .PARAMETER Action
        The action to perform on the container. Valid actions are: refresh, schema-merge, start, restart, or stop.

        Start, Stop, and Restart are all considered minor actions and will not require a confirmation prompt.
        Refresh and Schema-Merge are considered major actions and will require a confirmation prompt.

    .EXAMPLE
        Invoke-DBPoolContainerAction -Id '12345' -Action 'restart'

        This will restart the container with ID 12345

    .NOTES
        N/A

    .LINK
        N/A
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$Id,

        [Parameter(Mandatory = $true)]
        [ValidateSet('refresh', 'schema-merge', 'start', 'restart', 'stop', IgnoreCase = $false)]
        [string]$Action
    )

    begin {
        $method = 'POST'
        $requestPath = "/api/v2/containers/$Id/actions/$Action"

        # Try to get the container name for the ID
        try {
            $containerName = (Get-DBPoolContainer -Id $Id).name
        }
        catch {
            Write-Warning "Failed to get the container name for ID $Id. Error: $_"
        }
    }

    process {

        Write-Verbose "Performing action [ $Action ] on container [ $containerName ]: $Id"

        Invoke-DBPoolRequest -method $method -resource_Uri $requestPath

    }
    
    end {}
}