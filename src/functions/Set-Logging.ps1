<#
.SYNOPSIS
    A short one-line action-based description, e.g. 'Tests if a function is valid'
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Test-MyTestFunction -Verbose
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines

.PARAMETER logPath
   System path for logging.
#>

function Set-Logging {
    param (
        [string]$logPath = $PSScriptRoot
    )

    # Directory for "logs"
    $logDir = Get-ChildItem $logPath | Where-Object { $_.PSIsContainer -and $_.Name -imatch "logs" }

    # Check if log directory was found
    if ($logDir) {
        # Join the paths and assign to $logDir
        $logDir = Join-Path -Path $logPath -ChildPath $logDir.Name
        Write-Information "Logging to: $logDir" -InformationAction Continue
    } else {
        # Create the directory if not found
        Write-Verbose "Log directory not found"
        $logDir = Join-Path -Path $logPath -ChildPath "logs"
        New-Item -ItemType Directory -Path $logDir | Out-Null
        Write-Information "Directory created: $logDir" -InformationAction Continue
    }
}