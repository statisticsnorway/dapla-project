-- noinspection SqlNoDataSourceInspectionForFile

-- Dataset Access
CREATE USER user_access WITH PASSWORD 'user_access';
CREATE DATABASE user_access;
GRANT ALL PRIVILEGES ON DATABASE user_access TO user_access;

-- Catalog
CREATE USER catalog WITH PASSWORD 'catalog';
CREATE DATABASE catalog;
GRANT ALL PRIVILEGES ON DATABASE catalog TO catalog;

-- Linked Data Store for Concept
CREATE USER concept WITH PASSWORD 'concept';
CREATE DATABASE concept;
GRANT ALL PRIVILEGES ON DATABASE concept TO concept;

-- LDS SagaLog for Concept
CREATE USER concept_sagalog WITH PASSWORD 'concept_sagalog';
CREATE DATABASE concept_sagalog;
GRANT ALL PRIVILEGES ON DATABASE concept_sagalog TO concept_sagalog;

-- LDS Transaction-Log for Concept
CREATE USER concept_txlog WITH PASSWORD 'concept_txlog';
CREATE DATABASE concept_txlog;
GRANT ALL PRIVILEGES ON DATABASE concept_txlog TO concept_txlog;

-- Linked Data Store for entire GSIM
CREATE USER gsim WITH PASSWORD 'gsim';
CREATE DATABASE gsim;
GRANT ALL PRIVILEGES ON DATABASE gsim TO gsim;

-- LDS SagaLog for GSIM
CREATE USER gsim_sagalog WITH PASSWORD 'gsim_sagalog';
CREATE DATABASE gsim_sagalog;
GRANT ALL PRIVILEGES ON DATABASE gsim_sagalog TO gsim_sagalog;

-- LDS Transaction-Log for GSIM
CREATE USER gsim_txlog WITH PASSWORD 'gsim_txlog';
CREATE DATABASE gsim_txlog;
GRANT ALL PRIVILEGES ON DATABASE gsim_txlog TO gsim_txlog;
