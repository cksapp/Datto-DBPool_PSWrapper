function Remove-DBPoolApiKey {
<#
    .SYNOPSIS
        Removes the DBPool API Key global variable.

    .DESCRIPTION
        The Remove-DBPoolAPIKey cmdlet removes the DBPool API Key global variable.

    .PARAMETER Force
        Forces the removal of the DBPool API Key global variable without prompting for confirmation.

    .INPUTS
        N/A

    .OUTPUTS
        N/A

    .EXAMPLE
        Remove-DBPoolAPIKey

        Removes the DBPool API Key global variable.

    .NOTES
        N/A

    .LINK
        N/A
#>

    [cmdletbinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType([void])]
    Param (
        [switch]$Force
    )

    begin {}

    process {

        switch ([bool]$DBPool_ApiKey) {
            $true   {
                if ($Force -or $PSCmdlet.ShouldProcess('DBPool_ApiKey', 'Remove variable')) {
                    Write-Verbose 'Removing the DBPool API Key.'
                    try {
                        Remove-Variable -Name 'DBPool_ApiKey' -Scope Global -Force
                    }
                    catch {
                        Write-Error $_
                    }
                }
            }
            $false  {
                Write-Warning "The DBPool API [ secret ] key is not set. Nothing to remove"
            }
        }

    }

    end {}

}