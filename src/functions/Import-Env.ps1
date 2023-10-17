<#
.SYNOPSIS
    Checks if the override.env file exists and imports the variables to current session
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Test-MyTestFunction -Verbose
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>

function Import-Env {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        if (Test-Path -Path $envFilePath -PathType Leaf) {
            $envLines = Get-Content -Path $envFilePath
        
            foreach ($line in $envLines) {
                # Skip commented lines that start with `#`
                if ($line -match '^\s*#') {
                    continue
                }
        
                $line = $line.Trim()
                if (-not [string]::IsNullOrWhiteSpace($line) -and $line -match '^(.*?)=(.*)$') {
                    $envName = $matches[1]
                    $envValue = $matches[2]
                    Write-Host "Setting environment variable: $envName=$envValue"
                    [Environment]::SetEnvironmentVariable($envName, $envValue, "Process")
                }
            }
        } else {
            Write-Host "Override file does not exist at $envFilePath"
        }
        
        # Check if the variable $p_apiKey exists from override.env file, otherwise ask the user for their API key
        if (-not (Test-Path variable:p_apiKey)) {
            # If it doesn't exist, ask the user for input
            $apiKeySecure = Read-Host "Please enter your DBPool Personal API Key" -AsSecureString
            # Convert the secure string to a plain text string
            $p_apiKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($apiKeySecure))
            
            # Set environment variable using [Environment]::SetEnvironmentVariable
            [Environment]::SetEnvironmentVariable("apiKey", $p_apiKey, "Process")
        
            # Clear plaintext variable
            $p_apiKey = $null
            # Dispose of the SecureString to minimize its exposure in memory
            $apiKeySecure.Dispose()
        }
    }
    
    process {
        
    }
    
    end {
        
    }
}