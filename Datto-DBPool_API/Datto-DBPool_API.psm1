# This section is used to dot source all the module functions for development
#<#
$directory = "Public", "Private"
foreach ($dir in $directory) {
    $dirPath = Join-Path -Path ($PSScriptRoot) -ChildPath $dir
    $Functions = @( Get-ChildItem -Path $dirPath -Filter "*.ps1" -Recurse -ErrorAction SilentlyContinue ) 
    foreach ($Import in @($Functions)) {
        try {
            . $Import.fullname
        } catch {
            throw "Could not import function $($Import.fullname): $_"
        }
    }
}
#>