-- noinspection SqlNoDataSourceInspectionForFile

-- Create user and database
CREATE USER rdc WITH PASSWORD 'rdc';
CREATE DATABASE rdc;
GRANT ALL PRIVILEGES ON DATABASE rdc TO rdc;
