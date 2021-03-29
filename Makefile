clean: clean0 clean1 clean2 clean3

clean0:
	rm -rf cockroach-data certs private

clean1:
	rm -rf certs1

clean2:
	rm -rf certs2

clean3:
	rm -rf certs3

certs: clean certs0 certs1 certs2 certs3
	echo

certs0: #clean0
	mkdir -p certs private && \
	cockroach cert create-ca --certs-dir=certs --ca-key=private/ca.key && \
	cockroach cert create-node --overwrite --certs-dir=certs --ca-key=private/ca.key localhost && \
	cockroach cert create-client root --certs-dir=certs --ca-key=private/ca.key && \
	cockroach cert create-client maxroach --certs-dir=certs --ca-key=private/ca.key
	bsdtar -czvf certs.tar.gz certs


certs1: #clean1
	cp -r certs certs1
	cockroach cert create-node --overwrite --certs-dir=certs1 --ca-key=private/ca.key host2
	bsdtar -czvf certs1.tar.gz certs1

certs2: #clean2
	cp -r certs certs2
	cockroach cert create-node --overwrite --certs-dir=certs2 --ca-key=private/ca.key host3
	bsdtar -czvf certs2.tar.gz certs2

certs3: #clean3
	cp -r certs certs3
	cockroach cert create-node --overwrite --certs-dir=certs3 --ca-key=private/ca.key host4
	bsdtar -czvf certs3.tar.gz certs3

#start cluster in foreground;
start0:	#local instance
	cockroach start \
	--certs-dir=certs \
	--advertise-addr=<local-ip-node> \
	--join=<ip-of-other-node>,<ip-of-other-node2>,<ip-of-other-node3> \
	--cache=.25 \
	--max-sql-memory=.25 #\
#	--background

start1:	#instance on webserver
	cockroach start \
	--certs-dir=certs \
	--advertise-addr=<lan-ip-node2> \
	--join=<ip-of-other-node>,<ip-of-other-node3>,<ip-of-other-node4> \
	--cache=.25 \
	--max-sql-memory=.25 #\
#	--background

start2:	#third node
	cockroach start \
	--certs-dir=certs \
	--advertise-addr=<lan-ip-node3> \
	--join=<ip-of-other-node>,<ip-of-other-node2>,<ip-of-other-node4> \
	--cache=.25 \
	--max-sql-memory=.25 #\
#	--background

start3:	#fourth node
	cockroach start \
	--certs-dir=certs \
	--advertise-addr=<lan-ip-node4> \
	--join=<ip-of-other-node>,<ip-of-other-node2>,<ip-of-other-node3> \
	--cache=.25 \
	--max-sql-memory=.25 #\
#	--background

#start cluster in background; for production
prod0:	#local instance
	cockroach start \
	--certs-dir=certs \
	--advertise-addr=<local-ip-node> \
	--join=<ip-of-other-node>,<ip-of-other-node2>,<ip-of-other-node3> \
	--cache=.25 \
	--max-sql-memory=.25 \
	--background

prod1:	#instance on webserver - start in background
	cockroach start \
	--certs-dir=certs \
	--advertise-addr=<lan-ip-node2> \
	--join=<ip-of-other-node>,<ip-of-other-node3>,<ip-of-other-node4> \
	--cache=.25 \
	--max-sql-memory=.25 \
	--background

prod2:	#third node background start
	cockroach start \
	--certs-dir=certs \
	--advertise-addr=<local-ip-node> \
	--join=<ip-of-other-node>,<ip-of-other-node2>,<ip-of-other-node3> \
	--cache=.25 \
	--max-sql-memory=.25 \
	--background

prod3:	#fourth node background start
	cockroach start \
	--certs-dir=certs \
	--advertise-addr=<lan-ip-node4> \
	--join=<ip-of-other-node>,<ip-of-other-node2>,<ip-of-other-node3> \
	--cache=.25 \
	--max-sql-memory=.25 \
	--background

#init is run after start# for initializing nodes in a cluster
init:	#PUT THE LAN IP ADDRESS OF THE LOCAL NODE
	cockroach init --certs-dir=certs --host=<local-node-lan-ip>

#single node for local testing / non cluster implementation
single-node:
	cockroach start-single-node --certs-dir=certs

insecure: clean
	cockroach start-single-node --insecure

db-secure:
	cockroach sql --certs-dir=certs -e  'CREATE USER IF NOT EXISTS maxroach WITH PASSWORD "cockroach"; CREATE DATABASE IF NOT EXISTS product; GRANT ALL ON DATABASE product TO maxroach; GRANT ADMIN TO maxroach; USE product;'

db-insecure:
	cockroach sql --insecure -e 'CREATE USER IF NOT EXISTS maxroach WITH PASSWORD "cockroach"; CREATE DATABASE IF NOT EXISTS product; GRANT ALL ON DATABASE product TO maxroach;'

export:
	cockroach sql --certs-dir=certs -e "SELECT * from product.products;" --format=csv > export01.csv
