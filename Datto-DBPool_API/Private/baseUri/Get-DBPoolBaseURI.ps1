function Get-DBPoolBaseURI {
<#
    .SYNOPSIS
        Shows the DBPool base URI global variable.

    .DESCRIPTION
        The Get-DBPoolBaseURI cmdlet shows the DBPool base URI global variable value.

    .EXAMPLE
        Get-DBPoolBaseURI

        Shows the DBPool base URI global variable value.

    .NOTES
        N/A

    .LINK
        N/A
#>

    [cmdletbinding()]
    Param ()

    begin {}

    process {

        switch ([bool]$DBPool_Base_URI) {
            $true   { $DBPool_Base_URI }
            $false  { Write-Warning "The DBPool base URI is not set. Run Add-DBPoolBaseURI to set the base URI." }
        }

    }

    end {}

}