<#
.SYNOPSIS
    List your child containers
.DESCRIPTION
    Make an API request with the provided API key to get all containers
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Test-MyTestFunction -Verbose
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>

function Get-Containers {
    [CmdletBinding()]
    param (
        
    )
    
    begin {

    }
    
    process {
        $getContainers = Invoke-WebRequest -Uri $apiUrl -Headers $headers -Method Get
        # Display the response content
        #Write-Host $getContainers.Content
        
        # Convert JSON response to PowerShell object
        $json = ConvertFrom-Json $getContainers
    }
    
    end {
        
    }
}