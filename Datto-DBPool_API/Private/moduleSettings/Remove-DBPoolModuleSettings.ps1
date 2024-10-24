function Remove-DBPoolModuleSettings {
<#
    .SYNOPSIS
        Removes the stored DBPool configuration folder.

    .DESCRIPTION
        The Remove-DBPoolModuleSettings cmdlet removes the DBPool folder and its files.
        This cmdlet also has the option to remove sensitive DBPool variables as well.

        By default configuration files are stored in the following location and will be removed:
            $env:USERPROFILE\DBPoolAPI

    .PARAMETER DBPoolConfPath
        Define the location of the DBPool configuration folder.

        By default the configuration folder is located at:
            $env:USERPROFILE\DBPoolAPI

    .PARAMETER andVariables
        Define if sensitive DBPool variables should be removed as well.

        By default the variables are not removed.

    .INPUTS
        N/A

    .OUTPUTS
        N/A

    .EXAMPLE
        Remove-DBPoolModuleSettings

        Checks to see if the default configuration folder exists and removes it if it does.

        The default location of the DBPool configuration folder is:
            $env:USERPROFILE\DBPoolAPI

    .EXAMPLE
        Remove-DBPoolModuleSettings -DBPoolConfPath C:\DBPoolAPI -andVariables

        Checks to see if the defined configuration folder exists and removes it if it does.
        If sensitive DBPool variables exist then they are removed as well.

        The location of the DBPool configuration folder in this example is:
            C:\DBPoolAPI

    .NOTES
        N/A

    .LINK
        N/A
#>

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'set')]
    [OutputType([void])]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$DBPoolConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"DBPoolAPI"}else{".DBPoolAPI"}) ),

        [Parameter(ParameterSetName = 'set')]
        [switch]$andVariables
    )

    begin {}

    process {

        if (Test-Path $DBPoolConfPath) {

            Remove-Item -Path $DBPoolConfPath -Recurse -Force -WhatIf:$WhatIfPreference

            If ($andVariables) {
                Remove-DBPoolAPIKey
                Remove-DBPoolBaseURI
            }

            if (!(Test-Path $DBPoolConfPath)) {
                Write-Output "The DBPoolAPI configuration folder has been removed successfully from [ $DBPoolConfPath ]"
            }
            else {
                Write-Error "The DBPoolAPI configuration folder could not be removed from [ $DBPoolConfPath ]"
            }

        }
        else {
            Write-Warning "No configuration folder found at [ $DBPoolConfPath ]"
        }

    }

    end {}

}