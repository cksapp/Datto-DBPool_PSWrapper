<#
 
	.SYNOPSIS
	A PowerShell module that connects to the Datto DBPool API.

	.DESCRIPTION
	This module contains Datto DBPool v2 API controllers that can used in PowerShell to perform the followiing operations:
	
	parent-controller : Operations on Parent Containers
	container-controller : Operations on your database containers
	user-controller : Operations on users
	
	Check https://dbpool.datto.net/api/docs/ to see full list of operations.
	
	.COPYRIGHT
    Copyright (c) Kent Sapp. All rights reserved. Licensed under the MIT license.
    See https://github.com/cksapp/DattoDBPool_Module/blob/main/LICENSE for license information.
	
	.PARAMETER apiUrl
	Provide your Datto RMM platform URL
	
	.PARAMETER apiKey
	Provide your API Key
	
	
#>

# Root Module Parameters
[CmdletBinding()]
Param(
  [Parameter(Position = 0, Mandatory=$False)]
  $apiUrl,
    
  [Parameter(Position = 1, Mandatory=$False)]
  $apiKey
)


# Import functions
$Functions = @( Get-ChildItem -Path $PSScriptRoot\functions\*.ps1 -ErrorAction SilentlyContinue ) 
foreach ($Import in @($Functions)){
  try{
    . $Import.fullname
  }
  catch{
    throw "Could not import function $($Import.fullname): $_"
  }
}

# Set API parameters
If ($apiUrl -and $apiKey -and) {
	Set-DdbpApiParameters -Url $apiUrl -Key $apiKey -SecretKey
}
