class DBPoolNode {
    [int]$id
    [string]$name
    [string]$ip
    [string]$fqdn
    [int]$total_containers
    [int]$powered_on_containers
    [int]$powered_off_containers
    [int]$remaining_containers
    [int]$maximum_containers

    DBPoolNode([int]$id, [string]$name, [string]$ip, [string]$fqdn, [int]$total_containers, [int]$powered_on_containers, [int]$powered_off_containers, [int]$remaining_containers, [int]$maximum_containers) {
        $this.id = $id
        $this.name = $name
        $this.ip = $ip
        $this.fqdn = $fqdn
        $this.total_containers = $total_containers
        $this.powered_on_containers = $powered_on_containers
        $this.powered_off_containers = $powered_off_containers
        $this.remaining_containers = $remaining_containers
        $this.maximum_containers = $maximum_containers
    }
}

class DBPoolUser {
    [int]$id
    [string]$username
    [string]$displayName
    [string]$email

    DBPoolUser([string]$id, [string]$username, [string]$displayName, [string]$email) {
        $this.id = $id
        $this.username = $username
        $this.displayName = $displayName
        $this.email = $email
    }
}

class DBPoolAuthUser : DBPoolUser {
    [securestring]$apiKey

    DBPoolAuthUser([string]$id, [string]$username, [string]$displayName, [string]$email, [securestring]$apiKey) : base($id, $username, $displayName, $email) {
        $this.apiKey = $apiKey
    }
}

class DBPoolParentContainer {
    [int]$id
    [string]$image
    [string]$name
    [string]$defaultDatabase
    [DBPoolNode]$node
    [bool]$useNewSync
    [bool]$sync

    DBPoolParentContainer([int]$id, [string]$image, [string]$name, [string]$defaultDatabase, [DBPoolNode]$node, [bool]$useNewSync, [bool]$sync) {
        $this.id = $id
        $this.image = $image
        $this.name = $name
        $this.defaultDatabase = $defaultDatabase
        $this.node = $node
        $this.useNewSync = $useNewSync
        $this.sync = $sync
    }
}

class DBPoolContainer {
    [int]$id
    [string]$image
    [string]$name
    [bool]$power
    [string]$defaultDatabase
    [string]$dateCreated
    [string]$dateStarted
    [string]$dateStopped
    [string]$host
    [int]$port
    [string]$username
    [securestring]$password
    [DBPoolNode]$node
    [DBPoolParentContainer]$parent
    [DBPoolUser[]]$users

    DBPoolContainer([int]$id, [string]$image, [string]$name, [bool]$power, [string]$defaultDatabase, [string]$dateCreated, [string]$dateStarted, [string]$dateStopped, [string]$host, [int]$port, [string]$username, [securestring]$password, [DBPoolNode]$node, [DBPoolParentContainer]$parent, [DBPoolUser[]]$users) {
        $this.id = $id
        $this.image = $image
        $this.name = $name
        $this.power = $power
        $this.defaultDatabase = $defaultDatabase
        $this.dateCreated = $dateCreated
        $this.dateStarted = $dateStarted
        $this.dateStopped = $dateStopped
        $this.host = $host
        $this.port = $port
        $this.username = $username
        $this.password = $password
        $this.node = $node
        $this.parent = $parent
        $this.users = $users
    }
}