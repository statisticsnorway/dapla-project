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
make redeploy-spark-plugin
```
You can further customize this with the `skipPseudo=true` and/or `skipPlugin=true` params.


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
redeploy-spark-plugin                         Build and redeploy the spark plugin and/or associated libs
open-db-admin                                 Open a DB admin tool in your browser
open-zeppelin                                 Open Zeppelin in your browser
open-hadoop-cluster                           Open Hadoop cluster browser
open-hadoop-hdfs                              Open Hadoop nameserver/dataserver
```

## Services

* Hadoop cluster (http://localhost:18088/cluster)
* Hadoop web UI for nameserver/dataserver (http://localhost:50070)
* Zeppelin (http://localhost:18008)
