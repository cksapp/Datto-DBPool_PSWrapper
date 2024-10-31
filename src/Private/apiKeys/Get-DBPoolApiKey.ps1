function Get-DBPoolApiKey {
<#
    .SYNOPSIS
        Gets the DBPool API key global variable.

    .DESCRIPTION
        The Get-DBPoolApiKey cmdlet gets the DBPool API key global variable and returns this as an object.

    .PARAMETER AsPlainText
        Decrypt and return the API key in plain text.

    .INPUTS
        N/A

    .OUTPUTS
        [PSCustomObject] - The DBPool API key global variable.

    .EXAMPLE
        Get-DBPoolApiKey

        Gets the DBPool API key global variable and returns this as an object with the secret key as a SecureString.

    .EXAMPLE
        Get-DBPoolApiKey -AsPlainText

        Gets the DBPool API key global variable and returns this as an object with the secret key as plain text.


    .NOTES
        N\A

    .LINK
        N/A
#>

    [cmdletbinding()]
    [OutputType([PSCustomObject])]
    Param (
        [Parameter( Mandatory = $false )]
        [Switch]$AsPlainText
    )

    begin {}

    process {

        try {

            if ($DBPool_ApiKey) {

                if ($AsPlainText) {
                    if ($isWindows -or $PSEdition -eq 'Desktop') {
                        $ApiKeyBSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DBPool_ApiKey)
                        try {
                            $ApiKeyPlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($ApiKeyBSTR)
                            [PSCustomObject]@{
                                "ApiKey" = $ApiKeyPlainText
                            }
                        } finally {
                            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ApiKeyBSTR)
                        }
                    } else {
                        $ApiKeyPlainText = ConvertFrom-SecureString -SecureString $DBPool_ApiKey -AsPlainText

                        [PSCustomObject]@{
                            "ApiKey" = $ApiKeyPlainText
                        }
                    }

                    $ApiKeyPlainText = $null

                } else {
                    [PSCustomObject]@{
                        "ApiKey" = $DBPool_ApiKey
                    }
                }

            } else {
                Write-Warning "The DBPool API [ secret ] key is not set. Run Add-DBPoolApiKey to set the API key."
            }

        } catch {
            Write-Error $_
        } finally {
            if ($ApiKeyBSTR) {
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ApiKeyBSTR)
            }
        }

    }

    end {}
}
