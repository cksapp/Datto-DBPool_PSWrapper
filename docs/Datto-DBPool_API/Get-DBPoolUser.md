---
external help file: Datto-DBPool_API-help.xml
Module Name: Datto-DBPool_API
online version:
schema: 2.0.0
---

# Get-DBPoolUser

## SYNOPSIS
Get a user from DBPool

## SYNTAX

### Self (Default)
```
Get-DBPoolUser [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### User
```
Get-DBPoolUser [[-Username] <String[]>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-DBPoolUser function is used to get a user details from DBPool.
Default will get the current authenticated user details, but can be used to get any user details by username.

## EXAMPLES

### EXAMPLE 1
```
Get-DBPoolUser
```

This will get the user details for the current authenticated user.

### EXAMPLE 2
```
Get-DBPoolUser -username "John.Doe"
```

This will get the user details for the user "John.Doe".

## PARAMETERS

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

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N/A

## RELATED LINKS

[N/A]()

