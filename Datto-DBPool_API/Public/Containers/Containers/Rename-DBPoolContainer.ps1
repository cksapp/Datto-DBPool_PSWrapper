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

    }
    
    process {

        foreach ($n in $Id) {
            $requestPath = "/api/v2/containers/$n"
            Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -data $body
        }

    }
    
    end {}
}