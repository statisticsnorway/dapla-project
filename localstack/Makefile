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

.PHONY: build-all
build-all: ## Build all
	@make build-all-mvn build-all-docker 

.PHONY: build-all-docker
build-all-docker: ## Build all docker containers
	(cd ../dapla-noterepo && docker build -t eu.gcr.io/prod-bip/dapla-zeppelin-base -f docker/Dockerfile .)
	docker-compose build

.PHONY: build-all-mvn
build-all-mvn: ## Build all maven projects
	mvn -f ../pom.xml clean install -U -Dmaven.test.skip=true

.PHONY: start-all
start-all: ## Start all docker containers
	docker-compose up -d

.PHONY: start-all-with-console
start-all-with-console: ## Start all docker containers with output to existing console
	docker-compose up

.PHONY: start-all-recreate
start-all-recreate: ## Recreate and start docker containers even if their configuration and image haven't changed
	docker-compose up -d --force-recreate

.PHONY: start-services
start-services: ## Start all services (excluding spark, etc)
	docker-compose up -d ${DATABASE_CONTAINERS} ${SERVICE_CONTAINERS}

.PHONY: stop-all
stop-all: ## Stop and remove all docker containers
	docker-compose down

.PHONY: stop-services
stop-services: ## Stop all services (excluding spark, etc)
	docker-compose stop ${DATABASE_CONTAINERS} ${SERVICE_CONTAINERS}

.PHONY: spark-plugin-redeploy
spark-plugin-redeploy: ## Build and redeploy the spark plugin and/or associated libs
ifndef skipPlugin
	@make --directory ../dapla-spark-plugin build-mvn skipTest=true
	docker cp ../dapla-spark-plugin/target/*-shaded.jar zeppelin:/zeppelin/lib/dapla-spark-plugin.jar
endif
ifndef skipPseudo
	@make --directory ../dapla-dlp-pseudo-func build-mvn skipTest=true
	docker cp ../dapla-dlp-pseudo-func/target/*-shaded.jar zeppelin:/zeppelin/lib/dapla-dlp-pseudo-func.jar
endif
	@make spark-interpreter-restart

.PHONY: spark-interpreter-restart
spark-interpreter-restart: ## Restart the Zeppelin Spark interpreter
	./bin/spark-interpreter-restart.sh

.PHONY: open-db-admin
open-db-admin: ## Open a DB admin tool in your browser
	open http://localhost:25430/?pgsql=172.17.0.1:25432&username=rdc&db=rdc

.PHONY: open-jaeger
open-jaeger: ## Open Jaeger in your browser
	open http://localhost:16686

.PHONY: open-zeppelin
open-zeppelin: ## Open Zeppelin in your browser
	open http://localhost:28010

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

.PHONY: print-local-changes
print-local-changes: ## Show a brief summary of local changes
	(cd .. && make print-local-changes)

.PHONY: run-scenario
run-scenario: ## Populate data for a given scenario specified by s=<scenario name>
	./bin/run-scenario.sh exec local $s

.PHONY: generate-keys
generate-keys: ## Generate keys used to sign and verify metadata
	./bin/generate-metadata-signer-keypair.sh

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-45s\033[0m %s\n", $$1, $$2}'
