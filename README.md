# projet_docker
container_BD_big_data

This project are composed by 5 containers. We need all of them for a Hive solution by dockers.

I will start to described containers one by one after that i will explain for some troubleshooting.

# Namenode :

The NameNode is at the core of the Hadoop cluster. It keeps the directory tree of all files in the file system, and tracks where the file data is actually kept in the cluster.

# Datanode :

The DataNode on the other hand stores the actual file data. Files are replicated across multiple DataNodes in a cluster for reliability.
Specifically, if were to think in terms of Hive, the data stored on the Hive tables is spread across the DataNodes within the cluster. NameNode, on the other hand is the one keeping track of these blocks of data actually stored on the DataNodes. We are using a single Datanode for this project.

# Hive-server :

Apache Hive is a distributed, fault-tolerant data warehouse system that enables analytics of large datasets residing in distributed storage using SQL. It's what we need here !

In this project i want to use a dataset from an old project of my master : database_spaceX.csv

For that i add a volume to the file docker-compose.yml in the section of Hive-server -> volumes i add the sentence : - ./spaceX:/spacex

I will explain : when i add the sentence - ./spaceX:/spacex to my hive-server i add a directory where i can get my dataset and my script hql (SQL for hive) to create table. If i don't do that no directory was create on my container.

So we have now a directory with dataset + hql OK but how we use it ?

log into the container with this command : docker exec -it hive-server /bin/bash

When you are in use : cd ..

List all directory and files where you are with : ls -ltr

Go in directory spacex : cd spacex

list the files in for to be sure to have all we need : ls -ltr

Create the table with this command : hive -f space_table.hql

Load dataset in your hive server : hadoop fs -put database_spaceX.csv hdfs://namenode:8020/user/hive/warehouse/spacex.db/space

You could now log in to hive with this command : hive

List all database unable : show databases;

use spaceX : use spaceX;

You can now use hive like all database.

# Hive-metastore and postgres :

Hive uses a relational database to store the metadata (e.g. schema and location) of all its tables. The default database is Derby, but we will be using PostgreSQL in this project.
The key benefit of using a relational database over HDFS is low latency and improved performance.

# How to start / stop ?

For starting all your containers go in the directory where we have the file docker-compose.yml and tip this command : docker-compose up

When you have finish, use this command for stoped all services : docker-compose down

#### Troubleshooting :

When i used all this containers on my personnal laptop Windows i have no trouble with them, they work perfectly...

But when i try to install them on the unbuntu server i made for this project i get a lot of errors on the install of hive-metastore-postgresql.

For each error i used this command for gettings logs : docker logs hive-metastore-postgresql

at each time logs says "could not access to directory <<pg_...>>

so i create manually all directory with the same directory rights that other in /home/"user"/projet_docker/metastore-postgresql/postgresql/data, i use command like : chmod 775 <directory> and chown systemd-coredump:"group user" <directory>

When you have create all directory needed the server start without any problems...
  

