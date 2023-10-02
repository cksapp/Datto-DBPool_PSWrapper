<#
.SYNOPSIS
    Specify security protocols
.DESCRIPTION
    Sets the Security Protocol for a .NET application to use TLS 1.2 by default.
.NOTES
    Make sure to run this function in the appropriate context, as it affects .NET-wide security settings.
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Set-SecurityProtocol -Protocol Tls12
    Sets the Security Protocol to use TLS 1.2.
    
    Set-SecurityProtocol -Protocol SystemDefault
    Sets the Security Protocol to use the system default.
.PARAMETER
#>

function Set-SecurityProtocol {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateSet('Ssl3', 'SystemDefault', 'Tls', 'Tls11', 'Tls12', 'Tls13')]
        [string]
        $Protocol = 'SystemDefault'
    )
    
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::$Protocol
        Write-Verbose "Security Protocol set to: $Protocol"
    } catch {
        Write-Error "Failed to set Security Protocol. $_"
    }
}