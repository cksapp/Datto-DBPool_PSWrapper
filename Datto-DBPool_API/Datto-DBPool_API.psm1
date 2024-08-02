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
    See https://github.com/cksapp/Datto-DBPool_PSWrapper/blob/main/LICENSE for license information.
    
    .PARAMETER base_uri
    Provide the Datto DBPool API URL
    
    .PARAMETER apiKey
    Provide your API Key

#>

# Root Module Parameters
[CmdletBinding()]
Param(
    [Parameter( Position = 0, Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true )]
    [string]$base_uri,

    [Parameter( Position = 1, Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true )]
    [string]$apiKey
)

# Directories to import from
$directory = "Classes", "Public", "Private"

# Import functions
foreach ($dir in $directory) {
    $dirPath = Join-Path -Path ($PSScriptRoot) -ChildPath $dir
    $Functions = @( Get-ChildItem -Path $dirPath -Filter "*.ps1" -Recurse -ErrorAction SilentlyContinue ) 
    foreach ($Import in @($Functions)) {
        try {
            . $Import.fullname
        } catch {
            throw "Could not import function $($Import.fullname): $_"
        }
    }
}

# Set API parameters
If ($base_uri -and $apiKey) {
    Set-DdbpApiParameters -base_uri $base_uri -apiKey $apiKey
}
