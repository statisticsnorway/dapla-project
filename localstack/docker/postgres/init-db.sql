-- noinspection SqlNoDataSourceInspectionForFile

-- Dataset Access
CREATE USER user_access WITH PASSWORD 'user_access';
CREATE DATABASE user_access;
GRANT ALL PRIVILEGES ON DATABASE user_access TO user_access;

-- Catalog
CREATE USER catalog WITH PASSWORD 'catalog';
CREATE DATABASE catalog;
GRANT ALL PRIVILEGES ON DATABASE catalog TO catalog;
ALTER ROLE catalog SUPERUSER;

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

-- Linked Data Store for entire Exploration
CREATE USER exploration WITH PASSWORD 'exploration';
CREATE DATABASE exploration;
GRANT ALL PRIVILEGES ON DATABASE exploration TO exploration;

-- LDS SagaLog for Exploration
CREATE USER exploration_sagalog WITH PASSWORD 'exploration_sagalog';
CREATE DATABASE exploration_sagalog;
GRANT ALL PRIVILEGES ON DATABASE exploration_sagalog TO exploration_sagalog;

-- LDS Transaction-Log for Exploration
CREATE USER exploration_txlog WITH PASSWORD 'exploration_txlog';
CREATE DATABASE exploration_txlog;
GRANT ALL PRIVILEGES ON DATABASE exploration_txlog TO exploration_txlog;
