DATABASE_CONTAINERS = postgres bigtable
SERVICE_CONTAINERS = dapla-catalog-service dapla-noterepo-service dapla-spark-service dapla-auth-dataset-service

.PHONY: default
default: | help

.PHONY: update-all
update-all: ## Update all repos from github (checkout/pull)
	(cd .. && make update-all)

.PHONY: build-all
build-all: ## Build all
	@make build-all-mvn build-all-docker 

.PHONY: build-all-docker
build-all-docker: ## Build all docker containers
	docker-compose build

.PHONY: build-all-mvn
build-all-mvn: ## Build all maven projects
	mvn -f ../pom.xml clean install -Dmaven.test.skip=true

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

.PHONY: open-db-admin
open-db-admin: ## Open a DB admin tool in your browser
	open http://localhost:18020/?pgsql=172.17.0.1:15432&username=rdc&db=rdc

.PHONY: open-zeppelin
open-zeppelin: ## Open Zeppelin in your browser
	open http://localhost:18010

.PHONY: open-hadoop-cluster
open-hadoop-cluster: ## Open Hadoop cluster browser
	open http://localhost:18000/cluster

.PHONY: open-hadoop-hdfs
open-hadoop-hdfs: ## Open Hadoop nameserver/dataserver
	open http://localhost:50070

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-45s\033[0m %s\n", $$1, $$2}'
