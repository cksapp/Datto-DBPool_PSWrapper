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
    Provide the DBPool API URL
    
    .PARAMETER apiKey
    Provide your API Key as a secure string

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
$directory = "Public", "Private"

# Import functions
$functionsToExport = @()

foreach ($dir in $directory) {
    $Functions = @( Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath "$dir/*ps1") -Recurse -ErrorAction Stop) 
    foreach ($Import in @($Functions)) {
        try {
            . $Import.fullname
            $functionsToExport += $Import.BaseName
        } catch {
            throw "Could not import function [$($Import.fullname)]: $_"
        }
    }
}

Export-ModuleMember -Function $functionsToExport

# Set API parameters
If ($base_uri -and $apiKey) {
    Set-DBPoolApiParameters -base_uri $base_uri -apiKey $apiKey
}