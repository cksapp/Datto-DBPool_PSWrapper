<#

	.SYNOPSIS
	A PowerShell module that connects to the Datto DBPool API.

	.DESCRIPTION
	This module contains functions that can used in PowerShell to perform the following operations for the Datto Internal DBPool v2 API:
	
	parent-controller : Operations on Parent Containers
	container-controller : Operations on your database containers
	user-controller : Operations on users
	
	Check https://dbpool.datto.net/api/docs/ to see full list of operations.
	
	.COPYRIGHT
    Copyright (c) Kent Sapp. All rights reserved. Licensed under the MIT license.
    See https://github.com/cksapp/DattoDBPool_Module/blob/main/LICENSE for license information.
	
	.PARAMETER apiUrl
	Provide the Datto DBPool API URL
	
	.PARAMETER apiKey
	Provide your API Key

#>

# Root Module Parameters
[CmdletBinding()]
Param(
	[Parameter(
		Position = 0, 
		Mandatory=$False
	)]
	$apiUrl,

	[Parameter(
		Position = 1, 
		Mandatory=$False
	)]
	$apiKey
)

# Functions Directory Path
$functionsDir = Join-Path -path $PSScriptRoot -ChildPath "functions"
$functionsPath = Join-Path -path $functionsDir -ChildPath "*.ps1"

# Import functions
$Functions = @( Get-ChildItem -Path $functionsPath -ErrorAction SilentlyContinue ) 
foreach ($Import in @($Functions)){
  try{
    . $Import.fullname
  }
  catch{
    throw "Could not import function $($Import.fullname): $_"
  }
}

# Set API parameters
If ($apiUrl -and $apiKey) {
	Set-DdbpApiParameters -Url $apiUrl -apiKey $apiKey
}
