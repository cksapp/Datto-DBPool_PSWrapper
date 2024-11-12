#
# Module manifest for module 'Datto-DBPool_API'
#
# Generated by: Kent Sapp
#
# Generated on: 2023-09-26
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'Datto-DBPool_API.psm1'

    # Version number of this module.
    # Follows https://semver.org Semantic Versioning 2.0.0
    # Given a version number MAJOR.MINOR.PATCH, increment the:
    # -- MAJOR version when you make incompatible API changes,
    # -- MINOR version when you add functionality in a backwards-compatible manner, and
    # -- PATCH version when you make backwards-compatible bug fixes.

    # Version number of this module.
    ModuleVersion = '0.01.04'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID = '8c050520-2433-464a-9415-2445197aff4e'

    # Author of this module
    Author = 'Kent Sapp (@CKSapp)'

    # Company or vendor of this module
    # CompanyName = ''

    # Copyright statement for this module
    Copyright = '(c) 2023 Kent Sapp. All rights reserved.'

    # Description of the functionality provided by this module
    Description   = 'This module is designed to make it easier to use the internal Datto DBPool API in your PowerShell scripts. As much of the hard work is done, you can develop your scripts faster and be more effecient.
    There is no need to go through a big learning curve spending lots of time working out how to use the Datto DBPool API.
    Simply load the module, enter your API key and get results within minutes!'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # CLRVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    <#NestedModules = @(
        'Private/Set-DBPoolApiParameters.ps1',
        'Private/Test-DBPoolApi.ps1',

        'Private/apiCalls/ConvertTo-DBPoolQueryString.ps1',
        'Private/apiCalls/Get-DBPoolMetaData.ps1',
        'Private/apiCalls/Invoke-DBPoolRequest.ps1',

        'Private/apiKeys/Add-DBPoolApiKey.ps1',
        'Private/apiKeys/Get-DBPoolApiKey.ps1',
        'Private/apiKeys/Remove-DBPoolApiKey.ps1',
        'Private/apiKeys/Test-DBPoolApiKey.ps1',

        'Private/baseUri/Add-DBPoolBaseUri.ps1',
        'Private/baseUri/Get-DBPoolBaseUri.ps1',
        'Private/baseUri/Remove-DBPoolBaseUri.ps1',

        'Private/moduleSettings/Export-DBPoolModuleSettings.ps1',
        'Private/moduleSettings/Get-DBPoolModuleSettings.ps1',
        'Private/moduleSettings/Import-DBPoolModuleSettings.ps1',
        'Private/moduleSettings/Initialize-DBPoolModuleSettings.ps1',
        'Private/moduleSettings/Remove-DBPoolModuleSettings.ps1',

        'Public/Containers/Containers/Get-DBPoolContainer.ps1',
        'Public/Containers/Containers/New-DBPoolContainer.ps1',
        'Public/Containers/Containers/Remove-DBPoolContainer.ps1',
        'Public/Containers/Containers/Rename-DBPoolContainer.ps1',

        'Public/Containers/Containers/access/Invoke-DBPoolContainerAccess.ps1',

        'Public/Containers/Containers/actions/Invoke-DBPoolContainerAction.ps1',

        'Public/Debug/Invoke-DBPoolDebug.ps1',

        'Public/OpenAPI/Get-DBPoolOpenAPI.ps1',

        'Public/Users/Get-DBPoolUser.ps1'
    )#>

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = '*'

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = '*'

    # Variables to export from this module
    VariablesToExport = '*'

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = '*'

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('Datto', 'Internal', 'DBPool', 'DattoDBPool', 'Containers', 'Database', 'API')

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/cksapp/Datto-DBPool_PSWrapper/blob/main/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/cksapp/Datto-DBPool_PSWrapper'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            # ReleaseNotes = ''

            # Prerelease string of this module
            Prerelease = 'BETA'

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    HelpInfoURI = 'https://github.com/cksapp/Datto-DBPool_PSWrapper/blob/main/README.md'

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = 'Datto' # As of 2024-08 the 'Import-Module' cmdlet does not support $null -Prefix parameter

}
