function New-ApiRequest {
    <#
    .SYNOPSIS
        Makes a API request.
    .DESCRIPTION
        Returns the API response.
    .PARAMETER ApiMethod
        Provide API Method GET, PUT or POST
    .PARAMETER ApiRequest
        See Datto DBPool API docs
    .PARAMETER ApiRequestBody
        Only used with PUT and POST request
    .INPUTS
        $DBPool_Base_URI = The API URL
        $DBPool_ApiKey = The API Key
    .OUTPUTS
        API response
    #>  

    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(
            Mandatory = $True,
            ValueFromPipeline = $True
        )]
        [ValidateSet(
            'DEFAULT', 
            'DELETE', 
            'GET', 
            'HEAD', 
            'PATCH', 
            'POST', 
            'PUT'
        )]
        [string]$apiMethod,

        [Parameter(
            Mandatory = $True,
            ValueFromPipeline = $True
        )]
        [string]$apiRequest,

        [Parameter(
            Mandatory = $False,
            ValueFromPipeline = $True
        )]
        [string]$apiRequestBody<#,

        [Parameter(
            Mandatory = $False,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True
        )]
        $DBPool_Base_URI,

        [Parameter(
            Mandatory = $False,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True
        )]
        $DBPool_ApiKey#>
    )

    Begin {
        # Check API Parameters
        Write-Verbose -Message "Checking variables for $DBPool_Base_URI & $DBPool_ApiKey"
        if (!($DBPool_Base_URI -or $DBPool_ApiKey)) {
            Write-Output "API Parameters missing, please run Set-DdbpApiParameters first!"
            break
        }
    }

    Process {
        Write-Verbose -Message "Using Uri $DBPool_Base_URI"
        # Define parameters for Invoke-WebRequest cmdlet
        $params = [ordered] @{
            Uri         = '{0}{1}' -f $DBPool_Base_URI, $apiRequest
            Method      = $apiMethod
            ContentType = 'application/json'
            Headers = @{
                "X-App-Apikey" = "[System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DBPool_ApiKey))"
            }
        }

        # Add body to parameters if present
        If ($apiRequestBody) { $params.Add('Body', $apiRequestBody) }

        # Check if the action should proceed
        if ($PSCmdlet.ShouldProcess("$apiMethod`: $($params['Uri'])"))
        {
            $maxRetries = 3  # Maximum number of retries    
            $retryCount = 0

            do
            {
                try
                {
                    $response = Invoke-WebRequest -UseBasicParsing @params
                    $content = [System.Text.Encoding]::UTF8.GetString($response.RawContentStream.ToArray())
                    return $content  # Return successful response content and exit the function
                }
                catch
                {
                    $errorObject = $_
                    $exceptionError = $_.Exception.Message

                    switch ($exceptionError)
                    {
                        'The remote server returned an error: (429).'
                        {
                            Write-Warning 'New-ApiRequest : API rate limit breached, sleeping for 60 seconds'
                            Start-Sleep -Seconds 60
                        }
                        'The remote server returned an error: (403) Forbidden.'
                        {
                            Write-Warning 'New-ApiRequest : AWS DDOS protection breached, sleeping for 5 minutes'
                            Start-Sleep -Seconds 300
                        }
                        'The remote server returned an error: (404) Not Found.'
                        {
                            Write-Error "New-ApiRequest : $apiRequest not found!"
                            return
                        }
                        'The remote server returned an error: (504) Gateway Timeout.'
                        {
                            Write-Warning "New-ApiRequest : Gateway Timeout, sleeping for 60 seconds"
                            Start-Sleep -Seconds 60
                        }
                        default
                        {
                            Write-Error $errorObject
                            return
                        }
                    }
                }

                $retryCount++
                if ($retryCount -lt $maxRetries)
                {
                    Write-Warning "New-ApiRequest : Retrying API request $apiRequest (Attempt $retryCount of $maxRetries)"
                }
                else
                {
                    Write-Error "New-ApiRequest : Maximum retry attempts reached."
                    break
                }
            } while ($retryCount -lt $maxRetries)
        }
    }
}