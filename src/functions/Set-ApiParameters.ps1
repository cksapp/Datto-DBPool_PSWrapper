function Set-ApiParameters{
	<#
	.SYNOPSIS
	Sets the API Parameters used throughout the module.

	.PARAMETER Url
	Provide Datto DBPool API Url. See Datto DBPool API documentation for more information.

	.PARAMETER Key
	Provide Dattto DBPool API Key. You can find your user API key at [/web/self](https://dbpool.datto.net/web/self).
	
	#>
	
	
	Param(
	[Parameter(Position = 0, Mandatory=$False)]
	[ValidateSet(
		"https://dbpool.datto.net/api/v2"
	)]
	$Url,
    
	[Parameter(Position = 1, Mandatory=$False)]
	$Key
	
	)

	New-Variable -Name apiUrl -Value $Url -Scope Script -Force
	New-Variable -Name apiKey -Value $Key -Scope Script -Force
	
	#$apiKey = New-ApiKey
	#New-Variable -Name apiKey -value $apiKey -Scope Script -Force
}