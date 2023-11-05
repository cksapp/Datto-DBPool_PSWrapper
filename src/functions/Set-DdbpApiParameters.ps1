function Set-DdbpApiParameters {
    <#
    .SYNOPSIS
    Sets the API Parameters used throughout the module.

    .PARAMETER Url
    Provide Datto DBPool API Url. See Datto DBPool API help files for more information.

	.PARAMETER Key
	Provide Dattto DBPool API Key. You can find your user API key at [/web/self](https://dbpool.datto.net/web/self).
	
	#>
	
    [CmdletBinding(SupportsShouldProcess)]
	Param(
        [Parameter(
            Position = 0, 
            Mandatory=$False, 
            ValueFromPipeline=$True, 
            ValueFromPipelineByPropertyName=$True, 
            HelpMessage="API URL to be used."
        )]
        [Uri]$apiUrl = "https://dbpool.datto.net",

        [Parameter(
            Position = 1, 
            Mandatory=$True, 
            ValueFromPipeline=$True, 
            ValueFromPipelineByPropertyName=$True, 
            HelpMessage="API Key for authorization."
            )]
        [string]$apiKey,

        <#[Parameter(
            Position = 2, 
            Mandatory=$False, 
            ValueFromPipeline=$True, 
            ValueFromPipelineByPropertyName=$True, 
            HelpMessage="Check if variables exist before replacing them. Default will skip this overwrite."
        )]
        [boolean]$replaceVars,#>

        [Parameter(
            Mandatory = $False,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True
        )]
        $varScope = "Global"
    )
 
    Begin {
        # Check to replace existing variables
        <#if ($ApiUrl -and $ApiKey) {
            $replaceVars = Read-Host "Variables 'apiUrl' and 'apiKey' already exist. Do you want to replace them? (Y/N)"
            if ($replaceVars -eq 'N') {
                Write-Output "Existing variables were not replaced."
                return
            }
        }#>
    }

    Process {
        # Cast URI Variable to string type
        [String]$apiUrl = $apiUrl.AbsoluteUri
        # Check for trailing slash and remove if present
        if ($apiUrl -match '/$') {
            $apiUrl = $apiUrl -replace '/$'
        }
    }
    
    End {
        # Set or replace the parameters
        Set-Variable -Name "apiUrl" -Value "$apiUrl" -Force -Scope $varScope
        Set-Variable -Name "apiKey" -Value "$apiKey" -Force -Scope $varScope
    }
}