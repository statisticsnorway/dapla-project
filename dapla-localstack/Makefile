.PHONY: default
default: | help

.PHONY: build-all
build-all: ## Build all services (docker containers)
	docker-compose build

.PHONY: start-all
start-all: ## Start all services (docker containers)
	docker-compose up

.PHONY: start-all-recreate
start-all-recreate: ## Recreate and start docker containers even if their configuration and image haven't changed
	docker-compose up --force-recreate

.PHONY: stop-all
stop-all: ## Stop and remove all services (docker containers)
	docker-compose down

.PHONY: test-mapreduce
test-mapreduce: ## Execute the mapreduce yarn example job
	docker-compose exec hadoop /usr/local/hadoop/bin/yarn jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.1.jar pi 16 1000

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-45s\033[0m %s\n", $$1, $$2}'
