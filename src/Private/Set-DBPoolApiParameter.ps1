function Set-DBPoolApiParameter {
<#
    .SYNOPSIS
        The Set-DBPoolApiParameter function is used to set parameters for the Datto DBPool API.

    .DESCRIPTION
        The Set-DBPoolApiParameter function is used to set the API URL and API Key for the Datto DBPool API.

    .PARAMETER base_uri
        Provide the URL of the Datto DBPool API.
        The default value is https://dbpool.datto.net.

    .PARAMETER apiKey
        Provide Datto DBPool API Key for authorization.
        You can find your user API key at [ /web/self ](https://dbpool.datto.net/web/self).

    .PARAMETER Force
        Force the operation without confirmation.

    .INPUTS
        [Uri] - The base URL of the DBPool API.
        [SecureString] - The API key for the DBPool.

    .OUTPUTS
        [void] - No output is returned.

    .EXAMPLE
        Set-DBPoolApiParameter

        Sets the default base URI and prompts for the API Key.

    .EXAMPLE
        Set-DBPoolApiParameter -base_uri "https://dbpool.example.com" -apiKey $secureString

        Sets the base URI to https://dbpool.example.com and sets the API Key.

    .NOTES
        See Datto DBPool API help files for more information.

    .LINK
        N/A
#>

    [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = 'Low')]
    [OutputType([void])]
    Param(
        [Parameter(Position = 0, Mandatory = $False, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True, HelpMessage = "Provide the base URL of the DBPool API.")]
        [Uri]$base_uri = "https://dbpool.datto.net",

        [Parameter(Position = 1, Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True, HelpMessage = "Provide Datto DBPool API Key for authorization.")]
        [securestring]$apiKey,

        [Parameter(Position = 2, Mandatory = $False, HelpMessage = "Force the operation without confirmation.")]
        [switch]$Force
    )

    Begin {

        # Cast URI Variable to string type
        [String]$base_uri = $base_uri.AbsoluteUri

        # Check for trailing slash and remove if present
        $base_uri = $base_uri.TrimEnd('/')

        # Check to replace existing variables
        if ((Get-Variable -Name DBPool_Base_URI -ErrorAction SilentlyContinue) -and (Get-Variable -Name DBPool_ApiKey -ErrorAction SilentlyContinue)) {
            if (-not ($Force -or $PSCmdlet.ShouldContinue("Variables 'DBPool_Base_URI' and '$DBPool_ApiKey' already exist. Do you want to replace them?", "Confirm overwrite"))) {
                Write-Warning "Existing variables were not replaced."
                break
            }
        }

    }

    Process {

        # Set or replace the parameters
        try {
            Add-DBPoolBaseURI -base_uri $base_uri -Verbose:$PSBoundParameters.ContainsKey('Verbose') -ErrorAction Stop
            Add-DBPoolAPIKey -apiKey $apiKey -Verbose:$PSBoundParameters.ContainsKey('Verbose') -ErrorAction Stop
        }
        catch {
            Write-Error $_
        }

    }

    End {}
}
