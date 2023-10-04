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
	[Parameter(Position = 0, Mandatory=$True)]
	[ValidateSet(
		"https://dbpool.datto.net/api/v2"
	)]
	[string]$Url,
    
	[Parameter(Position = 1, Mandatory=$True)]
	[string]$Key

	)

	New-Variable -Name apiUrl -Value $Url -Scope Script -Force
	New-Variable -Name apiKey -Value $Key -Scope Script -Force

}