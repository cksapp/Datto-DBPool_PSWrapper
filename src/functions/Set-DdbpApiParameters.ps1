function Set-DdbpApiParameters {
    <#
    .SYNOPSIS
    Sets the API Parameters used throughout the module.

    .PARAMETER Url
    Provide Datto DBPool API Url. See Datto DBPool API help files for more information.

	.PARAMETER Key
	Provide Dattto DBPool API Key. You can find your user API key at [/web/self](https://dbpool.datto.net/web/self).
	
	#>
	
	Param(
        [Parameter(
            Position = 0, Mandatory=$False
        )]
        [Uri]
        $apiUrl = "https://dbpool.datto.net",

        [Parameter(
            Position = 1, Mandatory=$True
        )]
        [string]$apiKey

	)
    
    New-Variable -Name apiUrl -Value $apiUrl -Scope Script -Force
	New-Variable -Name apiKey -Value $apiKey -Scope Script -Force
}