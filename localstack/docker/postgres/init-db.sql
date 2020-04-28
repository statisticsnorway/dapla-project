-- noinspection SqlNoDataSourceInspectionForFile

-- Dataset Access
CREATE USER user_access WITH PASSWORD 'user_access';
CREATE DATABASE user_access;
GRANT ALL PRIVILEGES ON DATABASE user_access TO user_access;

-- Catalog
CREATE USER catalog WITH PASSWORD 'catalog';
CREATE DATABASE catalog;
GRANT ALL PRIVILEGES ON DATABASE catalog TO catalog;

-- Linked Data Store
CREATE USER concept WITH PASSWORD 'concept';
CREATE DATABASE concept;
GRANT ALL PRIVILEGES ON DATABASE concept TO concept;