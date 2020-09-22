DATABASE_CONTAINERS := postgres pubsub
SERVICE_CONTAINERS := dapla-catalog-service dapla-noterepo-service dapla-spark-service dapla-auth-dataset-service dapla-secret-service

.PHONY: default
default: | help

.PHONY: sanity-check
sanity-check: ## Perform sanity check of localstack environment settings
	./bin/validate-localstack-env.sh

.PHONY: update-all
update-all: ## Update all repos from github (checkout/pull)
	(cd .. && make update-all)
	./bin/copy-sample-note.sh

.PHONY: build-all
build-all: ## Build all
	@make build-all-mvn build-all-docker 

.PHONY: build-all-docker
build-all-docker: ## Build all docker containers
	docker-compose -f docker-compose.yml -f docker-compose-jupyterlab.yml -f docker-compose-spark.yml -f docker-compose-concept.yml -f docker-compose-exploration.yml build

.PHONY: build-all-mvn
build-all-mvn: ## Build all maven projects
	mvn -f ../pom.xml clean install -U -Dmaven.test.skip=true

.PHONY: build-dependent-on-dataset-doc-mvn
build-dependent-on-dataset-doc-mvn: ## Build all maven projects
	mvn -f ../pom.xml -pl dapla-spark-plugin,dapla-exploration-metadata-ingest -am clean install -U -Dmaven.test.skip=true

.PHONY: restart-and-build-dependent-on-datadoc-all
restart-and-build-dependent-on-datadoc-all: ## Build all dependent on dataset-doc and buidld and restart jupyter and exploration-metadata-ingest
	docker-compose -f docker-compose.yml -f docker-compose-concept.yml -f docker-compose-exploration.yml stop jupyter exploration-metadata-ingest
	@make build-dependent-on-dataset-doc-mvn
	docker-compose -f docker-compose.yml -f docker-compose-concept.yml -f docker-compose-exploration.yml up -d --build jupyter exploration-metadata-ingest

.PHONY: copy-sparkextension-py-to-jupyterlab
copy-sparkextension-py-to-jupyterlab: ## find spawned instance of jupyterlab and copy sparkextension
	./bin/copy-sparkextension-py.sh

.PHONY: spark-plugin-build-and-copy-to-jupyterlab
spark-plugin-build-and-copy-to-jupyterlab: ## build plugin and find spawned instance of jupyterlab and copy jar file
	mvn -f ../pom.xml -pl dapla-spark-plugin -am clean install -U -Dmaven.test.skip=true
	./bin/spark-plugin-copy-to-jupyer.sh

.PHONY: start-all
start-all: ## Start all docker containers
	docker-compose -f docker-compose.yml -f docker-compose-spark.yml -f docker-compose-concept.yml -f docker-compose-exploration.yml up -d

.PHONY: start-all-lite
start-all-lite:
	docker-compose -f docker-compose.yml -f docker-compose-spark.yml -f docker-compose-concept.yml -f docker-compose-exploration.yml up -d --scale jupyter=0

.PHONY: start-all-with-console
start-all-with-console: ## Start all docker containers with output to existing console
	docker-compose -f docker-compose.yml -f docker-compose-spark.yml -f docker-compose-concept.yml -f docker-compose-exploration.yml up

.PHONY: start-jupyter-exploration-with-console
start-jupyter-exploration-with-console: ## Start docker containers with output to existing console and shut down all on ctrl-c
	docker-compose -f docker-compose.yml -f docker-compose-concept.yml -f docker-compose-exploration.yml up jupyterhub exploration-lds postgres jaeger pubsub keycloak exploration-metadata-ingest metadata-distributor catalog user-access data-access

.PHONY: start-all-recreate
start-all-recreate: ## Recreate and start docker containers even if their configuration and image haven't changed
	docker-compose -f docker-compose.yml -f docker-compose-spark.yml -f docker-compose-concept.yml -f docker-compose-exploration.yml up -d --force-recreate

.PHONY: start-services
start-services: ## Start all services (excluding spark, etc)
	docker-compose -f docker-compose.yml -f docker-compose-spark.yml -f docker-compose-concept.yml -f docker-compose-exploration.yml up -d ${DATABASE_CONTAINERS} ${SERVICE_CONTAINERS}

.PHONY: stop-all
stop-all: ## Stop and remove all docker containers
	docker-compose -f docker-compose.yml -f docker-compose-spark.yml -f docker-compose-concept.yml -f docker-compose-exploration.yml down

.PHONY: clean-all
clean-all: ## Stop and remove all docker containers and volumes
	docker-compose -f docker-compose.yml -f docker-compose-spark.yml -f docker-compose-concept.yml -f docker-compose-exploration.yml down -v

.PHONY: stop-services
stop-services: ## Stop all services (excluding spark, etc)
	docker-compose -f docker-compose.yml -f docker-compose-spark.yml -f docker-compose-concept.yml -f docker-compose-exploration.yml stop ${DATABASE_CONTAINERS} ${SERVICE_CONTAINERS}

.PHONY: open-db-admin
open-db-admin: ## Open a DB admin tool in your browser
	open http://localhost:25430/?pgsql=172.17.0.1:25432&username=rdc&db=rdc

.PHONY: open-jaeger
open-jaeger: ## Open Jaeger in your browser
	open http://localhost:16686

.PHONY: open-jupyter
open-jupyter: ## Open Juphyterhub in your browser
	open http://localhost:28012

.PHONY: open-keycloak
open-keycloak: ## Open Keycloak in your browser
	open http://localhost:28081

.PHONY: keycloak-export-realm
keycloak-export-realm: ## Export keycloak realm
	docker exec -it keycloak /opt/jboss/keycloak/bin/standalone.sh -Djboss.socket.binding.port-offset=100 -Dkeycloak.migration.action=export -Dkeycloak.migration.provider=singleFile -Dkeycloak.migration.realmName=ssb -Dkeycloak.migration.usersExportStrategy=REALM_FILE -Dkeycloak.migration.file=/tmp/my_realm.json
	docker cp keycloak:/tmp/my_realm.json keycloak_ssb_realm.json

.PHONY: open-hadoop-cluster
open-hadoop-cluster: ## Open Hadoop cluster browser
	open http://localhost:28000/cluster

.PHONY: open-hadoop-hdfs
open-hadoop-hdfs: ## Open Hadoop nameserver/dataserver
	open http://localhost:50070

.PHONY: open-lds-client
open-lds-client: ## Open Linked Data Store Client
	open http://localhost:28080

.PHONY: open-variable-search
open-variable-search: ## Open Variable Search
	open http://localhost:28081

.PHONY: print-local-changes
print-local-changes: ## Show a brief summary of local changes
	(cd .. && make print-local-changes)

.PHONY: run-scenario
run-scenario: ## Populate data for a given scenario specified by s=<scenario name>
	./bin/run-scenario.sh exec local $s

.PHONY: generate-keys
generate-keys: ## Generate keys used to sign and verify metadata
	./bin/generate-metadata-signer-keypair.sh

.PHONY: generate-concept-schemas
generate-concept-schemas: ## Generate concept schemas for use in Linked Data Store for Concept
	./bin/generate-concept-schemas.sh

.PHONY: generate-exploration-schemas
generate-exploration-schemas: ## Generate Exploration schemas for use in Linked Data Store
	./bin/generate-exploration-schemas.sh

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-45s\033[0m %s\n", $$1, $$2}'
