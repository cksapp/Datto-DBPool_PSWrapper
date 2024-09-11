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

        if ($Action -eq 'schema-merge') {
            Write-Warning "The action [ schema-merge ] is deprecated! Use the [ refresh ] action as the supported way to update a container."
            $ConfirmPreference = 'Medium'
        }

        $moduleName = $MyInvocation.MyCommand.Module.Name
        if ([string]::IsNullOrEmpty($moduleName)) {
            throw "The function is not part of a module or the module name is not available."
        }
        $modulePath = (Get-Module -Name $moduleName).Path

    }

    process {

        $jobs = [System.Collections.ArrayList]::new()
        foreach ($n in $Id) {
            $requestPath = "/api/v2/containers/$n/actions/$Action"

            if ($VerbosePreference -eq 'Continue') {
                try {
                    $containerName = (Get-DBPoolContainer -Id $n -ErrorAction stop).name
                } catch {
                    Write-Error "Failed to get the container name for ID $n. $_"
                    $containerName = '## FailedToGetContainerName ##'
                }
            }

            if ($PSCmdlet.ShouldProcess("Container [ ID: $n ]", "[ $Action ]")) {
                Write-Verbose "Performing action [ $Action ] on Container [ ID: $n, Name: $containerName ]"

                $job = Start-Job -ScriptBlock {
                    param ($method, $requestPath, $modulePath, $baseUri, $apiKey)
                    
                    Import-Module $modulePath
                    Add-DBPoolBaseURI -base_uri $baseUri
                    Add-DBPoolApiKey -apiKey $apiKey
                Write-Verbose "Performing action [ $Action ] on Container [ ID: $n, Name: $containerName ]"

                $job = Start-Job -ScriptBlock {
                    param ($method, $requestPath, $modulePath, $baseUri, $apiKey)
                    
                    Import-Module $modulePath
                    Add-DBPoolBaseURI -base_uri $baseUri
                    Add-DBPoolApiKey -apiKey $apiKey

                    try {
                        $requestResponse = Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -ErrorAction Stop
                        return [pscustomobject]@{
                            Success    = $true
                            StatusCode = $requestResponse.StatusCode
                            Content    = $requestResponse.Content
                        }
                    } catch {
                        return [pscustomobject]@{
                            Success      = $false
                            ErrorMessage = $_.Exception.Message
                            ErrorDetails = $_.Exception.ToString()
                        }
                    }
                } -ArgumentList $method, $requestPath, $modulePath, $Global:DBPool_Base_URI, $Global:DBPool_ApiKey -Verbose

                # Add job to the ArrayList
                $jobs.Add([pscustomobject]@{ Job = $job; ContainerId = $n }) | Out-Null
            }
        }

        while ($jobs.Count -gt 0) {
            foreach ($jobInfo in $jobs.ToArray()) {
                $job = $jobInfo.Job
                $containerId = $jobInfo.ContainerId

                if ($job.State -eq 'Completed' -or $job.State -eq 'Failed' -or $job.State -eq 'Stopped') {
                    $results = Receive-Job -Job $job -Wait
                    foreach ($result in $results) {
                        if ($result.Success) {
                            $statusCode = $result.StatusCode
                            if ($statusCode -eq 204) {
                                Write-Output "Success: Invoking Action [ $Action ] on Container [ ID: $containerId ]."
                            } else {
                                Write-Error "Failed: Status $statusCode. Response: $($result.Content)"
                            }
                        } else {
                            Write-Error "$($result.ErrorMessage)"
                        }
                    }
                    Remove-Job -Job $job
                    $jobs.Remove($jobInfo) | Out-Null
                }
            }
            Start-Sleep -Seconds 1
        }
    }

    }

    end {}

}