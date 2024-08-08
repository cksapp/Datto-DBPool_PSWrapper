properties {
    $PSBPreference.General.SrcRootDir = 'src'
    # Set this to $true to create a module with a monolithic PSM1
    $PSBPreference.Build.CompileModule = $true
    $PSBPreference.Build.CompileScriptHeader = '### BEGIN REGION ###'
    $PSBPreference.Build.CompileScriptFooter = '### END REGION ###'
    $PSBPreference.Help.DefaultLocale = 'en-US'
    $PSBPreference.Test.OutputFile = 'out/testResults.xml'
}

task Default -depends Test

task Test -FromModule PowerShellBuild -minimumVersion '0.6.1'
