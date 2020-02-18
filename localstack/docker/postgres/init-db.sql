-- noinspection SqlNoDataSourceInspectionForFile

-- Dataset Access
CREATE USER dataset_access WITH PASSWORD 'dataset_access';
CREATE DATABASE dataset_access;
GRANT ALL PRIVILEGES ON DATABASE dataset_access TO dataset_access;

-- Secret Service
CREATE USER secret_service WITH PASSWORD 'secret_service';
CREATE DATABASE secret_service;
GRANT ALL PRIVILEGES ON DATABASE secret_service TO secret_service;

-- Catalog
CREATE USER catalog WITH PASSWORD 'catalog';
CREATE DATABASE catalog;
GRANT ALL PRIVILEGES ON DATABASE catalog TO catalog;

