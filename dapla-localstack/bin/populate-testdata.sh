# dataset-access
# create role for rawdata
curl --location --request PUT 'http://localhost:18080/role/skatt.person.rawdata' \
--header 'Content-Type: application/json' \
--data-raw '{
  "roleId": "skatt.person.rawdata",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "skatt.person"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["RAW", "INPUT", "PROCESSED", "OUTPUT", "PRODUCT"]
}'

# create role for indata
curl --location --request PUT 'http://localhost:18080/role/skatt.person.inndata' \
--header 'Content-Type: application/json' \
--data-raw '{
  "roleId": "skatt.person.inndata",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "skatt.person"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["INPUT", "PROCESSED", "OUTPUT", "PRODUCT","OTHER"]
}'

# dataset-access
# get roles
curl --location --request GET 'http://localhost:18080/role/skatt.person.rawdata' 
curl --location --request GET 'http://localhost:18080/role/skatt.person.inndata' 

# dataset-access
# create users
curl --location --request PUT 'http://localhost:18080/user/user1' \
--header 'Content-Type: application/json' \
--data-raw '{ "userId" : "user1", "roles" : [ "skatt.person.rawdata" ] }'

curl --location --request PUT 'http://localhost:18080/user/user2' \
--header 'Content-Type: application/json' \
--data-raw '{ "userId" : "user2", "roles" : [ "skatt.person.inndata" ] }'

# dataset-access
# get user
curl --location --request GET 'http://localhost:18080/user/user1' 
curl --location --request GET 'http://localhost:18080/user/user2' 

# dataset-access
# get access
# should have access
curl --location --request GET 'http://localhost:18080/access/user1?privilege=READ&namespace=skatt.person&valuation=SENSITIVE&state=RAW'
curl --location --request GET 'http://localhost:18080/access/user2?privilege=READ&namespace=skatt.person&valuation=SENSITIVE&state=INPUT'

# should not have access
curl --location --request GET 'http://localhost:18080/access/user2?privilege=READ&namespace=skatt.person&valuation=SENSITIVE&state=RAW'

# dapla-catalog

# map name to id
curl -X POST http://localhost:18070/name/skatt.person.2019.rawdata/341b03d6-5be6-4c9b-b381-8cf692aa8830

# check mapping
curl http://localhost:18070/name/skatt.person.2019.rawdata

# check listing
curl http://localhost:18070/prefix/skatt

# create dataset
curl --location --request PUT 'http://localhost:18070/dataset/341b03d6-5be6-4c9b-b381-8cf692aa8830' \
--header 'Content-Type: application/json' \
--data-raw '{
  "id": {
    "id": "341b03d6-5be6-4c9b-b381-8cf692aa8830",
    "name": ["skatt.person.2019.rawdata"]
  },
  "state": "RAW",
  "locations": ["gs://dev-datalager-store/datastore/skatt/person/rawdata-2019"]
}'

# dapla-catalog
# read dataset
curl --location --request GET 'http://localhost:18070/dataset/341b03d6-5be6-4c9b-b381-8cf692aa8830'

# dapla-spark
# read dataset meta
curl --location --request GET 'http://localhost:18060/dataset-meta?name=skatt.person.2019.rawdata&operation=READ&userId=user1'
