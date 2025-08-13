properties {
    $PSBPreference.General.SrcRootDir = 'src'
    $PSBPreference.General.ModuleName = 'Datto.DBPool.API'
    $PSBPreference.Build.OutDir = "$projectRoot"
    # Set this to $true to create a module with a monolithic PSM1
    $PSBPreference.Build.CompileModule = $true
    $PSBPreference.Build.CompileScriptHeader = "#Region" + [System.Environment]::NewLine
    $PSBPreference.Build.CompileScriptFooter = [System.Environment]::NewLine + "#EndRegion"

    # May need to exclude some files from the build and then concatenate them at end of build for MacOS
#    $PSBPreference.Build.Exclude = @('Initialize-DBPoolModuleSettings.ps1')
    $PSBPreference.Help.DefaultLocale = 'en-US'
    $PSBPreference.Test.OutputFile = 'out/testResults.xml'
    $PSBPreference.Test.ImportModule = $true
    $PSBPreference.Docs.RootDir = "./docs/generated"
}

task Default -depends Test

Task UpdateFunctionsToExport -depends StageFiles {
    Write-Host 'Updating module manifest to update FunctionsToExport section'

    $exportDirectory = 'Public', 'Private'
    $allFunctions = New-Object System.Collections.ArrayList

    foreach ($directory in $exportDirectory) {
        $directoryPath = Join-Path -Path $env:BHPSModulePath -ChildPath $directory
        $pattern = Join-Path -Path $directoryPath -ChildPath '*.ps1'
        $functions = Get-ChildItem -Path $pattern -Recurse -ErrorAction SilentlyContinue
        $allFunctions.AddRange($functions) | Out-Null
    }

    if ($allFunctions) {
        $modulePath_Built = Join-Path -Path $env:BHBuildOutput -ChildPath $( $env:BHProjectName + '.psd1' )

        # Update FunctionsToExport with all functions in the module
        Update-Metadata -Path $modulePath_Built -PropertyName FunctionsToExport -Value $allFunctions.BaseName

        Write-Host 'Module manifest updated successfully'
    }
}

# Task AddModuleData {}

Task Build -FromModule PowerShellBuild -depends @('StageFiles', 'UpdateFunctionsToExport', 'BuildHelp')

task Test -FromModule PowerShellBuild -minimumVersion '0.6.1'

<#
task RemoveNestedModules -depends StageFiles {
    $modulePath_Built = Join-Path -Path $env:BHBuildOutput -ChildPath $( $env:BHProjectName + '.psd1' )

    Write-Host 'Updating module manifest to remove NestedModules section'

    # Replace & comment out NestedModules from nonBuilt module
    Update-Metadata -Path $modulePath_Built -PropertyName NestedModules -Value  @()
    (Get-Content -Path $modulePath_Built -Raw) -replace 'NestedModules = @\(\)', '# NestedModules = @()' | Set-Content -Path $modulePath_Built

    Write-Host "Module manifest updated successfully"
}
#>

task PublishDocs -depends Build {
    exec {
        docker run -v "$($psake.build_script_dir)`:/docs" -e 'CI=true' --entrypoint 'sh' squidfunk/mkdocs-material:9 -c 'pip install -r requirements.txt && mkdocs gh-deploy --force'
    }
}
