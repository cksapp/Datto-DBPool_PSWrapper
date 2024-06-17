function Set-DBPoolApiParameters {
<#
    .SYNOPSIS
        The Set-DBPoolApiParameters function is used to set parameters for the Datto DBPool API.

    .DESCRIPTION
        The Set-DBPoolApiParameters function is used to set the API URL and API Key for the Datto DBPool API.

    .PARAMETER base_uri
        Provide the URL of the Datto DBPool API.
        The default value is https://dbpool.datto.net.

	.PARAMETER apiKey
	    Provide Datto DBPool API Key for authorization.
        You can find your user API key at [ /web/self ](https://dbpool.datto.net/web/self).

    .EXAMPLE
        Set-DBPoolApiParameters -base_uri "https://dbpool.datto.net" -apiKey "0207e066-a779-4849-8aab-0105abf360d8"

        Set the API URL and API Key for the Datto DBPool API.

    .NOTES
        See Datto DBPool API help files for more information.

    .LINK
        N/A
#>
	
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
	Param(
        [Parameter(Position = 0, Mandatory = $False, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True, HelpMessage = "Provide the base URL of the DBPool API.")]
        [Uri]$base_uri = "https://dbpool.datto.net",

        [Parameter(Position = 1, Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True, HelpMessage = "Provide Datto DBPool API Key for authorization.")]
        [securestring]$apiKey
    )
 
    Begin {

        # Check to replace existing variables
        if ((Get-Variable -Name DBPool_Base_URI -ErrorAction SilentlyContinue) -and (Get-Variable -Name DBPool_ApiKey -ErrorAction SilentlyContinue)) {
            if (-not $PSCmdlet.ShouldContinue("Variables 'DBPool_Base_URI' and '$DBPool_ApiKey' already exist. Do you want to replace them?", "Confirm overwrite")) {
                Write-Output "Existing variables were not replaced."
                break
            }
        }

    }

    Process {

        # Cast URI Variable to string type
        [String]$base_uri = $base_uri.AbsoluteUri

        # Check for trailing slash and remove if present
        $base_uri = $base_uri.TrimEnd('/')

        # Set or replace the parameters
        if ($PSCmdlet.ShouldProcess('$base_uri', "Set to $base_uri")) {
            Add-DBPoolBaseURI -base_uri $base_uri
        }

        if ($PSCmdlet.ShouldProcess('$DBPool_APIKey', "Add")) {
            Add-DBPoolAPIKey -apiKey $apiKey
        }

    }
    
    End {}
}