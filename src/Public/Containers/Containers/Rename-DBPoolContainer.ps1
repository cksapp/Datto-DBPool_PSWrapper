function Rename-DBPoolContainer {
    <#
    .SYNOPSIS
        The Rename-DBPoolContainer function is used to update a container in the DBPool.

    .DESCRIPTION
        The Rename-DBPoolContainer function is used to change the name a container in the DBPool API.

    .PARAMETER Id
        The ID of the container to update.
        This accepts an array of integers.

    .PARAMETER Name
        The new name for the container.

    .INPUTS
        [int] - The ID of the container to update.
        [string] - The new name for the container.

    .OUTPUTS
        [PSCustomObject] - The response from the DBPool API.

    .EXAMPLE
        Rename-DBPoolContainer -Id 12345 -Name 'NewContainerName'

        This will update the container with ID 12345 to have the name 'NewContainerName'

    .EXAMPLE
        @( 12345, 56789 ) | Rename-DBPoolContainer -Name 'NewContainerName'

        This will update the containers with ID 12345, and 56789 to have the name 'NewContainerName'

    .NOTES
        Equivalent API endpoint:
            - PATCH /api/v2/containers/{id}

    .LINK
        https://datto-dbpool-api.kentsapp.com/Containers/Rename-DBPoolContainer/
#>

    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [Alias('ContainerId')]
        [int[]]$Id,

        [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Name
    )

    begin {

        $method = 'PATCH'
        $body = @{
            name = $Name
        }

        # Pass the InformationAction parameter if bound, default to 'Continue'
        if ($PSBoundParameters.ContainsKey('InformationAction')) {
            $InformationPreference = $PSBoundParameters['InformationAction']
        } else {
            $InformationPreference = 'Continue'
        }

    }

    process {

        foreach ($n in $Id) {
            $requestResponse = $null
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

            try {
                Write-Verbose "Updating Container [ ID: $n, Name: $containerName ]"
                $requestResponse = Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -data $body -ErrorAction Stop
                if ($requestResponse.StatusCode -eq 200) {
                    Write-Information "Successfully updated Container [ ID: $n ]"
                }
                if ($null -ne $requestResponse) {
                    $requestResponse | ConvertFrom-Json -ErrorAction Stop
                }
            } catch {
                Write-Error $_
            }

        }

    }

    end {}
}
