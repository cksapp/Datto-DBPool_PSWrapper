function Remove-DBPoolBaseURI {
<#
    .SYNOPSIS
        Removes the DBPool base URI global variable.

    .DESCRIPTION
        The Remove-DBPoolBaseURI cmdlet removes the DBPool base URI global variable.

    .EXAMPLE
        Remove-DBPoolBaseURI

        Removes the DBPool base URI global variable.

    .NOTES
        N/A

    .LINK
        N/A
#>

    [cmdletbinding(SupportsShouldProcess)]
    Param ()

    begin {}

    process {

        switch ([bool]$DBPool_Base_URI) {
            $true   { Remove-Variable -Name "DBPool_Base_URI" -Scope global -Force }
            $false  { Write-Warning "The DBPool base URI variable is not set. Nothing to remove" }
        }

    }

    end {}

}