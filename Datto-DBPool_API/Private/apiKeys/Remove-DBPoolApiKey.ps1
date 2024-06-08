function Remove-DBPoolApiKey {
<#
    .SYNOPSIS
        Removes the DBPool API key global variable.

    .DESCRIPTION
        The Remove-DBPoolAPIKey cmdlet removes the DBPool API key global variable.

    .EXAMPLE
        Remove-DBPoolAPIKey

        Removes the DBPool API key global variable.

    .NOTES
        N/A

    .LINK
        N/A
#>

    [cmdletbinding(SupportsShouldProcess)]
    Param ()

    begin {}

    process {

        switch ([bool]$DBPool_ApiKey) {
            $true   {
                Write-Verbose "Removing the DBPool API Key."
                Remove-Variable -Name "DBPool_ApiKey" -Scope global -Force
            }
            $false  {
                Write-Warning "The DBPool API [ secret ] key is not set. Nothing to remove"
            }
        }

    }

    end {}

}