# Dapla local stack

Configuration for a local runtime environment that ties services together
to form a complete working example sandbox.


## Getting started

Before continuing, make sure you have pulled down all related dapla repositories from github:

```sh
make update-all
```

Then, build all the things:
```sh
make build-all
```

...and finally run all the things:
```sh
make start-all
```

If you only need to start services (without Spark, Zeppelin, etc), you can go:
```sh
make start-services
```

If you simply want to start a subset of containers, you can specify them explicitly, like so:
```sh
docker-compose up dapla-auth-dataset-service postgres db-admin
```

If you're working with the dapla-spark-plugin and want to see your latest changes applied
to your running environment without having to rebuild everything:
```sh
make spark-plugin-redploy
```
You can further customize this with the `skipPseudo=true` and/or `skipPlugin=true` params.

### Setup Linked Data Store for Concept
If you're working with linked-data-store, concept schemas for the service can be generated with:
```
make generate-concept-schemas
```
You will find the generated files in `localstack/docker/concept/jsonschemas` and `localstack/docker/concept/graphqlschemas`.

If you wish to import some example concept domains you can clone https://github.com/statisticsnorway/gsim-raml-schema/tree/feature/concept,
put the `examples/_main` folder in `localstack/bin/testdata/concept`, and run:
```
make run-scenario s=import-concept-examples
```
You may need to change the url for Linked Data store in this script if you changed the port.

If you wish to also run the [Linked Data Store Client](https://github.com/statisticsnorway/linked-data-store-client)
(**use the develop-branch**) follow the steps for local setup and change the environment variable or settings in the 
application to reach the Linked Data Store you setup here.

## Additional config

### Maven config

Some of the artifacts that this stack relies on are only available on SSBs internal nexus. Make sure
your `settings.xml` is configured properly (see the SSB developer guide).

### Secrets

In order to run the tests for the full stack you will need to have a service account file available in your environment.
Ask a friend to get hold of this.

- The project _dapla-spark-plugin_ needs a service account key file placed under`/secret/gcs_sa_test.json`.
This is needed to build the docker image and to run integration tests against a GCS bucket.

### Intellij

When pulling down repositories inside `dapla-project` intellij might not recognize these as separate repositories. To 
make intellij recognize sub repos go to "Settings -> Version Control" and then add any repos listed as "Unregistered".


## Gotchas

### Docker memory

Serving "the world" requires memory. If you e.g. experience that "everything" hangs or becomes
sluggy when running a command from Zeppelin, it might be because your Docker runtime needs more
memory. You can configure the memory settings from "Docker preferences -> Advanced".


## Make targets

There are many other convenience make tasks. Type `make help` to see the full list:
```
update-all                                    Update all repos from github (checkout/pull)
build-all                                     Build all
build-all-docker                              Build all docker containers
build-all-mvn                                 Build all maven projects
start-all                                     Start all docker containers
start-all-with-console                        Start all docker containers with output to existing console
start-all-recreate                            Recreate and start docker containers even if their configuration and image haven't changed
start-services                                Start all services (excluding spark, etc)
stop-all                                      Stop and remove all docker containers
stop-services                                 Stop all services (excluding spark, etc)
spark-plugin-redeploy                         Build and redeploy the spark plugin and/or associated libs
spark-interpreter-restart                     Restart the Zeppelin Spark interpreter
open-db-admin                                 Open a DB admin tool in your browser
open-zeppelin                                 Open Zeppelin in your browser
open-jupyter                                  Open Jupyter in your browser
open-hadoop-cluster                           Open Hadoop cluster browser
open-hadoop-hdfs                              Open Hadoop nameserver/dataserver
print-local-changes                           Show a brief summary of local changes
generate-schemas                              Generate schemas from RAML files for setting up Linked Data Store
```

## Services

See the [docker-compose](https://github.com/statisticsnorway/dapla-project/blob/master/localstack/docker-compose.yml) file for a list of al the services.