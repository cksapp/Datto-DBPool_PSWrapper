<#
.SYNOPSIS
    Checks if the override.env file exists and imports the variables to current session
.DESCRIPTION
    This allows for a user specified file location for 
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
        [Parameter( 
            Mandatory = $false, 
            Position = 0, 
            ValueFromPipeline = $true, 
            ValueFromPipelineByPropertyName = $true, 
            HelpMessage = "The path for environment override file."
        )]
        [String]
        $envFilePath,

        [Parameter( 
            Mandatory = $false, 
            Position = 1, 
            ValueFromPipeline = $true, 
            ValueFromPipelineByPropertyName = $true, 
            HelpMessage = "The environment override file name."
        )]
        [String]
        $envFileName,

        [Parameter( 
            Mandatory = $false, 
            Position = 2, 
            ValueFromPipeline = $true, 
            ValueFromPipelineByPropertyName = $true, 
            HelpMessage = "The environment override file filter. Defaults to remove lines begining with `#` comments"
        )]
        [regex]
        $envFilter
        
    )
    
    begin {
        # Set the variables used
        $currentLocation = Get-Location
        $envFileName = "override.env"
        $envFilePath = Convert-Path (Join-Path -Path $currentLocation -ChildPath $envFileName)
        $envFilter = '^\s*#'

        if (Test-Path -Path $envFilePath -PathType Leaf) {
            $envContent = Get-Content -Path $envFilePath | Where-Object { $_ -notmatch $envFilter }
        
        } else {
            Write-Verbose -Message "Override file does not exist at $envFilePath"
        }
        Continue
    }
<#    
    process {
        foreach ($line in $envContent) {
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
        # Check if the variable $p_apiKey exists from override.env file, otherwise ask the user for their API key
        if (-not (Test-Path variable:apiKey)) {
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
    #>
    end {
        return $envContent
    }
}