---
external help file: Datto.DBPool.API-help.xml
Module Name: Datto.DBPool.API
online version: https://datto-dbpool-api.kentsapp.com/Containers/Get-DBPoolContainer/
schema: 2.0.0
---

# Get-DBPoolContainer

## SYNOPSIS

The Get-DBPoolContainer function retrieves container information from the DBPool API.

## SYNTAX

### ListContainer (Default)

```PowerShell
Get-DBPoolContainer [-ListContainer] [[-Id] <Int32[]>] [-Name <String[]>] [-DefaultDatabase <String[]>]
 [-NotLike] [<CommonParameters>]
```

### ParentContainer

```PowerShell
Get-DBPoolContainer [-ParentContainer] [[-Id] <Int32[]>] [-Name <String[]>] [-DefaultDatabase <String[]>]
 [-NotLike] [<CommonParameters>]
```

### ChildContainer

```PowerShell
Get-DBPoolContainer [-ChildContainer] [<CommonParameters>]
```

### ContainerStatus

```PowerShell
Get-DBPoolContainer [[-Id] <Int32[]>] [-Status] [<CommonParameters>]
```

## DESCRIPTION

This function retrieves container details from the DBPool API.

It can get containers, parent containers, or child containers, and also retrieve containers or container status by ID.
This also can filter or exclude by container name or database.

## EXAMPLES

### EXAMPLE 1

```PowerShell
Get-DBPoolContainer
```

Get a list of all containers from the DBPool API

### EXAMPLE 2

```PowerShell
Get-DBPoolContainer -Id 12345
```

Get a list of containers from the DBPool API by ID

### EXAMPLE 3

```PowerShell
Get-DBPoolContainer -Status
```

Get the status of all containers from the DBPool API

### EXAMPLE 4

```PowerShell
Get-DBPoolContainer -Status -Id 12345, 67890
```

Get the status of an array of containers by IDs

### EXAMPLE 5

```PowerShell
Get-DBPoolContainer -ParentContainer
```

Get a list of parent containers from the DBPool API

### EXAMPLE 6

```PowerShell
Get-DBPoolContainer -ParentContainer -Id 12345
```

Get a list of parent containers from the DBPool API by ID

### EXAMPLE 7

```PowerShell
Get-DBPoolContainer -ChildContainer
```

Get a list of child containers from the DBPool API

### EXAMPLE 8

```PowerShell
Get-DBPoolContainer -Name 'MyContainer'
Get-DBPoolContainer -ParentContainer -Name 'ParentContainer*'
```

Uses 'Where-Object' to get a list of containers from the DBPool API, or parent containers by name
Accepts wildcard input

### EXAMPLE 9

```PowerShell
Get-DBPoolContainer -Name 'MyContainer' -NotLike
Get-DBPoolContainer -ParentContainer -Name 'ParentContainer*' -NotLike
```

Uses 'Where-Object' to get a list of containers from the DBPool API, or parent containers where the name does not match the filter
Accepts wildcard input

### EXAMPLE 10

```PowerShell
Get-DBPoolContainer -DefaultDatabase 'Database'
Get-DBPoolContainer -ParentContainer -DefaultDatabase 'Database*'
```

Get a list of containers from the DBPool API, or parent containers by database
Accepts wildcard input

### EXAMPLE 11

```PowerShell
Get-DBPoolContainer -DefaultDatabase 'Database' -NotLike
Get-DBPoolContainer -ParentContainer -DefaultDatabase 'Database*' -NotLike
```

Get a list of containers from the DBPool API, or parent containers where the database does not match the filter
Accepts wildcard input

## PARAMETERS

### -ListContainer

Retrieves a list of containers from the DBPool API.
This is the default parameter set.

```yaml
Type: SwitchParameter
Parameter Sets: ListContainer
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentContainer

Retrieves a list of parent containers from the DBPool API.

```yaml
Type: SwitchParameter
Parameter Sets: ParentContainer
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ChildContainer

Retrieves a list of child containers from the DBPool API.

```yaml
Type: SwitchParameter
Parameter Sets: ChildContainer
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id

The ID of the container details to get from the DBPool.

```yaml
Type: Int32[]
Parameter Sets: ListContainer, ParentContainer, ContainerStatus
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Status

Gets the status of a container by ID.
Returns basic container details, and dockerContainerRunning, mysqlServiceResponding, and mysqlServiceRespondingCached statuses.

```yaml
Type: SwitchParameter
Parameter Sets: ContainerStatus
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

Filters containers returned from the DBPool API by name.
Accepts wildcard input.

```yaml
Type: String[]
Parameter Sets: ListContainer, ParentContainer
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: True
```

### -DefaultDatabase

Filters containers returned from the DBPool API by database.
Accepts wildcard input.

```yaml
Type: String[]
Parameter Sets: ListContainer, ParentContainer
Aliases: Database

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: True
```

### -NotLike

Excludes containers returned from the DBPool API by Name or DefaultDatabase using the -NotLike switch.
Requires the -Name or -DefaultDatabase parameter to be specified.

Returns containers where the Name or DefaultDatabase does not match the provided filter.

```yaml
Type: SwitchParameter
Parameter Sets: ListContainer, ParentContainer
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

### [int] - Id

The ID of the container to get details for.

### [string] Name

The name of the container to get details for.

### [string] - DefaultDatabase

The database of the container to get details for.

## OUTPUTS

### [PSCustomObject] - The response from the DBPool API

## NOTES

The -Name, and -DefaultDatabase parameters are not native endpoints of the DBPool API.
This is a custom function which uses 'Where-Object', along with the optional -NotLike parameter to return the response using the provided filter.

If no match is found an error is output, and the original response is returned.

Equivalent API endpoint:

- GET `/api/v2/containers`
- GET `/api/v2/parents`
- GET `/api/v2/children`
- GET `/api/v2/containers/{id}`
- GET `/api/v2/containers/{id}/status`

## RELATED LINKS

[https://datto-dbpool-api.kentsapp.com/Containers/Get-DBPoolContainer/](https://datto-dbpool-api.kentsapp.com/Containers/Get-DBPoolContainer/)
