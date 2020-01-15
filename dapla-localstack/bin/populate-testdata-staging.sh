# dataset-access
# create role for rawdata
curl -i -X PUT 'https://dataset-access.staging-bip-app.ssb.no/role/skatt.person.rawdata' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <insert_token_here>' \
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
curl -i -X PUT 'https://dataset-access.staging-bip-app.ssb.no/role/skatt.person.inndata' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <insert_token_here>' \
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

## dataset-access
## get roles
curl -i 'https://dataset-access.staging-bip-app.ssb.no/role/skatt.person.rawdata' \
--header 'Authorization: Bearer <insert_token_here>'

curl -i 'https://dataset-access.staging-bip-app.ssb.no/role/skatt.person.inndata' \
--header 'Authorization: Bearer <insert_token_here>'

#
## dataset-access
## create users
curl -i -X PUT 'https://dataset-access.staging-bip-app.ssb.no/user/user1' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <insert_token_here>' \
--data-raw '{ "userId" : "user1", "roles" : [ "skatt.person.rawdata" ] }'

curl -i -X PUT 'https://dataset-access.staging-bip-app.ssb.no/user/user2' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <insert_token_here>' \
--data-raw '{ "userId" : "user2", "roles" : [ "skatt.person.inndata" ] }'

## dataset-access
## get user
curl -i 'https://dataset-access.staging-bip-app.ssb.no/user/user1' \
--header 'Authorization: Bearer <insert_token_here>'

curl -i 'https://dataset-access.staging-bip-app.ssb.no/user/user2' \
--header 'Authorization: Bearer <insert_token_here>'

## dataset-access
## get access
## should have access
curl -i 'https://dataset-access.staging-bip-app.ssb.no/access/user1?privilege=READ&namespace=skatt.person&valuation=SENSITIVE&state=RAW' \
--header 'Authorization: Bearer <insert_token_here>'

curl -i 'https://dataset-access.staging-bip-app.ssb.no/access/user2?privilege=READ&namespace=skatt.person&valuation=SENSITIVE&state=INPUT' \
--header 'Authorization: Bearer <insert_token_here>'

## should not have access
curl -i 'https://dataset-access.staging-bip-app.ssb.no/access/user2?privilege=READ&namespace=skatt.person&valuation=SENSITIVE&state=RAW' \
--header 'Authorization: Bearer <insert_token_here>'

## dapla-catalog
#
## map name to id
curl -i -X POST 'https://dapla-catalog.staging-bip-app.ssb.no/name/skatt.person.2019.rawdata/341b03d6-5be6-4c9b-b381-8cf692aa8830' \
--header 'Authorization: Bearer <insert_token_here>'

## check mapping
curl -i 'https://dapla-catalog.staging-bip-app.ssb.no/name/skatt.person.2019.rawdata' \
--header 'Authorization: Bearer <insert_token_here>'

## check listing
curl -i 'https://dapla-catalog.staging-bip-app.ssb.no/prefix/skatt' \
--header 'Authorization: Bearer <insert_token_here>'

## create dataset
curl -i -X PUT 'https://dapla-catalog.staging-bip-app.ssb.no/dataset/341b03d6-5be6-4c9b-b381-8cf692aa8830' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <insert_token_here>' \
--data-raw '{
  "id": {
    "id": "341b03d6-5be6-4c9b-b381-8cf692aa8830",
    "name": ["skatt.person.2019.rawdata"]
  },
  "state": "RAW",
  "locations": ["gs://dev-datalager-store/datastore/skatt/person/rawdata-2019"]
}'

## dapla-catalog
## read dataset
curl -i 'https://dapla-catalog.staging-bip-app.ssb.no/dataset/341b03d6-5be6-4c9b-b381-8cf692aa8830' \
--header 'Authorization: Bearer <insert_token_here>'

## dapla-spark
## read dataset meta
curl -i 'https://dapla-spark.staging-bip-app.ssb.no/dataset-meta?name=skatt.person.2019.rawdata&operation=READ&userId=user1' \
--header 'Authorization: Bearer <insert_token_here>'
