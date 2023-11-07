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

function Sync-Containers
{
    [CmdletBinding()]
    param (
        [Parameter( 
            Position = 0,
            Mandatory = $False,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True
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
        [int]$id
    )
    
    Begin {
        # Check API Parameters
        Write-Verbose -Message "Api URL is $apiUrl"
        if (!($apiUrl) -or !($apiKey)){
            Write-Output "API Parameters missing, please run Set-DdbpApiParameters first!"
            break
        }
    }
    
    Process {
        Write-Output "Refreshing container ID: $id"
        try{
            $apiRefresh = New-ApiRequest -apiUrl $apiUrl -apiKey $apiKey -apiMethod post -apiRequest "containers/$id/actions/refresh" -ErrorAction Stop | ConvertFrom-Json
            Write-Output "Successfully refreshed container ID: $id"
            Write-Verbose -Message "Response: $apiRefresh"
        }
        catch{
            $errorMessage = $_.Exception.Response
            $errorCode = $errorMessage.StatusCode
            Write-Error "Error refreshing container ID $id`: (Status Code: $errorCode)"
        }
    }
    
    End {
        Return Write-Output $apiRefresh
    }
}