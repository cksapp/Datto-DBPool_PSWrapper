function Remove-DBPoolBaseURI {
<#
    .SYNOPSIS
        Removes the DBPool base URI global variable.

    .DESCRIPTION
        The Remove-DBPoolBaseURI cmdlet removes the DBPool base URI global variable.

    .PARAMETER Force
        Forces the removal of the DBPool base URI global variable without prompting for confirmation.

    .INPUTS
        N/A

    .OUTPUTS
        [void] - No output is returned.

    .EXAMPLE
        Remove-DBPoolBaseURI

        Removes the DBPool base URI global variable.

    .NOTES
        N/A

    .LINK
        https://datto-dbpool-api.kentsapp.com/Internal/baseUri/Remove-DBPoolBaseURI/
#>

    [cmdletbinding(SupportsShouldProcess)]
    [OutputType([void])]
    Param ()

    begin {}

    process {

        switch ([bool]$DBPool_Base_URI) {
            $true   { Remove-Variable -Name "DBPool_Base_URI" -Scope Global -Force }
            $false  { Write-Warning "The DBPool base URI variable is not set. Nothing to remove" }
        }

    }

    end {}

}
