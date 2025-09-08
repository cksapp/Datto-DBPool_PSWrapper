function Remove-DBPoolContainer {
    <#
    .SYNOPSIS
        The Remove-DBPoolContainer function is used to delete a container in the DBPool.

    .DESCRIPTION
        The Remove-DBPoolContainer function is used to delete containers in the DBPool based on the provided container ID.

        !! This is a destructive operation and will destory the container !!

    .PARAMETER Id
        The ID of the container to delete.
        This accepts an array of integers.

    .PARAMETER Force
        Forces the removal of the container without prompting for confirmation.

    .INPUTS
        [int] - The ID of the container to delete.

    .OUTPUTS
        [void] - No output is returned.

    .EXAMPLE
        Remove-DBPoolContainer -Id '12345'

        This will delete the provided container by ID.

    .EXAMPLE
        @( 12345, 56789 ) | Remove-DBPoolContainer -Confirm:$false

        This will delete the containers with ID 12345, and 56789.

    .NOTES
        Equivalent API endpoint:
            - DELETE /api/v2/containers/{id}

    .LINK
        https://datto-dbpool-api.kentsapp.com/Containers/Remove-DBPoolContainer/
#>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [Alias('Delete-DBPoolContainer', 'Destroy-DBPoolContainer')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [Alias('ContainerId')]
        [int[]]$Id,

        [switch]$Force
    )

    begin {

        $method = 'DELETE'

        # Pass the InformationAction parameter if bound, default to 'Continue'
        if ($PSBoundParameters.ContainsKey('InformationAction')) {
            $InformationPreference = $PSBoundParameters['InformationAction']
        } else {
            $InformationPreference = 'Continue'
        }

    }

    process {

        foreach ($n in $Id) {
            $response = $null
            $requestPath = "/api/v2/containers/$n"

            # Try to get the container name to output for the ID when using the Verbose preference
            if ($VerbosePreference -eq 'Continue') {
                try {
                    $containerName = (Get-DBPoolContainer -Id $n -WarningAction SilentlyContinue -ErrorAction Stop -Verbose:$false).name
                } catch {
                    Write-Warning "Failed to get the container name for ID $n. $_"
                    $containerName = '## FailedToGetContainerName ##'
                }
            }

            if ($Force -or $PSCmdlet.ShouldProcess("Container [ ID: $n ]", 'Destroy')) {
                Write-Verbose "Destroying Container [ ID: $n, Name: $containerName ]"

                try {
                    $response = Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -ErrorAction Stop
                    if ($response.StatusCode -eq 204) {
                        Write-Information "Success: Container [ ID: $n ] destroyed."
                    }
                } catch {
                    Write-Error $_
                }

            }
        }

    }

    end {}
}
