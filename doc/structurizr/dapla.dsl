workspace dapla "Data Platform" {
  model {
    impliedRelationships false
    ss_externalSource = softwareSystem "External data-source" "Any data-source owned and controlled by an entity other than SSB"
    ss_github = softwareSystem "GitHub"
    enterprise SSB {
      ss_giam = softwareSystem "Google IAM"
      ss_internalSource = softwareSystem "Internal data-source" "Any data-source owned and controlled by SSB"
      p_dataScientist = person "Data scientist" "A person skilled in data science"
      p_dataCurator = person "Data curator" "A person responsible for keeping Concept (group from GSIM) related data in shape"
      p_dataAccessManager = person "Data-access manager" "A person responsible for keeping Concept (group from GSIM) related data in shape"
      ss_keycloak = softwareSystem "Keycloak" "Single Sign On (SSO) for dapla with integration to Active-Directory authentication"
      ss_data = softwareSystem "DataStore" {
        c_datastore = container "Data-Store" "Google Cloud Storage"
        c_dataMaintenance = container "Data Maintenance" "" "Docker/Java/Helidon"
      }
      ss_collection = softwareSystem "Collection" "A number of services and tools used to collect, encrypt, and store data from heterogenous external or internal data-sources then convert and pseudonymize these data into a dapla compatible form." {
        c_dc = container "Data Collector" "A highly flexible data-collector application that can be used to collect data from many kinds of http based data-streaming APIs that use xml or json as a stream navigation and state handling format" "Docker/Java"
        db_rawdata = container "Rawdata Store" "Storage for streams that can be produced to and consumed using an appropriately configured rawdata-client." "Google Cloud Storage (GCS)"
        c_converter = container "Converter" "Converter service that consumes rawdata streams then converts and pseudonymizes the data into a dapla compatible form" "Docker/Java/Micronaut"
        c_dc -> ss_externalSource "Consumes data-stream from" "HTTPS"
        c_dc -> db_rawdata "Produces encrypted rawdata to"
        c_converter -> db_rawdata "Consumes encrypted rawdata from"
        c_converter -> ss_data "Write pseudonymized parquet data to"
        fs_datamottak = container "Datamottak" "On-premise filesystem mount" "Linux/NFS"
        c_cli = container "Collection CLI" "Produces rawdata stream and corresponding schema based on csv files" "Docker/Java"
        c_cli -> db_rawdata "Produces encrypted rawdata to"
        c_cli -> fs_datamottak "Reads csv file from"
        -> ss_internalSource "Collects data from"
        -> ss_externalSource "Collects data from"
        -> ss_data "Writes data to"
      }
      ss_metadata = softwareSystem "Metadata" {
        c_metadataDistributor = container "Metadata Distributor" "Validates all changes to datastore and distributes updated dataset metadata downstream" "Docker/Java/Helidon"
        t_mdDatastoreNotifications = container "Datastore notifications" "Topic where changes to datastore objects are published" "PubSub topic"
        ss_data -> t_mdDatastoreNotifications "Publish file/object change notifications"
        c_metadataDistributor -> t_mdDatastoreNotifications "Subscribe to"
        t_explorationMetadata = container "Exploration Metadata" "" "PubSub topic"
        c_explorationLds = container "Exploration LDS" "LDS instance with cross-domain metadata for search and exploration purposes." "Docker/Java"
        db_explorationLdsNeo4j = container "Exploration DB" "Primary storage for Exploration CRUD and Query functionality." "Neo4j"
        db_explorationLdsPostgres = container "Exploration Tx-log/Sagalog" "Database functioning as Transaction-log and sagalog for exploration-lds" "Postgres"
        c_explorationLds -> db_explorationLdsNeo4j "Read/write data using" "Bolt/Cypher"
        c_explorationLds -> db_explorationLdsPostgres "Append tx-log and append/truncate sagalog using" "Bolt/Cypher"
        c_conceptLds = container "Concept LDS" "LDS instance which is master of Concept (from GSIM/LDM) data." "Docker/Java"
        db_conceptLdsNeo4j = container "Concept DB" "Primary storage for Concept CRUD and Query functionality." "Neo4j"
        db_conceptLdsPostgres = container "Concept Tx-log/Sagalog" "Database functioning as Transaction-log and sagalog for concept-lds" "Postgres"
        c_conceptLds -> db_conceptLdsNeo4j "Read/write data using" "Bolt/Cypher"
        c_conceptLds -> db_conceptLdsPostgres "Append tx-log and append/truncate sagalog using" "Bolt/Cypher"
        c_explorationConceptIngest = container "Exploration Concept Ingest" "Pipeline tailing data from Concept LDS tx-log and writing it to Exploration LDS. A custom log-shipping" "Docker/Java/Helidon"
        c_explorationConceptIngest -> db_conceptLdsPostgres "Consume tx-log from"
        c_explorationConceptIngest -> c_explorationLds "Write concept-data to"
        c_explorationMetadataIngest = container "Exploration Metadata Ingest" "Pipeline getting metadata and writing it to Exploration LDS." "Docker/Java/Helidon"
        c_explorationMetadataIngest -> t_explorationMetadata "Subscribe to"
        c_explorationMetadataIngest -> c_explorationLds "Write metadata to"
        c_metadataExplorer = container "Metadata Explorer" "Browse and Search exploration/concept, maintain concept" "Docker/React"
        c_metadataExplorer -> c_conceptLds "read from and write to" "HTTP/json"
        c_metadataExplorer -> c_explorationLds "read from and query" "HTTP/json"
        p_dataCurator -> c_metadataExplorer "Maintain Concept data and search Exploration data using"
        c_datasetDocService = container "Doc Service" "Data documentation and lineage template helper" "Docker/Java/Helidon"
        c_datasetDocService -> c_conceptLds "Query candidate resources for instance-variables and lineage using " "HTTP/json"
        c_workbench = container "Workbench" "Portal with several metadata functions including catalog browsing, lineage search and visualization"
        c_workbench -> c_conceptLds "" "HTTP/json"
        c_workbench -> c_explorationLds "" "HTTP/json"
        -> ss_data "Subscribes to change notifications on"
      }
      c_metadataDistributor -> t_explorationMetadata "Publish metadata to"
      ss_dataSecurity = softwareSystem "Data-security" "Data-security and data-access-management system used to administrate and enforce data access control rules." {
        c_catalog = container "Catalog" "Index of all valid datasets available in the data-store. Catalog is primarily concerned with the metadata of datasets that are relevant to data-security" "Docker/Java/Helidon" {
        }
        db_catalog = container "CatalogDB" "Catalog index storage" "Postgres"
        t_catalogMetadata = container "Catalog Metadata" "" "PubSub topic"
        c_catalog -> t_catalogMetadata "Subscribes to"
        c_catalog -> db_catalog "SQL"
        c_dataAccess = container "DataAccess" "Data access enforcement application with the power to grant the data-store access-tokens that are needed in order to read or write datasets." "Docker/Java/Helidon"
        c_dataAccess -> c_catalog "Get dataset metadata" "HTTP/json"
        c_userAccess = container "UserAccess" "Service that maintains rules that define data-access for users." "Docker/Java/Helidon"
        db_userAccess = container "UserAccessDB" "Database with data-access rules for users." "Postgres"
        c_userAccess -> db_userAccess "SQL"
        c_userAccessAdmin = container "User-Access Admin" "Front-end application providing a web-interface for administering user-data-access-control rules." "Docker/React"
        c_catalog -> c_userAccess "Checks access-rules using" "HTTP/json"
        c_dataAccess -> c_userAccess "Checks access-rules using" "HTTP/json"
        c_userAccessAdmin -> c_userAccess "Updates access-control rules" "HTTP/json"
        c_dataAccess -> ss_giam "Generates GCS access-tokens using" "GRPC"
        p_dataAccessManager -> c_userAccessAdmin "Administers data-access-rules for users using"
        -> ss_giam "Generates GCS access-tokens using" "GRPC"
      }
      ss_collection -> ss_dataSecurity "Sign metadata for new datastream using" "HTTP/json"
      c_converter -> ss_dataSecurity "Sign metadata for new datastream using" "HTTP/json"
      ss_jupyter = softwareSystem "Jupyter" "Customized open-source environment for interactive computing on SSB's data using languages like Spark, Python, and R." {
        c_jupyterHub = container "Jupyter Hub" "Portal to Jupyter ecosystem with login and spawning of personal Jupyter Lab containers" "Docker"
        c_jupyterLab = container "Jupyter Lab (Personal)" "Programming environment with custom integrations to security, data, and metadata systems" "Docker"
        -> ss_github "Clone/Fetch/Push"
        -> ss_data "Reads/writes data from/to"
        -> ss_dataSecurity "Gets data-access using"
        -> c_datasetDocService "Get templates using" "HTTP/json"
      }
      c_workbench -> ss_dataSecurity "Read catalog" "HTTP/json"
      c_metadataDistributor -> t_catalogMetadata "Publish metadata to"
      ss_automation = softwareSystem "Automation" "Notebook processing automation" {
        c_blueprint = container "Blueprint" "Application that consumes notebook source-code git repositories and maintains corresponding graphs of notebook dependencies and has capabilities to produce execution plans" "Docker/Java/Helidon"
        db_blueprint = container "Blueprint DB" "Graph of notebooks and their input/output inter-dependencies grouped by commit-id" "Neo4j"
        c_blueprint -> db_blueprint "Adds subgraphs by commit-id to, and extracts execution plans from" "Bolt/Cypher"
        c_blueprintExecution = container "Blueprint Execution" "Application that can initiate and control execution of notebooks based on an execution plan" "Docker/Java/Helidon"
        c_blueprintExecution -> c_blueprint "Extracts execution plan from" "HTTP/json"
        ss_github -> c_blueprint "Pushes new commits to" "HTTPS"
        c_jupyterHeadless = container "Jupyter (headless)" "Executes Spark/Python/R kernels with Papermill" "Docker/Jupyter"
        c_blueprintExecution -> c_jupyterHeadless "Spawn executors using"
        -> ss_github "Subscribes to git repo push-messages"
        -> ss_data "Read from and write to"
        -> ss_dataSecurity "Get data-access and sign metadata using" "HTTP/json"
      }
    }
  }
}