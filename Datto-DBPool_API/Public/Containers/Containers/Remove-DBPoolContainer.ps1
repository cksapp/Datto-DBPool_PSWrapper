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

    .EXAMPLE
        Remove-DBPoolContainer -Id '12345'

        This will delete the provided container by ID.

    .EXAMPLE
        @( 12345, 56789 ) | Remove-DBPoolContainer -Confirm:$false

        This will delete the containers with ID 12345, and 56789.

    .NOTES
        N/A

    .LINK
        N/A
#>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [Alias('ContainerId')]
        [int[]]$Id
    )
    
    begin {
        $method = 'DELETE'
    }
    
    process {

        foreach ($n in $Id) {
            $response = $null
            $requestPath = "/api/v2/containers/$n"

            # Try to get the container name to output for the ID when using the Verbose preference
            if ($VerbosePreference -eq 'Continue') {
                try {
                    $containerName = (Get-DBPoolContainer -Id $n -ErrorAction Stop).name
                } catch {
                    Write-Warning "Failed to get the container name for ID $n. $_"
                    $containerName = '## FailedToGetContainerName ##'
                }
            }

            if ($PSCmdlet.ShouldProcess("Container [ ID: $n ]", 'Destroy')) {
                Write-Verbose "Destroying Container [ ID: $n, Name: $containerName ]"
                
                try {
                    $response = Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -ErrorAction Stop
                }
                catch {
                    Write-Error $_
                }

                if ($response.StatusCode -eq 204) {
                    Write-Output "Success: Container [ ID: $n ] destroyed."
                }
            }
        }
        
    }
    
    end {}
}