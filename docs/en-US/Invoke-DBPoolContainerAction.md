---
external help file: Datto-DBPool_API-help.xml
Module Name: Datto-DBPool_API
online version:
schema: 2.0.0
---

# Invoke-DBPoolContainerAction

## SYNOPSIS
The Invoke-DBPoolContainerAction function is used to interact with various container action operations in the Datto DBPool API.

## SYNTAX

```
Invoke-DBPoolContainerAction [-Action] <String> [-Id] <Int32[]> [-Force] [-TimeoutSeconds <Int32>]
 [-ThrottleLimit <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-DBPoolContainerAction function is used to perform actions on a container such as refresh, schema-merge, start, restart, or stop.

## EXAMPLES

### EXAMPLE 1
```
Invoke-DBPoolContainerAction -Action 'restart' -Id '12345'
```

This will restart the container with ID 12345

### EXAMPLE 2
```
Invoke-DBPoolContainerAction refresh 12345,56789
```

This will refresh the containers with ID 12345, and 56789

### EXAMPLE 3
```
Invoke-DBPoolContainerAction -Action refresh -Id (Get-DBPoolContainer).Id -Force
```

This will refresh all containers without prompting for confirmation.

## PARAMETERS

### -Action
The action to perform on the container.
Valid actions are: refresh, schema-merge, start, restart, or stop.

Start, Stop, and Restart are all considered minor actions and will not require a confirmation prompt.
Refresh and Schema-Merge are considered major actions and will require a confirmation prompt.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
The ID(s) of the container(s) to perform the action on.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: ContainerId

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Force
Skip the confirmation prompt for major actions, such as 'Refresh' and 'Schema-Merge'.

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

### -TimeoutSeconds
The maximum time in seconds to wait for the action to complete.
Default is 3600 seconds (60 minutes).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 3600
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThrottleLimit
The maximum number of containers to process in parallel.
Default is twice the number of processor cores.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: ([Environment]::ProcessorCount * 2)
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [int] - The ID of the container to perform the action on.
### [string] - The action to perform on the container.
## OUTPUTS

### [void] - No output is returned.
## NOTES
Actions:

    refresh:
        Recreate the Docker container and ZFS snapshot for the container.

    schema-merge:
        Attempt to apply upstream changes to the parent container to this child container.
        This may break your container.
Refreshing a container is the supported way to update a child container's database schema.

    start:
        Start the Docker container for the container.

    restart:
        Stop and start the Docker container.

    stop:
        Stop the Docker container.

## RELATED LINKS

[N/A]()

