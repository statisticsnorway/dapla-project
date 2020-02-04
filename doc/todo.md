# TODO

## Tasks

* Retreive user token in Zeppelin and be passed to Spark/Yarn? and possibly available for propogation to our micro services
  * PS! The current resolved user is identified by part-of-filename of jar file passed as job from zeppelin to yarn/spark. The current approach is too weak.
* All services must have a seperat keycloak client-id and pass the correlating token when integrating with other services
* All integrations must pass the token in order to identify the user
  * all services must validate incoming the user token
*  Remove access-check in spark-service on prepare-read and prepare-write. This check is redundant, as it is also done by broker before revealing GCS access-key.

## Documentation topics

* localstack deployment diagram
* staging deployment diagram
* prod deployment diagram
* security diagrams
  * activity diagram
* 
  
