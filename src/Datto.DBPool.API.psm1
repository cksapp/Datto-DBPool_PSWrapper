# This section is used to dot source all the module functions for development
if (Test-Path -Path $(Join-Path -Path $PSScriptRoot -ChildPath 'Public')) {
    # Directories to import from
    $directory = 'Public', 'Private'

    # Import functions
    $functionsToExport = @()
    $aliasesToExport = @()

    foreach ($dir in $directory) {
        $Functions = @( Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath "$dir") -Filter '*.ps1' -Recurse -ErrorAction SilentlyContinue)
        foreach ($Import in @($Functions)) {
            try {
                . $Import.fullname
                $functionsToExport += $Import.BaseName
            } catch {
                throw "Could not import function [$($Import.fullname)]: $_"
                continue
            }
        }
    }

    foreach ($alias in Get-Alias) {
        if ($functionsToExport -contains $alias.Definition) {
            $aliasesToExport += $alias.Name
        }
    }

    if ($functionsToExport.Count -gt 0) {
        Export-ModuleMember -Function $functionsToExport
    }
    if ($aliasesToExport.Count -gt 0) {
        Export-ModuleMember -Alias $aliasesToExport
    }

}
