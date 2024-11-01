# Datto-DBPool_API

## about_Datto-DBPool_API

# SHORT DESCRIPTION

This PowerShell Module acts as a wrapper for the internal Datto DBPool API.

# LONG DESCRIPTION

This Powershell module acts as a wrapper for the Datto DBPool API, and is designed to make it easier to use the internal DBPool API in your PowerShell scripts. As much of the hard work is done, you can develop your scripts faster and be more effecient.

There is no need to go through a big learning curve spending lots of time working out how to use the Datto DBPool API.

Simply load the module, enter your API key and get results within minutes!

# EXAMPLES

Add your API key

```PowerShell
Add-DBPoolApiKey

cmdlet Add-DBPoolApiKey at command pipeline position 1
Supply values for the following parameters:
(Type !? for Help.)
apiKey: ************************************
```

Get list of containers

```PowerShell
Get-DBPoolContainer
```

```PowerShell
id              : 123456
image           : harbor.datto.net/dbeng/percona-server-dbpool:5.7.39
name            : AdminDB(clone)
power           : True
defaultDatabase : dattoSystem
dateCreated     : @{date=2024-04-26 11:00:22.000000; timezone_type=3; timezone=UTC}
dateStarted     : @{date=2024-10-31 11:00:23.000000; timezone_type=3; timezone=UTC}
dateStopped     :
host            : use1-dbpoolstorage-4.datto.lan
port            : 88588
username        : admin
password        : **REDACTED**
node            : @{id=5; name=use1-dbpoolstorage-4; ip=10.40.95.138; fqdn=use1-dbpoolstorage-4.datto.lan; total_containers=117; powered_on_containers=57; powered_off_containers=60;
                  remaining_containers=43; maximum_containers=100}
parent          : @{id=27; image=harbor.datto.net/dbeng/percona-server-dbpool:5.7.39; name=AdminDB on percona 5.7.23; defaultDatabase=dattoSystem; node=; useNewSync=True; sync=False}
users           : {@{id=2111; username=first.last; displayName=John Doe; email=username@datto.com}}

id              : 987654
image           : harbor.datto.net/dbeng/percona-server-dbpool:5.7.39
name            : DattoAuth-(clone)
power           : True
defaultDatabase : dattoAuth
dateCreated     : @{date=2024-04-26 11:00:20.000000; timezone_type=3; timezone=UTC}
dateStarted     : @{date=2024-10-31 22:41:50.000000; timezone_type=3; timezone=UTC}
dateStopped     :
host            : use1-dbpoolstorage-10.datto.lan
port            : 25525
username        : admin
password        : **REDACTED**
node            : @{id=11; name=use1-dbpoolstorage-10; ip=10.40.144.25; fqdn=use1-dbpoolstorage-10.datto.lan; total_containers=152; powered_on_containers=102; powered_off_containers=50;
                  remaining_containers=118; maximum_containers=220}
parent          : @{id=17; image=harbor.datto.net/dbeng/percona-server-dbpool:5.7.39; name=DattoAuth on percona 5.7.23; defaultDatabase=dattoAuth; node=; useNewSync=True; sync=False}
users           : {@{id=2111; username=first.last; displayName=John Doe; email=username@datto.com}}

id              : 135790
image           : harbor.datto.net/dbeng/percona-server-dbpool:5.7.39
name            : legoDB(clone-1)
power           : True
defaultDatabase : legoCloud
dateCreated     : @{date=2024-04-26 16:50:37.000000; timezone_type=3; timezone=UTC}
dateStarted     : @{date=2024-10-31 11:00:24.000000; timezone_type=3; timezone=UTC}
dateStopped     :
host            : use1-dbpoolstorage-9.datto.lan
port            : 42069
username        : admin
password        : **REDACTED**
node            : @{id=10; name=use1-dbpoolstorage-9; ip=10.40.144.24; fqdn=use1-dbpoolstorage-9.datto.lan; total_containers=141; powered_on_containers=95; powered_off_containers=46;
                  remaining_containers=125; maximum_containers=220}
parent          : @{id=14; image=harbor.datto.net/dbeng/percona-server-dbpool:5.7.39; name=legoDB; defaultDatabase=legoCloud; node=; useNewSync=True; sync=False}
users           : {@{id=2111; username=first.last; displayName=John Doe; email=username@datto.com}}

id              : 102030
image           : harbor.datto.net/dbeng/percona-server-dbpool:5.7.39
name            : legoDB(clone-2)
power           : True
defaultDatabase : legoCloud
dateCreated     : @{date=2024-04-26 11:00:27.000000; timezone_type=3; timezone=UTC}
dateStarted     : @{date=2024-10-31 11:00:25.000000; timezone_type=3; timezone=UTC}
dateStopped     :
host            : use1-dbpoolstorage-10.datto.lan
port            : 23455
username        : admin
password        : **REDACTED**
node            : @{id=11; name=use1-dbpoolstorage-10; ip=10.40.144.25; fqdn=use1-dbpoolstorage-10.datto.lan; total_containers=152; powered_on_containers=102; powered_off_containers=50;
                  remaining_containers=118; maximum_containers=220}
parent          : @{id=14; image=harbor.datto.net/dbeng/percona-server-dbpool:5.7.39; name=legoDB; defaultDatabase=legoCloud; node=; useNewSync=True; sync=False}
users           : {@{id=2111; username=first.last; displayName=John Doe; email=username@datto.com}}
```

Refresh all containers

```PowerShell
Invoke-DBPoolContainerAction -Action refresh -Id (Get-DBPoolContainer).Id -Force
```

```PowerShell
Success: Invoking Action [ restart ] on Container [ ID: 123456 ].
Success: Invoking Action [ restart ] on Container [ ID: 987654 ].
Success: Invoking Action [ restart ] on Container [ ID: 135790 ].
Success: Invoking Action [ restart ] on Container [ ID: 102030 ].
```

# NOTE

N/A

# TROUBLESHOOTING NOTE

There are some endpoints which are not added yet in the PowerShell module, namely those that are not user accessible.

# SEE ALSO
https://github.com/cksapp/Datto-DBPool_PSWrapper

# KEYWORDS
{{List alternate names or titles for this topic that readers might use.}}

- Datto_DBPool
- Datto_DBPool_API
- Datto-Internal
- DBPool
