python clean.py
python cleancca.py


echo "Create database"
dropdb --if-exists sanctuary
createdb sanctuary

echo "Import all table "
psql sanctuary -c "CREATE TABLE requests(
date timestamp,
lift_reason varchar,
det_facility varchar,
city varchar,
state varchar,
detainer_type varchar
)"

cat processed/FY*.csv | psql sanctuary -c "COPY requests FROM stdin DELIMITER ',' CSV HEADER;"

echo "Create database"
dropdb --if-exists sanctuary
createdb sanctuary

echo "Import cca_managedonly table"
psql sanctuary -c "DROP TABLE if exists cca_managedonly;"
psql sanctuary -c "CREATE TABLE cca_managedonly(
  pvt_facility varchar,
  city_or_state varchar,
  customer varchar,
  capacity varchar,
  security_level varchar,
  facility_type varchar,
  term varchar,
  renewal_option varchar
);"

psql sanctuary -c "COPY cca_managedonly FROM '`pwd`/processed/cca_managedonly.csv' DELIMITER ',' CSV HEADER;"

psql sanctuary -c "alter table cca_managedonly add column cca_involvement varchar;"

psql sanctuary -c "update cca_managedonly set cca_involvement = 'managed';"

psql sanctuary -c "alter table cca_managedonly alter column  cca_involvement set not null;"



echo "Import cca_owned_managed table"
psql sanctuary -c "DROP TABLE if exists cca_owned_managed;"
psql sanctuary -c "CREATE TABLE cca_owned_managed(
  pvt_facility varchar,
  city_or_state varchar,
  customer varchar,
  capacity varchar,
  security_level varchar,
  facility_type varchar,
  term varchar,
  renewal_option varchar
);"


psql sanctuary -c "COPY cca_owned_managed FROM '`pwd`/processed/cca_owned_managed.csv' DELIMITER ',' CSV HEADER;"

psql sanctuary -c "alter table cca_owned_managed add column cca_involvement varchar;"

psql sanctuary -c "update cca_owned_managed set cca_involvement = 'owned and managed';"

psql sanctuary -c "alter table cca_owned_managed alter column  cca_involvement set not null;"


echo "Import cca_leased table"
psql sanctuary -c "DROP TABLE if exists cca_leased;"
psql sanctuary -c "CREATE TABLE cca_leased(
  pvt_facility varchar,
  city_or_state varchar,
  customer varchar,
  capacity varchar,
  security_level varchar,
  facility_type varchar,
  term varchar,
  renewal_option varchar
);"

psql sanctuary -c "COPY cca_leased FROM '`pwd`/processed/cca_leased.csv' DELIMITER ',' CSV HEADER;"

psql sanctuary -c "alter table cca_leased add column cca_involvement varchar;"

psql sanctuary -c "update cca_leased set cca_involvement = 'leased';"

psql sanctuary -c "alter table cca_leased alter column  cca_involvement set not null;"
