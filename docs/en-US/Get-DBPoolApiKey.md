---
external help file: Datto-DBPool_API-help.xml
Module Name: Datto-DBPool_API
online version:
schema: 2.0.0
---

# Get-DBPoolApiKey

## SYNOPSIS
Gets the DBPool API key global variable.

## SYNTAX

```
Get-DBPoolApiKey [-AsPlainText] [<CommonParameters>]
```

## DESCRIPTION
The Get-DBPoolApiKey cmdlet gets the DBPool API key global variable and returns this as an object.

## EXAMPLES

### EXAMPLE 1
```
Get-DBPoolApiKey
```

Gets the DBPool API key global variable and returns this as an object with the secret key as a SecureString.

### EXAMPLE 2
```
Get-DBPoolApiKey -AsPlainText
```

Gets the DBPool API key global variable and returns this as an object with the secret key as plain text.

## PARAMETERS

### -AsPlainText
Decrypt and return the API key in plain text.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### N/A
## OUTPUTS

### [PSCustomObject] - The DBPool API key global variable.
## NOTES
N\A

## RELATED LINKS

[N/A]()

