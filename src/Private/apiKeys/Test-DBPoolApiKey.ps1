function Test-DBPoolApiKey {
<#
    .SYNOPSIS
        Test the DBPool API Key.

    .DESCRIPTION
        The Test-DBPoolApiKey cmdlet tests the base URI & API Key that were defined in the Add-DBPoolBaseURI & Add-DBPoolAPIKey cmdlets.

    .PARAMETER base_uri
        Define the base URI for the DBPool API connection using Datto's DBPool URI or a custom URI.

        The default base URI is https://dbpool.datto.net/api

    .INPUTS
        [string] - base_uri

    .OUTPUTS
        [PSCustomObject] - Various API metadata values

    .EXAMPLE
        Test-DBPoolApiKey

        Tests the base URI & API key that was defined in the Add-DBPoolBaseURI & Add-DBPoolAPIKey cmdlets.

        The default full base uri test path is:
            https://dbpool.datto.net/api/v2/self

    .EXAMPLE
        Test-DBPoolApiKey -base_uri http://dbpool.example.com

        Tests the base URI & API key that was defined in the Add-DBPoolBaseURI & Add-DBPoolAPIKey cmdlets.

        The full base uri test path in this example is:
            http://dbpool.example.com/api/v2/self

    .NOTES
        N/A

    .LINK
        N/A
#>

    [cmdletbinding()]
    [OutputType([PSCustomObject])]
    Param (
        [parameter( Position = 0, Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Define the base URI for the DBPool connection. Default is Datto's DBPool URI or set a custom URI." )]
        [string]$base_uri = $DBPool_Base_URI
    )

    begin { $resource_uri = "/api/v2/self" }

    process {

        try {

            $api_key = $(Get-DBPoolAPIKey -AsPlainText).'API_Key'
            $DBPool_Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"

            $DBPool_Headers.Add("Content-Type", 'application/json')
            $DBPool_Headers.Add('X-App-Apikey', $api_key)

            $rest_output = Invoke-WebRequest -method Get -uri ($base_uri + $resource_uri) -headers $DBPool_Headers -ErrorAction Stop
        }
        catch {

            [PSCustomObject]@{
                Method = $_.Exception.Response.Method
                StatusCode = $_.Exception.Response.StatusCode.value__
                StatusDescription = $_.Exception.Response.StatusDescription
                Message = $_.Exception.Message
                URI = $($DBPool_Base_URI + $resource_uri)
            }

        }
        finally {
            Remove-Variable -Name DBPool_Headers -Force
        }

        if ($rest_output){
            $data = @{}
            $data = $rest_output

            [PSCustomObject]@{
                StatusCode = $data.StatusCode
                StatusDescription = $data.StatusDescription
                URI = $($DBPool_Base_URI + $resource_uri)
            }
        }

    }

    end {}

}
