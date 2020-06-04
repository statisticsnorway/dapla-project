#!/usr/bin/env bash

put $consept_lds '/ns/RepresentedVariable/RepresentedVariable_DUMMY' '{
 "lastUpdatedBy": "Test",
 "name": [
  {
   "languageCode": "nb",
   "languageText": "RepresentedVariable_DUMMY"
  }
 ], 
 "description": [
  {
   "languageCode": "nb",
   "languageText": "RepresentedVariable_DUMMY"
  }
 ],
 "validFrom": "2019-02-19T10:25:44.663Z",
 "version": "1.0.1",
 "versionValidFrom": "2019-02-19T10:27:02.911Z",
 "lastUpdatedDate": "2019-02-19T10:27:02.911Z",
 "createdDate": "2019-02-19T10:25:44.663Z",
 "createdBy": "Test",
 "universe": "/Universe/Universe_DUMMY",
 
 "substantiveValueDomain": "/DescribedValueDomain/DescribedValueDomain_DUMMY",
 "variable": "/Variable/Variable_DUMMY",
 "id": "RepresentedVariable_DUMMY",
 "administrativeStatus": "INTERNAL"
}'

# Some have been using norwegian spelling for this. Add it so we avoid errors because of this for now
put $consept_lds '/ns/RepresentedVariable/RepresentertVariable_DUMMY' '{
 "lastUpdatedBy": "Test",
 "name": [
  {
   "languageCode": "nb",
   "languageText": "RepresentertVariable_DUMMY"
  }
 ], 
 "description": [
  {
   "languageCode": "nb",
   "languageText": "RepresentertVariable_DUMMY"
  }
 ],
 "validFrom": "2019-02-19T10:25:44.663Z",
 "version": "1.0.1",
 "versionValidFrom": "2019-02-19T10:27:02.911Z",
 "lastUpdatedDate": "2019-02-19T10:27:02.911Z",
 "createdDate": "2019-02-19T10:25:44.663Z",
 "createdBy": "Test",
 "universe": "/Universe/Universe_DUMMY",
 
 "substantiveValueDomain": "/DescribedValueDomain/DescribedValueDomain_DUMMY",
 "variable": "/Variable/Variable_DUMMY",
 "id": "RepresentertVariable_DUMMY",
 "administrativeStatus": "INTERNAL"
}'


put $consept_lds '/ns/Variable/Variable_DUMMY' '{
 "unitType": "/UnitType/UnitType_DUMMY",
 "lastUpdatedBy": "rl",
 "lastUpdatedDate": "2020-01-01T00:00:00Z",
 "createdDate": "2020-01-01T00:00:00Z",
 "createdBy": "Test",
 "name": [
  {
   "languageCode": "nb",
   "languageText": "Variable_DUMMY"
  }
 ],
 "description": [
  {
   "languageCode": "nb",
   "languageText": "Variable_DUMMY"
  }
 ],
 "id": "Variable_DUMMY",
 "validFrom": "2020-01-01T00:00:00Z",
 "version": "1.0.1",
 "versionValidFrom": "2020-01-01T00:00:00Z",
 "administrativeStatus": "INTERNAL",
 "subjectFields": [
   "/SubjectField/SubjectField_DUMMY"
  ]
}'

put $consept_lds '/ns/UnitType/UnitType_DUMMY' '{
    "id": "UnitType_DUMMY",
    "name": [
      {
        "languageCode": "en",
        "languageText": "UnitType_DUMMY"
      },
      {
        "languageCode": "nb",
        "languageText": "Enhetstype_DUMMY"
      }
    ],
    "description": [
      {
        "languageCode": "en",
        "languageText": "UnitType_DUMMY"
      },
      {
        "languageCode": "nb",
        "languageText": "Enhetstype_DUMMY"
      }
    ],
    "typeOfStatisticalUnit": "NOT_APPLICABLE",
    "administrativeStatus": "INTERNAL",
    "version": "1.0.0",
    "versionValidFrom": "1985-01-01T15:00:00.000Z",
    "validFrom": "1985-01-01T15:00:00.000Z",
    "createdDate": "1985-01-01T15:00:00.000Z",
    "createdBy": "OBV"
}'

put $consept_lds '/ns/DescribedValueDomain/DescribedValueDomain_DUMMY' '{
    "id": "DescribedValueDomain_DUMMY",
    "name": [
      {
        "languageCode": "en",
        "languageText": "DescribedValueDomain_DUMMY"
      }

    ],
    "description": [
      {
        "languageCode": "en",
        "languageText": "DescribedValueDomain_DUMMY"
      }
    ],
    "administrativeStatus": "INTERNAL",
    "version": "1.0.0",
    "versionValidFrom": "1985-01-01T15:00:00.000Z",
    "validFrom": "1985-01-01T15:00:00.000Z",
    "createdDate": "1985-01-01T15:00:00.000Z",
    "createdBy": "OBV",
    "dataType":"STRING"
}'

put $consept_lds '/ns/SubjectField/SubjectField_DUMMY' '{
 "lastUpdatedBy": "Test",
 "lastUpdatedDate": "2019-02-18T12:21:20.019Z",
 "createdDate": "2019-02-18T08:53:22.603Z",
 "createdBy": "Test",
 "name": [
  {
   "languageCode": "nb",
   "languageText": "SubjectField_DUMMY"
  }
 ],
 "description": [
  {
   "languageCode": "nb",
   "languageText": "Standard for SSBs emneinndeling - SubjectField_DUMMY"
  }
 ],
 "id": "SubjectField_DUMMY",
 "validFrom": "2019-02-18T08:53:22.603Z",
 "version": "1.0.2",
 "administrativeDetails": [
  {
   "values": [
    " Subject Field bør ha peker til KLASS, siden de ligger der. https://www.ssb.no/klass/klassifikasjoner/15",
    "Mangler mulighet i KLASS til å peke til spesifikt klassifikasjonselement innen en klassifikasjon."
   ],
   "administrativeDetailType": "ANNOTATION"
  }
 ],
 "versionValidFrom": "2019-02-18T12:21:20.019Z"
}'
