function Get-DBPoolContainer {
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

    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        #[ValidateNotNullOrEmpty()]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$Id
    )
    
    begin {

        $method = 'GET'
        $requestPath = '/api/v2/containers'

        if ($PSBoundParameters.ContainsKey('Id')) {
            $requestPath += "/$Id" 
        }

    }
    
    process {

        Invoke-DBPoolRequest -method $method -resource_Uri $requestPath
        
    }
    
    end {
    }
}