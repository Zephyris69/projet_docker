# projet_docker Hive Morand Jonathan
container_BD_big_data with database Hive

For use this project you need to download git or clone it, when you are on your server or desktop, directory are like this :

![image](https://user-images.githubusercontent.com/97912183/153208349-050c7b09-cd3f-4fe4-83a8-cd3017ed4dac.png)

# description :

This project are composed by 5 containers. We need all of them for a Hive solution by dockers.

I will start to described containers one by one after that i will explain for some troubleshooting.

## Namenode :

The NameNode is at the core of the Hadoop cluster. It keeps the directory tree of all files in the file system, and tracks where the file data is actually kept in the cluster.

## Datanode :

The DataNode on the other hand stores the actual file data. Files are replicated across multiple DataNodes in a cluster for reliability.
Specifically, if were to think in terms of Hive, the data stored on the Hive tables is spread across the DataNodes within the cluster. NameNode, on the other hand is the one keeping track of these blocks of data actually stored on the DataNodes. We are using a single Datanode for this project.

## Hive-server :

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

You can now use hive like all database in sql.

## Hive-metastore and postgres :

Hive uses a relational database to store the metadata (e.g. schema and location) of all its tables. The default database is Derby, but we will be using PostgreSQL in this project.
The key benefit of using a relational database over HDFS is low latency and improved performance.

## How to start/stop with docker-compose ?

For starting all your containers go in the directory where we have the file docker-compose.yml and tip this command : docker-compose up

When you have finish, use this command for stoped all services : docker-compose down

Docker compose use version 3.

He will start automaticaly all containers one by one in the following orders :

namenode > datanode > hive-server > hive-metastore > hive-metastore-postgresql

Each containers depends on the good start of previous containers, it's symbolized by "depends_on: - namenode" for example.

the line ports : it's for the opening on network, we open ports for listening.

the line volumes : it's for create directory in the container.

the line env_file : it's for loading all environnement variables set in the files we create in local before.

the line environment : it's link with env_file, here we set variables for the use of container.

the line container_name : it's for setting the name of the container

the line image : where we can found the image to mount on container (here it's public image)

## Link to image used in this project :

1/ Namenode :

bde2020/hadoop-namenode:2.0.0-hadoop2.7.4-java8 : 

https://hub.docker.com/layers/bde2020/hadoop-namenode/2.0.0-hadoop2.7.4-java8/images/sha256-23d8c9a8ce60b9e81527ec0bd318f51dc1d746fd7f1abba4f6c4c9b1dc290c6b?context=explore

2/ Datanode :

bde2020/hadoop-datanode:2.0.0-hadoop2.7.4-java8 :

https://hub.docker.com/layers/bde2020/hadoop-datanode/2.0.0-hadoop2.7.4-java8/images/sha256-5623fca5e36d890983cdc6cfd29744d1d65476528117975b3af6a80d99b3c62f?context=explore

3/ Hive-server and metastore :

bde2020/hive:2.3.2-postgresql-metastore :

https://hub.docker.com/layers/bde2020/hive/2.3.2-postgresql-metastore/images/sha256-620267768985bb57e52a86db9263a354e92d0202319d835678852539b21e0895?context=explore

4/ Metastore postgresql :

bde2020/hive-metastore-postgresql:2.3.0 :

https://hub.docker.com/layers/bde2020/hive-metastore-postgresql/2.3.0/images/sha256-9ab91699d15131b874829e6572006cd9d9f1cca413f438b6f21c65b412152bf1?context=explore

# How exactly do all images :

1/ Namenode :

Put an environnement HDFS available on container for tracking all tree files we use in this project.

2/ Datanode :

It's the other hand of namenode... Here we use just 1 datanode, it's where we stock files and replicate of all this files.

3/ Hive-server :

Image create a container with hive solution. We get some files for hive configuration from ranged server, and we open ports 10000 to 10002.

4/ Metastore postgresql :

Install postgresql library and environnement. Create a technical database for stored user, password and other's technical usaged.

#### Troubleshooting :

When i used all this containers on my personnal laptop Windows i have no trouble with them, they work perfectly...

But when i try to install them on the unbuntu server i made for this project i get a lot of errors on the install of hive-metastore-postgresql.

For each error i used this command for gettings logs : docker logs hive-metastore-postgresql

at each time logs says "could not access to directory <<pg_...>>

so i create manually all directory with the same directory rights that other in /home/"user"/projet_docker/metastore-postgresql/postgresql/data, i use command like : chmod 775 <directory> and chown systemd-coredump:"group user" <directory>

When you have create all directory needed the server start without any problems...
