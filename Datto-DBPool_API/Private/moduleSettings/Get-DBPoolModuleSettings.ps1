function Get-DBPoolModuleSettings {
<#
    .SYNOPSIS
        Gets the saved DBPool configuration settings

    .DESCRIPTION
        The Get-DBPoolModuleSettings cmdlet gets the saved DBPool configuration settings
        from the local system.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\DBPoolAPI

    .PARAMETER DBPoolConfPath
        Define the location to store the DBPool configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\DBPoolAPI

    .PARAMETER DBPoolConfFile
        Define the name of the DBPool configuration file.

        By default the configuration file is named:
            config.psd1

    .PARAMETER openConfFile
        Opens the DBPool configuration file

    .INPUTS
        N/A

    .OUTPUTS
        [void] - No output is returned.

    .EXAMPLE
        Get-DBPoolModuleSettings

        Gets the contents of the configuration file that was created with the
        Export-DBPoolModuleSettings

        The default location of the DBPool configuration file is:
            $env:USERPROFILE\DBPoolAPI\config.psd1

    .EXAMPLE
        Get-DBPoolModuleSettings -DBPoolConfPath C:\DBPoolAPI -DBPoolConfFile MyConfig.psd1 -openConfFile

        Opens the configuration file from the defined location in the default editor

        The location of the DBPool configuration file in this example is:
            C:\DBPoolAPI\MyConfig.psd1

    .NOTES
        N/A

    .LINK
        N/A
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    [OutputType([void])]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [string]$DBPoolConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"DBPoolAPI"}else{".DBPoolAPI"}) ),

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [String]$DBPoolConfFile = 'config.psd1',

        [Parameter(Mandatory = $false, ParameterSetName = 'show')]
        [Switch]$openConfFile
    )

    begin {
        $DBPoolConfig = Join-Path -Path $DBPoolConfPath -ChildPath $DBPoolConfFile
    }

    process {

        if ( Test-Path -Path $DBPoolConfig ){

            if($openConfFile){
                Invoke-Item -Path $DBPoolConfig
            }
            else{
                Import-LocalizedData -BaseDirectory $DBPoolConfPath -FileName $DBPoolConfFile
            }

        }
        else{
            Write-Verbose "No configuration file found at [ $DBPoolConfig ]"
        }

    }

    end {}

}