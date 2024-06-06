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

    [CmdletBinding(DefaultParameterSetName = 'ListContainer')]
    param (
        [Parameter(ParameterSetName = 'ParentContainer', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'ListContainer', Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        #[ValidateNotNullOrEmpty()]
        #[ValidateRange(0, [int]::MaxValue)]
        [long]$Id,

        [Parameter(ParameterSetName = 'ListContainer')]
        [switch]$ListContainer,

        [Parameter(ParameterSetName = 'ParentContainer')]
        [switch]$ParentContainer,

        [Parameter(ParameterSetName = 'ChildContainer')]
        [switch]$ChildContainer
    )
    
    begin {

        $method = 'GET'
        switch ($PSCmdlet.ParameterSetName) {
            'ListContainer' {
                $requestPath = '/api/v2/containers' 
            }
            'ParentContainer' {
                $requestPath = '/api/v2/parents' 
            }
            'ChildContainer' {
                $requestPath = '/api/v2/children' 
            }
        }

    }
    
    process {

        if ($PSBoundParameters.ContainsKey('Id')) {
            $requestPath += "/$Id" 
        }

        Invoke-DBPoolRequest -method $method -resource_Uri $requestPath

    }
    
    end {
    }
}