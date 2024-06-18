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

    .EXAMPLE
        Invoke-DBPoolContainerAction -Id @( '12345', '56789' ) -Action 'refresh'

        This will refresh the containers with ID 12345, and 56789

    .NOTES
        Actions:

            refresh:
                Recreate the Docker container and ZFS snapshot for the container.

            schema-merge:
                Attempt to apply upstream changes to the parent container to this child container.
                This may break your container. Refreshing a container is the supported way to update a child container's database schema.

            start:
                Start the Docker container for the container.

            restart:
                Stop and start the Docker container.

            stop:
                Stop the Docker container.

    .LINK
        N/A
#>

    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [Alias('ContainerId')]
        [int[]]$Id,

        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateSet('refresh', 'schema-merge', 'start', 'restart', 'stop', IgnoreCase = $false)]
        [string]$Action
    )

    begin {

        $method = 'POST'

        # Write warning when using deprecated 'schema-merge' action
        if ($Action -eq 'schema-merge') {
            Write-Warning "The action [ schema-merge ] is deprecated! Use the [ refresh ] action as the supported way to update a container."
            $ConfirmPreference = 'Medium'
        }

    }

    process {

        foreach ($n in $Id) {
            $requestResponse = $null
            $requestPath = "/api/v2/containers/$n/actions/$Action"

            # Try to get the container name to output for the ID when using the Verbose preference
            if ($VerbosePreference -eq 'Continue') {
                try {
                    $containerName = (Get-DBPoolContainer -Id $n -ErrorAction stop).name
                } catch {
                    Write-Error "Failed to get the container name for ID $n. $_"
                    $containerName = '## FailedToGetContainerName ##'
                }
            }

            if ($PSCmdlet.ShouldProcess("Container [ ID: $n ]", "[ $Action ]")) {
                Write-Verbose "Peforming action [ $Action ] on Container [ ID: $n, Name: $containerName ]"

                try {
                    $requestResponse = Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -ErrorAction Stop
                }
                catch {
                    Write-Error $_
                }

                if ($requestResponse.StatusCode -eq 204) {
                        Write-Output "Success: Invoking Action [ $Action ] on Container [ ID: $n ]."
                    }
            }
        }

    }
    
    end {}
}