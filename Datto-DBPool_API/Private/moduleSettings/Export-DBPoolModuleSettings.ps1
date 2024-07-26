function Export-DBPoolModuleSettings {
<#
    .SYNOPSIS
        Exports the DBPool BaseURI, API Key, & JSON configuration information to file.

    .DESCRIPTION
        The Export-DBPoolModuleSettings cmdlet exports the DBPool BaseURI, API Key, & JSON configuration information to file.

        Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
        that can only be unencrypted with the your Windows account as this encryption is tied to your user principal.
        This means that you cannot copy your configuration file to another computer or user account and expect it to work.

    .PARAMETER DBPoolConfPath
        Define the location to store the DBPool configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\DBPoolAPI

    .PARAMETER DBPoolConfFile
        Define the name of the DBPool configuration file.

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Export-DBPoolModuleSettings

        Validates that the BaseURI, API Key, and JSON depth are set then exports their values
        to the current user's DBPool configuration file located at:
            $env:USERPROFILE\DBPoolAPI\config.psd1

    .EXAMPLE
        Export-DBPoolModuleSettings -DBPoolConfPath C:\DBPoolAPI -DBPoolConfFile MyConfig.psd1

        Validates that the BaseURI, API Key, and JSON depth are set then exports their values
        to the current user's DBPool configuration file located at:
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

    begin {}

    process {

        if (-not ($IsWindows -or $PSEdition -eq 'Desktop') ) {
            Write-Warning "Secrets are stored using Windows Data Protection API (DPAPI)"
            Write-Warning "DPAPI provides user context encryption in Windows but NOT in other operating systems like Linux or UNIX. It is recommended to use a more secure & cross-platform storage method"
        }

        $DBPoolConfig = Join-Path -Path $DBPoolConfPath -ChildPath $DBPoolConfFile

        # Confirm variables exist and are not null before exporting
        if ($DBPool_Base_URI -and $DBPool_ApiKey -and $DBPool_JSON_Conversion_Depth) {
            $secureString = $DBPool_ApiKey | ConvertFrom-SecureString

            if ($IsWindows -or $PSEdition -eq 'Desktop') {
                New-Item -Path $DBPoolConfPath -ItemType Directory -Force | ForEach-Object { $_.Attributes = $_.Attributes -bor "Hidden" }
            } else {
                New-Item -Path $DBPoolConfPath -ItemType Directory -Force
            }
@"
    @{
        DBPool_Base_URI = '$DBPool_Base_URI'
        DBPool_ApiKey = '$secureString'
        DBPool_JSON_Conversion_Depth = '$DBPool_JSON_Conversion_Depth'
    }
"@ | Out-File -FilePath $DBPoolConfig -Force
            Write-Verbose "DBPool Module settings exported to [ $DBPoolConfig ]"
        } else {
            Write-Error "Failed to export DBPool Module settings to [ $DBPoolConfig ]"
            Write-Error $_
            exit 1
        }

    }

    end {}

}