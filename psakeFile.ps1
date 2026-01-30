properties {
    $PSBPreference.General.SrcRootDir = 'src'
    $PSBPreference.General.ModuleName = 'Datto.DBPool.API'
    $PSBPreference.Build.OutDir = "$projectRoot"
    # Set this to $true to create a module with a monolithic PSM1
    $PSBPreference.Build.CompileModule = $true
    $PSBPreference.Build.CompileScriptHeader = "#Region" + [System.Environment]::NewLine
    $PSBPreference.Build.CompileScriptFooter = [System.Environment]::NewLine + "#EndRegion"

    # Exclude Initialize file from normal compilation to prevent dependency ordering issues
    # This file will be appended at the end by the AppendInitialization task
    $PSBPreference.Build.Exclude = @('Initialize-DBPoolModuleSetting.ps1')
    $PSBPreference.Help.DefaultLocale = 'en-US'
    $PSBPreference.Test.OutputFile = 'out/testResults.xml'
    $PSBPreference.Test.ImportModule = $true
    $PSBPreference.Docs.RootDir = "./docs/generated"
}

task Default -depends Test

# Custom task to update functions export
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

# Custom task to remove nested modules - run after StageFiles but before GenerateMarkdown
task RemoveNestedModules -depends UpdateFunctionsToExport {
    $modulePath_Built = Join-Path -Path $env:BHBuildOutput -ChildPath $( $env:BHProjectName + '.psd1' )

    Write-Host 'Updating module manifest to remove NestedModules section'
    # Replace & comment out NestedModules from built module
    Update-Metadata -Path $modulePath_Built -PropertyName NestedModules -Value @()
    (Get-Content -Path $modulePath_Built -Raw) -replace 'NestedModules = @\(\)', '# NestedModules = @()' | Set-Content -Path $modulePath_Built
    Write-Host "Module manifest updated successfully"
}

# Custom task to append the Initialize script at the end of the compiled module
# This ensures all function dependencies are defined before the script runs
task AppendInitialization -depends RemoveNestedModules {
    $compiledModulePath = Join-Path -Path $env:BHBuildOutput -ChildPath $( $env:BHProjectName + '.psm1' )
    $initializeScriptPath = Join-Path -Path $env:BHPSModulePath -ChildPath 'Private\moduleSettings\Initialize-DBPoolModuleSetting.ps1'

    if (Test-Path $initializeScriptPath) {
        Write-Host "Appending Initialize script to compiled module for proper dependency order"

        # Read the initialize script content
        $initializeContent = Get-Content -Path $initializeScriptPath -Raw

        # Append to the compiled module with proper region markers
        # Use simple comment format to avoid path interpretation issues
        $appendContent = @"

# Region: Initialize-DBPoolModuleSetting.ps1
$initializeContent
# EndRegion: Initialize-DBPoolModuleSetting.ps1
"@
        Add-Content -Path $compiledModulePath -Value $appendContent
        Write-Host "Initialize script appended successfully"
    } else {
        Write-Warning "Initialize script not found at: $initializeScriptPath"
    }
}

# Override GenerateMarkdown to depend on AppendInitialization
Task GenerateMarkdown -FromModule PowerShellBuild -depends AppendInitialization

# Override Build to include your custom dependencies
Task Build -FromModule PowerShellBuild -depends @('GenerateMarkdown', 'BuildHelp')

# Test task inherits from PowerShellBuild and will depend on Build
task Test -FromModule PowerShellBuild -minimumVersion '0.6.1' -depends Build

task PublishDocs -depends Build {
    exec {
        docker run -v "$($psake.build_script_dir)`:/docs" -e "CI=true" -e "GITHUB_TOKEN=$env:GITHUB_TOKEN" -e "GITHUB_REPOSITORY=$env:GITHUB_REPOSITORY" -e "GITHUB_ACTOR=$env:GITHUB_ACTOR" --entrypoint 'sh' squidfunk/mkdocs-material:9 -c 'set -e; python -m venv /tmp/venv && . /tmp/venv/bin/activate && pip install -r requirements.txt && if [ -z "$GITHUB_TOKEN" ] || [ -z "$GITHUB_REPOSITORY" ]; then echo "GITHUB_TOKEN and GITHUB_REPOSITORY are required for gh-deploy"; exit 1; fi; git config --global user.email "${GITHUB_ACTOR:-github-actions[bot]}@users.noreply.github.com"; git config --global user.name "${GITHUB_ACTOR:-github-actions[bot]}"; git remote set-url origin "https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"; mkdocs gh-deploy --force'
    }
}
