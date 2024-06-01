function Get-DBPoolApiKey {
    <#
    .SYNOPSIS
        Gets the DBPool API key global variable.

    .DESCRIPTION
        The Get-DBPoolApiKey cmdlet gets the DBPool API key global variable and returns this as an object.

    .PARAMETER plainText
        Decrypt and return the API key in plain text.

    .EXAMPLE
        Get-DBPoolApiKey

        Gets the DBPool API key global variable and returns this as an object with the secret key as a SecureString.

    .EXAMPLE
        Get-DBPoolApiKey -plainText

        Gets the DBPool API key global variable and returns this as an object with the secret key as plain text.


    .NOTES
        N\A

    .LINK
        N/A
#>

    [cmdletbinding()]
    Param (
        [Parameter(
            Mandatory = $false
        )]
        [Switch]$plainText
    )

    begin {}

    process {

        try {

            if ($DBPool_ApiKey) {

                if ($plainText) {
                    $Api_Key = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DBPool_ApiKey)

                    [PSCustomObject]@{
                        "X-App-Apikey" = ( [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Api_Key) ).ToString()
                    }
                } else {
                    [PSCustomObject]@{
                        "X-App-Apikey" = $DBPool_ApiKey
                    }
                }

            } else {
                Write-Warning "The DBPool API [ secret ] key is not set. Run Add-DBPoolApiKey to set the API key." 
            }

        } catch {
            Write-Error $_
        } finally {
            if ($Api_Key) {
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($Api_Key)
            }
        }

    }

    end {}
}