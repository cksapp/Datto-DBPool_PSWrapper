function Get-DBPoolMetaData {
<#
    .SYNOPSIS
        Gets various API metadata values

    .DESCRIPTION
        The Get-DBPoolMetaData cmdlet gets various API metadata values from an
        Invoke-WebRequest to assist in various troubleshooting scenarios such
        as rate-limiting.

    .PARAMETER base_uri
        Define the base URI for the DBPool API connection using Datto's DBPool URI or a custom URI.

        The default base URI is https://dbpool.datto.net

    .PARAMETER resource_uri
        Define the resource URI for the DBPool API connection.

        The default resource URI is /api/v2/self

    .INPUTS
        [string] - base_uri

    .OUTPUTS
        [PSCustomObject] - Various API metadata values

    .EXAMPLE
        Get-DBPoolMetaData

        Gets various API metadata values from an Invoke-WebRequest to assist
        in various troubleshooting scenarios such as rate-limiting.

        The default full base uri test path is:
            https://dbpool.datto.net

    .EXAMPLE
        Get-DBPoolMetaData -base_uri http://dbpool.example.com

        Gets various API metadata values from an Invoke-WebRequest to assist
        in various troubleshooting scenarios such as rate-limiting.

        The full base uri test path in this example is:
            http://dbpool.example.com/api/v2/self

    .NOTES
        N/A

    .LINK
        https://datto-dbpool-api.kentsapp.com/Internal/apiCalls/Get-DBPoolMetaData/
#>

    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        [parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]$base_uri = $DBPool_Base_URI,

        [string]$resource_uri = '/api/v2/self'
    )

    begin {

        $method       = 'GET'

    }

    process {

        try {

            $api_Key = $(Get-DBPoolAPIKey -AsPlainText).'ApiKey'

            $DBPool_Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
            $DBPool_Headers.Add("Content-Type", 'application/json')
            $DBPool_Headers.Add('X-App-APIkey', $api_Key)

            $response = Invoke-WebRequest -method $method -uri ($base_uri + $resource_uri) -headers $DBPool_Headers -ErrorAction Stop
        }
        catch {

            [PSCustomObject]@{
                URI               = $($base_uri + $resource_uri)
                Method            = $method
                StatusCode        = $_.Exception.Response.StatusCode.value__
                StatusDescription = $_.Exception.Response.ReasonPhrase
                Message           = $_.Exception.Message
            }

        }
        finally {
            Remove-Variable -Name DBPool_Headers -Force
        }

        if ($response){
            $data = @{}
            $data = $response

            [PSCustomObject]@{
                RequestUri              = $($DBPool_Base_URI + $resource_uri)
                StatusCode              = $data.StatusCode
                StatusDescription       = $data.StatusDescription
                'Content-Type'          = $data.headers.'Content-Type'
                'X-App-Request-Id'      = $data.headers.'X-App-Request-Id'
                <#'X-API-Limit-Remaining' = $data.headers.'X-API-Limit-Remaining'
                'X-API-Limit-Resets'    = $data.headers.'X-API-Limit-Resets'
                'X-API-Limit-Cost'      = $data.headers.'X-API-Limit-Cost'#>
                raw                     = $data
            }
        }

    }

    end {}
}
