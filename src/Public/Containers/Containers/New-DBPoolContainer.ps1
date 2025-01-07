function New-DBPoolContainer {
<#
    .SYNOPSIS
        The New-DBPoolContainer function is used to create a new container from the DBPool API.

    .DESCRIPTION
        This function creates a new container in the DBPool based on the provided container name and parent container information.
        The ContainerName parameter is mandatory, and at least one of the parent parameters (ParentId, ParentName, or ParentDefaultDatabase) must be specified.

    .PARAMETER ContainerName
        The name for the new container.

    .PARAMETER ParentId
        The ID of the parent container to clone.

    .PARAMETER ParentName
        The name of the parent container to clone.

    .PARAMETER ParentDefaultDatabase
        The default database of the parent container to clone.

    .PARAMETER Force
        Force the operation without confirmation.

    .INPUTS
        [string] - ContainerName
        The name for the new container.

        [int] - ParentId
        The ID of the parent container to clone.

        [string] - ParentName
        The name of the parent container to clone.

        [string] - ParentDefaultDatabase
        The default database of the parent container to clone.

    .OUTPUTS
        [PSCustomObject] - The response from the DBPool API.

    .EXAMPLE
        New-DBPoolContainer -ContainerName 'MyNewContainer' -ParentId 12345

        This will create a new container named 'MyNewContainer' based on the parent container with ID 12345.

    .EXAMPLE
        Get-DBPoolContainer -ParentContainer -Id 1 | New-DBPoolContainer -ContainerName 'MyNewContainer'

        This will create a new container named 'MyNewContainer' based on the piped in parent container.

    .NOTES
        Equivalent API endpoint:
            - POST /api/v2/containers

    .LINK
        https://datto-dbpool-api.kentsapp.com/Containers/New-DBPoolContainer/
#>

    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    [Alias('Add-DBPoolContainer', 'Clone-DBPoolContainer', 'Copy-DBPoolContainer', 'Create-DBPoolContainer')]
    [OutputType([PSCustomObject])]
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
        [string]$ParentDefaultDatabase,

        [Parameter(Mandatory = $false, DontShow = $true)]
        [Switch]$Force
    )

    begin {

        $method = 'POST'
        $requestPath = "/api/v2/containers"
        $body = @{}

    }

    process {

        $body['name'] = $ContainerName

        # Check that at least one parent parameter is provided
        # This is done rather than using parameter sets or mandatory parameters to allow for multiple parent parameters to be provided as API accepts multiple parent parameter inputs
        # If multiple fields are specified, both conditions will have to match a parent for it to be selected.
        if (-not ($PSBoundParameters.ContainsKey('ParentId') -or $PSBoundParameters.ContainsKey('ParentName') -or $PSBoundParameters.ContainsKey('ParentDefaultDatabase'))) {
            Write-Error "At least one parent parameter (ParentId, ParentName, or ParentDefaultDatabase) must be provided." -ErrorAction Stop
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
            if ($Force -or $PSCmdlet.ShouldProcess("Container Name: $ContainerName", "Create new Container")) {
                $response = Invoke-DBPoolRequest -Method $method -resource_Uri $requestPath -data $body -ErrorAction Stop
            }

            if ($null -ne $response) {
                $response = $response | ConvertFrom-Json
            }
        }
        catch {
            Write-Error $_
        }

        # Return the response
        $response

    }

    end {}

}
