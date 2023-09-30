    function Set-Tls {

        <#
        .SYNOPSIS
        Sets the security protocols.
    
        .DESCRIPTION
        
    
        #>

# Specify security protocols
# Sets the Security Protocol for a .NET application to use TLS 1.2
    #[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::'Tls12'

    }