# magnets

A golang web app for ecommerce inventory management

Uses [cockroachdb](https://www.cockroachlabs.com/docs/v20.2/build-a-go-app-with-cockroachdb-upperdb) for database and [upper/db](https://tour.upper.io/queries/01) as the database access layer.

Tested on Archlinux

## Prerequisite

```
yay -S cockroachdb go
```
it's recommended to use `cockroachdb-bin` for faster testing and deployment

## Single Node

in a terminal:
```
make clean0 certs0 single-node
```

cockroach node is started. Proceed to database setup

## Cluster Setup

Nodes act as access points to the database. This implementation does not consider them to be critical for data redundancy. Nodes can be started as-needed to give an access point (in this example) within the local network to the database. Follow along with the [upstream documentation of this process](https://www.cockroachlabs.com/docs/stable/deploy-cockroachdb-on-premises.html)

(note - you will need to change the Makefile for your specific cluster. Dummy values are present as placeholders)

```
make certs
```

The certificates are generated, and compressed into an archive. These must be copied to the corresponding node before continuing. Refer to the linked documentation above for a description of this process.

In this example, it is assume that this repository is cloned to the GOPATH on the nodes, and that, for instance, `certs1.tar.gz` is extracted into the cloned repository folder and is renamed `certs` from `certs1`.

## Starting the cluster
**after you have edited the Makefile**
on each node, beginning with the primary instance
```
make start1
```

the local instance
```
make start0
```

the third node
```
make start2
```

the fourth node
```
make start3
```

## Initialize the cluster
**you must edit the makefile first**
```
make init
```

## Database setup

in a new terminal or tab:
```
make db-secure
```

## Sync dependencies
```
go mod init
go mod vendor -v
```

## Run the application
```
go run main.go
```

server starts on 127.0.0.1:8040/

## Managing Inventory

The site is just a display for the inventory. Updating, adding, and deleting inventory is expected to be done with importing and exporting CSV directly to cockroachDB

The export command has been included in the Makefile
```
make export
```

For importing CSV, refer to the cockroachDB documentation.


## Production
Assuming a self-hosted instance (deployed on Archlinux)

requires caddy

```
yay -S caddy
```

reverse proxy to port 80 from 8040

```
sudo caddy reverse-proxy --from magnetosphere.net --to localhost:8040
```
