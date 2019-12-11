# Dapla local stack

Configuration for a local runtime environment that ties services together
to form a complete working example sandbox.


## Make targets

You can use `make` to execute common tasks:
```
build-all                                     Build all services (docker containers)
start-all                                     Start all services (docker containers)
start-all-recreate                            Recreate and start docker containers even if their configuration and image haven't changed
stop-all                                      Stop and remove all services (docker containers)
test-mapreduce                                Execute the mapreduce yarn example job
```

## Services

* Hadoop cluster (http://localhost:8088/cluster)
* Zeppelin (http://localhost:8008)
