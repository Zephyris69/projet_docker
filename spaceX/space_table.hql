create database if not exists spaceX;
use spaceX;
create external table if not exists space (
  ID_temp varchar (100),
  Flight_Number varchar (100),
  Launch_Date varchar (100),
  Launch_Time varchar (100),
  Launch_Site varchar (100),
  Vehicule_Type varchar (100),
  Payload_Name varchar (100),
  Payload_Type varchar (100),
  Payload_Mass varchar (100),
  Payload_Orbit varchar (100),
  Customer varchar (100)
)
row format delimited
fields terminated by ',';
stored as textfile location 'hdfs://namenode:8020/user/hive/warehouse/spaceX.db/space';