# Datto-DBPool_API PowerShell Module

This PowerShell Module acts as a wrapper for the internal Datto DBPool API.

There is no need to go through a big learning curve spending lots of time working out how to use the Datto DBPool API.

Simply load the module, enter your API key and get results within minutes!

## Overview

This Powershell module acts as a wrapper for the Datto DBPool API, and is designed to make it easier to use the internal DBPool API in your PowerShell scripts. As much of the hard work is done, you can develop your scripts faster and be more effecient.

## Installation

Install using PowerShellGet
```PowerShell
Install-Module -Name 'Datto-DBPool_API'
```

Install using PowerShellGet v3.0 aka 'PSResourceGet'
```Powershell
Install-PSResource -Name 'Datto-DBPool_API'
```

## Examples

### Add your API key

```PowerShell
Add-DBPoolApiKey

cmdlet Add-DBPoolApiKey at command pipeline position 1
Supply values for the following parameters:
(Type !? for Help.)
apiKey: ************************************
```

### Get list of containers

```PowerShell
Get-DBPoolContainer
```

### Refresh all containers

```PowerShell
Invoke-DBPoolContainerAction -Action restart -Id (Get-DBPoolContainer).Id
```
