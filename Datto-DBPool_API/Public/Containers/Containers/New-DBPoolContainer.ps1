function New-DBPoolContainer {
<#
    .SYNOPSIS
        The New-DBPoolContainer function is used to create a new container from the DBPool API.

    .DESCRIPTION
        The New-DBPoolContainer function is used to create a new container in the DBPool based on the provided container name and parent container information.

        This requires a container name and at least one at least one of the parent* fields must be specified.
        If multiple parent fields are specified, both conditions will have to match a parent for it to be selected.

    .PARAMETER ContainerName
        The name for the container to create.
    
    .PARAMETER ParentId
        The ID of the parent container to clone.
    
    .PARAMETER ParentName
        The name of the parent container to clone.
    
    .PARAMETER ParentDefaultDatabase
        The default database of the parent container to clone.
    
    .EXAMPLE
        New-DBPoolContainer -ContainerName 'MyNewContainer' -ParentId 12345

    .EXAMPLE
        Get-DBPoolContainer -ParentContainer -Id 1 | New-DBPoolContainer -ContainerName 'MyNewContainer'

    .NOTES
        N/A

    .LINK
        N/A
#>

    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$ContainerName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [Alias("Id")]
        [int]$ParentId,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Alias("Name")]
        [string]$ParentName,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Alias("DefaultDatabase")]
        [string]$ParentDefaultDatabase
    )

    begin {

        $method = 'POST'
        $requestPath = "/api/v2/containers"
        $body = @{}

    }

    process {

        $body['name'] = $ContainerName

        # Check if at least one parent parameter is provided
        if (-not ($PSBoundParameters.ContainsKey('ParentId') -or $PSBoundParameters.ContainsKey('ParentName') -or $PSBoundParameters.ContainsKey('ParentDefaultDatabase'))) {
            throw "At least one parent parameter must be provided."
        }

        # Insert specified parent parameters into the request body
        if ($PSBoundParameters.ContainsKey('ParentId')) {
            $body.'parent.id' = $ParentId
        }
        if ($PSBoundParameters.ContainsKey('ParentName')) {
            $body.'parent.name' = $ParentName
        }
        if ($PSBoundParameters.ContainsKey('ParentDefaultDatabase')) {
            $body.'parent.defaultDatabase' = $ParentDefaultDatabase
        }

        try {
            $response = Invoke-DBPoolRequest -method $method -resource_Uri $requestPath -data $body -ErrorAction Stop
        }
        catch {
            Write-Error $_
        }

        if ($null -ne $response) {
            $response = $response | ConvertFrom-Json
        }

        # Return the response
        $response

    }
    
    end {}

}