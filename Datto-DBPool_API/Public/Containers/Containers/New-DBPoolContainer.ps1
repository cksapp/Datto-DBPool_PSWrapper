function New-DBPoolContainer {
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
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Name,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$ParentId,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$ParentName,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$ParentDefaultDatabase
    )

    begin {

        if (-not ($PSBoundParameters.ContainsKey('ParentId') -or $PSBoundParameters.ContainsKey('ParentName') -or $PSBoundParameters.ContainsKey('ParentDefaultDatabase'))) {
            throw "At least one parent parameter must be provided."
        }

        $method = 'POST'
        $requestPath = "/api/v2/containers"
        $body = @{
            name   = $Name
        }

        if ($PSBoundParameters.ContainsKey('ParentId')) {
            $body.'parent.id' = $ParentId
        }

        if ($PSBoundParameters.ContainsKey('ParentName')) {
            $body.'parent.name' = $ParentName
        }

        if ($PSBoundParameters.ContainsKey('ParentDefaultDatabase')) {
            $body.'parent.defaultDatabase' = $ParentDefaultDatabase
        }
    }

    process {

        Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -data $body

    }
    
    end {}
}