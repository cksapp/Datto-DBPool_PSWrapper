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

    .PARAMETER Force
        Skip the confirmation prompt for major actions, such as 'Refresh' and 'Schema-Merge'.

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
        [string]$Action,

        [switch]$Force
    )

    begin {

        $method = 'POST'

        # Write warning when using deprecated 'schema-merge' action, otherwise set confirmation prompt for 'major' actions
        if ($Action -eq 'schema-merge') {
            Write-Warning 'The action [ schema-merge ] is deprecated! Use the [ refresh ] action as the supported way to update a container.'
            $ConfirmPreference = 'Medium'
        } elseif ($Action -eq 'refresh' -and -not $Force) {
            $ConfirmPreference = 'Medium'
        }

        $moduleName = $MyInvocation.MyCommand.Module.Name
        if ([string]::IsNullOrEmpty($moduleName)) {
            Write-Error 'The function is not loaded as part of a module or the module name is not available.' -ErrorAction Stop
        }
        $modulePath = (Get-Module -Name $moduleName).Path

        $runspacePool = [runspacefactory]::CreateRunspacePool(1, [Environment]::ProcessorCount - 1)
        $runspacePool.Open()
        $runspaces = [System.Collections.ArrayList]::new()

    }

    process {

        foreach ($n in $Id) {
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

            if ($Force -or $PSCmdlet.ShouldProcess("Container [ ID: $n ]", "[ $Action ]")) {
                Write-Verbose "Performing action [ $Action ] on Container [ ID: $n, Name: $containerName ]"

                $runspace = [powershell]::Create().AddScript({
                        param ($method, $requestPath, $modulePath, $baseUri, $apiKey)

                        Import-Module $modulePath
                        Add-DBPoolBaseURI -base_uri $baseUri
                        Add-DBPoolApiKey -apiKey $apiKey

                        $warnings = [System.Collections.ArrayList]::new()
                        $warningPreference = 'Continue'

                        try {
                            $requestResponse = Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -WarningVariable warnings -ErrorAction Stop
                            return [pscustomobject]@{
                                Success    = $true
                                StatusCode = $requestResponse.StatusCode
                                Content    = $requestResponse.Content
                                Warnings   = $warnings
                            }
                        } catch {
                            return [pscustomobject]@{
                                Success      = $false
                                ErrorMessage = $_.Exception.Message
                                ErrorDetails = $_.Exception.ToString()
                                Warnings     = $warnings
                            }
                        }
                    }).AddArgument($method).AddArgument($requestPath).AddArgument($modulePath).AddArgument($Global:DBPool_Base_URI).AddArgument($Global:DBPool_ApiKey)

                $runspace.RunspacePool = $runspacePool
                $runspaceData = [pscustomobject]@{ Pipe = $runspace; ContainerId = $n; Handle = $runspace.BeginInvoke() }
                $runspaces.Add($runspaceData) | Out-Null
            }
        }

        while ($runspaces.Count -gt 0) {
            foreach ($runspace in $runspaces.ToArray()) {
                if ($runspace.Handle.IsCompleted) {
                    $results = $runspace.Pipe.EndInvoke($runspace.Handle)
            
                    foreach ($result in $results) {
                        switch ($true) {
                            { $result.Success } {
                                $statusCode = $result.StatusCode
                                if ($statusCode -eq 204) {
                                    Write-Output "Success: Invoking Action [ $Action ] on Container [ ID: $($runspace.ContainerId) ]."
                                } else {
                                    Write-Error "Failed: Status $statusCode. Response: $($result.Content)"
                                }
                                break
                            }
                            { $result.Warnings.Count -gt 0 } {
                                foreach ($warning in $result.Warnings) {
                                    Write-Warning "Container [ID: $($runspace.ContainerId)]: $warning"
                                }
                            }
                            { !$result.Success } {
                                Write-Error "Container [ID: $($runspace.ContainerId)]: $($result.ErrorMessage)"
                            }
                        }
                    }

                    $runspace.Pipe.Dispose()
                    $runspaces.Remove($runspace) | Out-Null
                }
            }

            Start-Sleep -Milliseconds 500
        }

    }

    end {

        $runspacePool.Close()
        $runspacePool.Dispose()

    }
}