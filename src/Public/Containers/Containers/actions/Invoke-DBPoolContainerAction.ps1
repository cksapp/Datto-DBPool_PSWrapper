function Invoke-DBPoolContainerAction {
    <#
    .SYNOPSIS
        The Invoke-DBPoolContainerAction function is used to interact with various container action operations in the Datto DBPool API.

    .DESCRIPTION
        The Invoke-DBPoolContainerAction function is used to perform actions on a container such as refresh, schema-merge, start, restart, or stop.

    .PARAMETER Id
        The ID(s) of the container(s) to perform the action on.

    .PARAMETER Action
        The action to perform on the container. Valid actions are: refresh, schema-merge, start, restart, or stop.

        Start, Stop, and Restart are all considered minor actions and will not require a confirmation prompt.
        Refresh and Schema-Merge are considered major actions and will require a confirmation prompt.

    .PARAMETER Force
        Skip the confirmation prompt for major actions, such as 'Refresh' and 'Schema-Merge'.

    .PARAMETER TimeoutSeconds
        The maximum time in seconds to wait for the action to complete. Default is 3600 seconds (60 minutes).

    .PARAMETER ThrottleLimit
        The maximum number of containers to process in parallel. Default is twice the number of processor cores.

    .INPUTS
        [int] - The ID of the container to perform the action on.
        [string] - The action to perform on the container.

    .OUTPUTS
        [void] - No output is returned.

    .EXAMPLE
        Invoke-DBPoolContainerAction -Action 'restart' -Id '12345'

        This will restart the container with ID 12345

    .EXAMPLE
        Invoke-DBPoolContainerAction refresh 12345,56789

        This will refresh the containers with ID 12345, and 56789

    .EXAMPLE
        Invoke-DBPoolContainerAction -Action refresh -Id (Get-DBPoolContainer).Id -Force

        This will refresh all containers without prompting for confirmation.

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
    [OutputType([void])]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateSet('refresh', 'schema-merge', 'start', 'restart', 'stop', IgnoreCase = $false)]
        [string]$Action,

        [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [Alias('ContainerId')]
        [int[]]$Id,

        [switch]$Force,

        [Parameter(DontShow = $true)]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$TimeoutSeconds = 3600,  # Default timeout of 60 minutes (3600 seconds) for longer running actions

        [Parameter(DontShow = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$ThrottleLimit = ([Environment]::ProcessorCount * 2)
    )

    begin {

        $method = 'POST'

        # Pass the InformationAction parameter if bound, default to 'Continue'
        if ($PSBoundParameters.ContainsKey('InformationAction')) {
            $InformationPreference = $PSBoundParameters['InformationAction']
        } else {
            $InformationPreference = 'Continue'
        }

        # Write warning when using deprecated 'schema-merge' action, otherwise set confirmation prompt for 'major' actions
        if ($Action -eq 'schema-merge') {
            Write-Warning 'The action [ schema-merge ] is deprecated! Use the [ refresh ] action as the supported way to update a container.'
            $ConfirmPreference = 'Medium'
        } elseif ($Action -eq 'refresh' -and -not $Force) {
            $ConfirmPreference = 'Medium'
        }

        $moduleName = $MyInvocation.MyCommand.Module.Name
        if ([string]::IsNullOrEmpty($moduleName)) {
            Write-Error 'This function is not loaded as part of a module or the module name is unavailable.' -ErrorAction Stop
        }
        $modulePath = (Get-Module -Name $moduleName).Path

        # Check if the ForEach-Object cmdlet supports the Parallel parameter
        $supportsParallel = ((Get-Command ForEach-Object).Parameters.keys) -contains 'Parallel'

        # Create shared runspace pool for parallel tasks
        if (!$supportsParallel) {
            $runspacePool = [runspacefactory]::CreateRunspacePool(1, $ThrottleLimit)
            $runspacePool.Open()
            $runspaceQueue = [System.Collections.Concurrent.ConcurrentQueue[PSCustomObject]]::new()
        }

    }

    process {

        if ($supportsParallel) {

            $IdsToProcess = [System.Collections.ArrayList]::new()
            foreach ($n in $Id) {
                if ($Force -or $PSCmdlet.ShouldProcess("Container [ ID: $n ]", "[ $Action ]")) {
                    $IdsToProcess.Add($n) | Out-Null
                }
            }

            if ($IdsToProcess.Count -gt 0) {
                $IdsToProcess | ForEach-Object -Parallel {
                    $n = $_

                    Import-Module $using:modulePath
                    Add-DBPoolBaseURI -base_uri $using:DBPool_Base_URI
                    Add-DBPoolApiKey -apiKey $using:DBPool_ApiKey

                    $requestPath = "/api/v2/containers/$n/actions/$using:Action"

                    # Try to get the container name to output for the ID when using the Verbose preference
                    if ($using:VerbosePreference -eq 'Continue') {
                        try {
                            $containerName = (Get-DBPoolContainer -Id $n -ErrorAction Stop).name
                        } catch {
                            Write-Error "Failed to get the container name for ID $n. $_"
                            $containerName = '## FailedToGetContainerName ##'
                        }
                    }
                    Write-Verbose "Performing action [ $using:Action ] on Container [ ID: $n, Name: $containerName ]" -Verbose:($using:VerbosePreference -eq 'Continue')

                    try {
                        $requestResponse = Invoke-DBPoolRequest -method $using:method -resource_Uri $requestPath -ErrorAction Stop -WarningAction:SilentlyContinue
                        if ($requestResponse.StatusCode -eq 204) {
                            Write-Information "Success: Invoking Action [ $using:Action ] on Container [ ID: $n ]."
                        }
                    } catch {
                        Write-Error $_
                    }
                } -ThrottleLimit $ThrottleLimit -TimeoutSeconds $TimeoutSeconds
            }

        } else {
            # Process each container ID in parallel using runspaces where the ForEach-Object cmdlet does not support the Parallel parameter in Windows PowerShell 5.1 _(or version prior to [PowerShell 7.0](https://devblogs.microsoft.com/powershell/powershell-foreach-object-parallel-feature/))_
            # This is a manual implementation workaround of parallel processing using runspaces
            # TODO: Refactor to use [Invoke-Parallel](https://github.com/RamblingCookieMonster/Invoke-Parallel), or [PSParallelPipeline](https://github.com/santisq/PSParallelPipeline) module for parallel processing for better performance optimization as current implementation appears to have high performance overheard
            foreach ($n in $Id) {
                $requestPath = "/api/v2/containers/$n/actions/$Action"

                if ($Force -or $PSCmdlet.ShouldProcess("Container [ ID: $n ]", "[ $Action ]")) {
                    # Try to get the container name to output for the ID when using the Verbose preference
                    if ($VerbosePreference -eq 'Continue') {
                        try {
                            $containerName = (Get-DBPoolContainer -Id $n -ErrorAction stop -Verbose:($VerbosePreference -eq 'SilentlyContinue')).name
                        } catch {
                            Write-Error "Failed to get the container name for ID $n. $_"
                            $containerName = '## FailedToGetContainerName ##'
                        }
                    }
                    Write-Verbose "Performing action [ $Action ] on Container [ ID: $n, Name: $containerName ]"

                    $runspace = [powershell]::Create().AddScript({
                            param ($method, $requestPath, $modulePath, $baseUri, $apiKey, $containerId)

                            Import-Module $modulePath
                            Add-DBPoolBaseURI -base_uri $baseUri
                            Add-DBPoolApiKey -apiKey $apiKey

                            $VerbosePreference = $VerbosePreference

                            try {
                                $requestResponse = Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -ErrorAction Stop
                                return [pscustomobject]@{
                                    Success     = $true
                                    StatusCode  = $requestResponse.StatusCode
                                    Content     = $requestResponse.Content
                                    ContainerId = $containerId
                                }
                            } catch {
                                return [pscustomobject]@{
                                    Success      = $false
                                    ErrorMessage = $_.Exception.Message
                                    ErrorDetails = $_.Exception.ToString()
                                    ContainerId  = $containerId
                                }
                            }
                        }).AddArgument($method).AddArgument($requestPath).AddArgument($modulePath).AddArgument($DBPool_Base_URI).AddArgument($DBPool_ApiKey).AddArgument($n)

                    $runspaceQueue.Enqueue([PSCustomObject]@{ Pipe = $runspace; ContainerId = $n; Status = $runspace.BeginInvoke(); StartTime = [datetime]::Now })
                }
            }

            # Initialize sleep control variables
            $sleepDuration = 1 # Initial sleep duration in seconds
            $i = 0 # Counter to track iterations
            $initialThreshold = 10 # Initial threshold to increase sleep duration
            $maxSleepDuration = 60 # Maximum sleep duration in seconds

            # Process results as they complete or timeout
            while ($runspaceQueue.Count -gt 0) {
                $task = $null
                while ($runspaceQueue.TryDequeue([ref]$task)) {
                    if ($task.Status.IsCompleted) {
                        $result = $task.Pipe.EndInvoke($task.Status)
                        $task.Pipe.Dispose()

                        if ($result.Success) {
                            $statusCode = $result.StatusCode
                            if ($statusCode -eq 204) {
                                Write-Information "Success: Invoking Action [ $Action ] on Container [ ID: $($result.ContainerId) ]."
                            } else {
                                Write-Error "Failed: Status $statusCode. Response: $($result.Content)"
                            }
                        } else {
                            Write-Error "$($result.ErrorMessage)"
                        }
                    } elseif ($TimeoutSeconds -gt 0 -and $(([datetime]::Now - $task.StartTime).TotalSeconds) -ge $TimeoutSeconds) {
                        Write-Error "Action [ $Action ] on Container [ ID: $($task.ContainerId) ] exceeded timeout of $TimeoutSeconds seconds."
                        $task.Pipe.Stop()
                        $task.Pipe.Dispose()
                    } else {
                        # If task has neither completed nor timed out, re-enqueue it
                        $runspaceQueue.Enqueue($task)
                    }
                }

                Start-Sleep -Seconds $sleepDuration

                # Increment the counter
                $i++

                # Check if the counter has reached the dynamic threshold
                if ($i -ge $threshold) {
                    # Increase the sleep duration exponentially
                    $sleepDuration = [math]::Min($sleepDuration * 2, $maxSleepDuration)
                    # Increase the threshold linearly
                    $threshold += $initialThreshold
                    # Reset the counter
                    $i = 0
                }
            }

        }

    }

    end {

        # Close and dispose of the runspace pool
        if (!$supportsParallel) {
            $runspacePool.Close()
            $runspacePool.Dispose()
        }

    }

}
