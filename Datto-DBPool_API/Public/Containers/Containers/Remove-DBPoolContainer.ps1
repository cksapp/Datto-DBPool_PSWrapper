function Remove-DBPoolContainer {
    <#
    .SYNOPSIS
        A short one-line action-based description, e.g. 'Tests if a function is valid'
    .DESCRIPTION
        A longer description of the function, its purpose, common use cases, etc.
    .NOTES
        Information or caveats about the function e.g. 'This function is not supported in Linux'
    .LINK
        Specify a URI to a help page, this will show when Get-Help -Online is used.
    .EXAMPLE
        Test-MyTestFunction -Verbose
        Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$Id
    )
    
    begin {

        $method = 'DELETE'
        $requestPath = "/api/v2/containers/$Id"

        try {
            $containerName = $(Get-DBPoolContainer -Id $Id).name
        }
        catch {
            Write-Warning "Failed to get the container name for ID $Id. Error: $_"
        }

    }
    
    process {

        if ($PSCmdlet.ShouldProcess("[ $containerName ] with ID $Id", 'Destroy Container')) {
            Invoke-DBPoolRequest -method $method -resource_Uri $requestPath
        }
        
    }
    
    end {}
}