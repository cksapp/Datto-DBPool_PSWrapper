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
        <#[Parameter( 
            Position = 0, 
            Mandatory = $False, 
            ValueFromPipeline = $True, 
            ValueFromPipelineByPropertyName = $True, 
            HelpMessage = "The URL of the API to be checked."
        )]
        [string]$DBPool_Base_URI,

        [Parameter( 
            Position = 1, 
            Mandatory = $False,
            ValueFromPipeline = $True, 
            ValueFromPipelineByPropertyName = $True, 
            HelpMessage = "API Key for authorization."
        )]
        [string]$DBPool_ApiKey,#>

        [Parameter(
            Position = 2,
            Mandatory = $False,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True
        )]
        [string]
        $apiRequest = "/api/v2/containers",

        [Parameter(
            Mandatory = $False,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True
        )]
        $VariableScope = "Script"
    )
    
    Begin {
        # Check if API Parameters are set
        #Write-Verbose -Message "Api URL is $DBPool_Base_URI"
        if (!($DBPool_Base_URI -or $DBPool_ApiKey))
        {
            Write-Output "API Parameters missing, please run Set-DdbpApiParameters first!"
            break
        }
    }
    
    Process {
        $DBPool = Invoke-DBPoolRequest -method GET -resource_Uri $apiRequest
        # Display the response content
        
        Write-Verbose -Message "Getting containers for $($DBPool.containers)"
        foreach ($container in $DBPool.containers){
            Write-Output "Container Name: $($container.name)"
            Write-Output "Container ID: $($container.id)"`n
        }

    }
    
    End {
        Set-Variable -Name "Containers" -Value $($DBPool.containers) -Force -Scope $VariableScope
        Return $Containers
    }
}