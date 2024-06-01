function Add-DBPoolApiKey {
<#
    .SYNOPSIS
        Sets the API key for the DBPool.

    .DESCRIPTION
        The Add-DBPoolApiKey cmdlet sets the API key which is used to authenticate API calls made to DBPool.

        Once the API key is defined, the secret key is encrypted using SecureString.

        The DBPool API key is retrieved via the DBPool UI at My Profile -> API key

    .PARAMETER Api_Key
        Defines your API key for the DBPool.

    .EXAMPLE
        Add-DBPoolApiKey

        Prompts to enter in your personal API key.

    .EXAMPLE
        Add-DBPoolApiKey -Api_Key "0207e066-a779-4849-8aab-0105abf360d8"

        Sets the API key to

    .NOTES
        N/A

    .LINK
        N/A
#>

    [CmdletBinding()]
    [Alias("Set-DBPoolApiKey")]
    param (
        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "API Key for authorization to DBPool."
        )]
        [ValidateNotNullOrEmpty()]
        [securestring]$Api_Key
    )
    
    begin {}
    
    process {
        Write-Verbose "Setting the DBPool API Key."
        Set-Variable -Name "DBPool_ApiKey" -Value $Api_Key -Option ReadOnly -Scope global -Force
    }
    
    end {}
}