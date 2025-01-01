---
external help file: Datto.DBPool.API-help.xml
Module Name: Datto.DBPool.API
online version: https://datto-dbpool-api.kentsapp.com/Users/Get-DBPoolUser/
schema: 2.0.0
---

# Get-DBPoolUser

## SYNOPSIS

Get a user from DBPool

## SYNTAX

### Self (Default)

```PowerShell
Get-DBPoolUser [-PlainTextAPIKey] [<CommonParameters>]
```

### User

```PowerShell
Get-DBPoolUser [[-Username] <String[]>] [<CommonParameters>]
```

## DESCRIPTION

The Get-DBPoolUser function is used to get a user details from DBPool.
Will retrieve the current authenticated user details, but can also be used to get other user details by username.

## EXAMPLES

### EXAMPLE 1

This will get the user details for the current authenticated user.

```PowerShell
Get-DBPoolUser
```

```PowerShell
id          : 1234
username    : john.doe
displayName : John Doe
email       : John.Doe@company.tld
apiKey      : System.Security.SecureString
```

### EXAMPLE 2

This will get the user details for the user "John.Doe".

```PowerShell
Get-DBPoolUser -username "John.Doe"
```

```PowerShell
id username  displayName email
-- --------  ----------- -----
1234 john.doe John Doe   John.Doe@company.tld
```

## PARAMETERS

### -PlainTextAPIKey

This switch will return the API Key in plain text.
By default, the API Key is returned as a SecureString.

```yaml
Type: SwitchParameter
Parameter Sets: Self
Aliases:

Required: False
Position: 1
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Username

The username of the user to get details for.
This accepts an array of strings.

```yaml
Type: String[]
Parameter Sets: User
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [string] - The username of the user to get details for

## OUTPUTS

### [PSCustomObject] - The user details from DBPool

## NOTES

Equivalent API endpoint:

- GET /api/v2/self
- GET /api/v2/users/{username}

## RELATED LINKS

[https://datto-dbpool-api.kentsapp.com/Users/Get-DBPoolUser/](https://datto-dbpool-api.kentsapp.com/Users/Get-DBPoolUser/)
