function Import-DBPoolModuleSetting {
<#
    .SYNOPSIS
        Imports the DBPool BaseURI, API Key, & JSON configuration information to the current session.

    .DESCRIPTION
        The Import-DBPoolModuleSetting cmdlet imports the DBPool BaseURI, API Key, & JSON configuration
        information stored in the DBPool configuration file to the users current session.

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

    .INPUTS
        N/A

    .OUTPUTS
        N/A

    .EXAMPLE
        Import-DBPoolModuleSetting

        Validates that the configuration file created with the Export-DBPoolModuleSetting cmdlet exists
        then imports the stored data into the current users session.

        The default location of the DBPool configuration file is:
            $env:USERPROFILE\DBPoolAPI\config.psd1

    .EXAMPLE
        Import-DBPoolModuleSetting -DBPoolConfPath C:\DBPoolAPI -DBPoolConfFile MyConfig.psd1

        Validates that the configuration file created with the Export-DBPoolModuleSetting cmdlet exists
        then imports the stored data into the current users session.

        The location of the DBPool configuration file in this example is:
            C:\DBPoolAPI\MyConfig.psd1

    .NOTES
        N/A

    .LINK
        N/A
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$DBPoolConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"DBPoolAPI"}else{".DBPoolAPI"}) ),

        [Parameter(ParameterSetName = 'set')]
        [string]$DBPoolConfFile = 'config.psd1'
    )

    begin {
        $DBPoolConfig = Join-Path -Path $DBPoolConfPath -ChildPath $DBPoolConfFile
    }

    process {

        if ( Test-Path $DBPoolConfig ) {
            $tmp_config = Import-LocalizedData -BaseDirectory $DBPoolConfPath -FileName $DBPoolConfFile

            # Send to function to strip potentially superfluous slash (/)
            Add-DBPoolBaseURI $tmp_config.DBPool_Base_URI

            $tmp_config.DBPool_ApiKey = ConvertTo-SecureString $tmp_config.DBPool_ApiKey

            Set-Variable -Name "DBPool_ApiKey" -Value $tmp_config.DBPool_ApiKey -Option ReadOnly -Scope global -Force

            Set-Variable -Name "DBPool_JSON_Conversion_Depth" -Value $tmp_config.DBPool_JSON_Conversion_Depth -Scope global -Force

            Write-Verbose "DBPoolAPI Module configuration loaded successfully from [ $DBPoolConfig ]"

            # Clean things up
            Remove-Variable "tmp_config"
        }
        else {
            Write-Verbose "No configuration file found at [ $DBPoolConfig ] run Add-DBPoolAPIKey to get started."

            Add-DBPoolBaseURI

            Set-Variable -Name "DBPool_Base_URI" -Value $(Get-DBPoolBaseURI) -Option ReadOnly -Scope global -Force
            Set-Variable -Name "DBPool_JSON_Conversion_Depth" -Value 100 -Scope global -Force
        }

    }

    end {}

}
