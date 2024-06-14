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
    
    .EXAMPLE
        Rename-DBPoolContainer -Id 12345 -Name 'NewContainerName'
        @( 12345, 98765 ) | Rename-DBPoolContainer -Name 'NewContainerName'

    .NOTES
        N/A

    .LINK
        N/A
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(1, [int]::MaxValue)]
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

        $response = foreach ($n in $Id) {
            $requestResponse = $null
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

            try {
                Write-Verbose "Updating Container [ ID: $n, Name: $containerName ]"
                $requestResponse = Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -data $body -ErrorAction Stop
                if ($requestResponse.StatusCode -eq 200) {
                    Write-Information "Successfully updated Container [ ID: $n ]"
                }
            }
            catch {
                Write-Error $_
            }

            if ($null -ne $requestResponse) {
                    $requestResponse | ConvertFrom-Json
                }

        }

        # Return the response
        $response

    }
    
    end {}
}