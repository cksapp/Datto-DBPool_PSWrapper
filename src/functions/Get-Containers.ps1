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
        [Parameter( 
            Position = 0, 
            Mandatory = $False, 
            ValueFromPipeline = $True, 
            ValueFromPipelineByPropertyName = $True, 
            HelpMessage = "The URL of the API to be checked."
        )]
        [string]$apiUrl,

        [Parameter( 
            Position = 1, 
            Mandatory = $False,
            ValueFromPipeline = $True, 
            ValueFromPipelineByPropertyName = $True, 
            HelpMessage = "API Key for authorization."
        )]
        [string]$apiKey,

        [Parameter(
            Mandatory = $False,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True
        )]
        $varScope = "Global"
    )
    
    Begin {
        # Check API Parameters
        Write-Verbose -Message "Api URL is $apiUrl"
        if (!($apiUrl) -or !($apiKey))
        {
            Write-Output "API Parameters missing, please run Set-DdbpApiParameters first!"
            break
        }
    }
    
    Process {
        $DBPool = New-ApiRequest -apiUrl $apiUrl -apiKey $apiKey -apiMethod Get -apiRequest "containers" | ConvertFrom-Json
        # Display the response content
        Write-Verbose -Message " Getting containers for $DBPool.containers"
        
        <#foreach ($container in $DBPool.containers){
            Write-Output "Container Name: $($container.name)"
            Write-Output "Container ID: $($container.id)"`n
        }#>

    }
    
    End {
        Set-Variable -Name "Containers" -Value $($DBPool.containers) -Force -Scope $varScope
        Return Write-Output $Containers
    }
}