function Add-DBPoolBaseURI {
<#
    .SYNOPSIS
        Sets the base URI for the DBPool API connection.

    .DESCRIPTION
        The Add-DBPoolBaseURI cmdlet sets the base URI which is later used
        to construct the full URI for all API calls.

    .PARAMETER base_uri
        Define the base URI for the DBPool API connection using Datto's DBPool URI or a custom URI.

    .PARAMETER instance
        DBPool's URI connection point that can be one of the predefined data centers.

        The accepted values for this parameter are:
        [ DEFAULT ]
            DEFAULT = https://dbpool.datto.net

        Placeholder for other data centers.

    .INPUTS
        [string] - The base URI for the DBPool API connection.

    .OUTPUTS
        [void] - No output is returned.

    .EXAMPLE
        Add-DBPoolBaseURI

        The base URI will use https://dbpool.datto.net which is Datto's default DBPool URI.

    .EXAMPLE
        Add-DBPoolBaseURI -instance Datto

        The base URI will use https://dbpool.datto.net which is DBPool's default URI.

    .EXAMPLE
        Add-DBPoolBaseURI -base_uri http://dbpool.example.com

        A custom API gateway of http://dbpool.example.com will be used for all API calls to DBPool's API.

    .NOTES
        N/A

    .LINK
        N/A
#>

    [cmdletbinding()]
    [OutputType([void])]
    [Alias("Set-DBPoolBaseURI")]
    Param (
        [Parameter(Mandatory = $false , ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$base_uri = 'https://dbpool.datto.net',

        [ValidateSet('Datto')]
        [String]$instance
    )

    begin {}

    process {

        # Trim superfluous forward slash from address (if applicable)
        $base_uri = $base_uri.TrimEnd('/')

        switch ($instance) {
            'Datto' { $base_uri = 'https://dbpool.datto.net' }
        }

        Set-Variable -Name "DBPool_Base_URI" -Value $base_uri -Option ReadOnly -Scope Global -Force
        Write-Verbose "DBPool Base URI set to `'$base_uri`'."

    }

    end {}

}
