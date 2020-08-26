#!/usr/bin/env bash

cd $(dirname $BASH_SOURCE)/../..
mkdir -p localstack/secret
mkdir -p data-access/secret
mkdir -p metadata-distributor/secret
mkdir -p dapla-catalog/secret

cd localstack/secret
keytool -genkeypair -alias dataAccessKeyPair -keyalg RSA -keysize 2048 -dname "dc=ssb,dc=no,ou=dapla,cn=data-access" -validity 10000 -storetype PKCS12 -keystore metadata-signer_keystore.p12 -storepass changeit
keytool -exportcert -alias dataAccessKeyPair -storetype PKCS12 -keystore metadata-signer_keystore.p12 -file metadata-signer_certificate.cer -rfc -storepass changeit
keytool -importcert -alias dataAccessCertificate -storetype PKCS12 -keystore metadata-verifier_keystore.p12 -file metadata-signer_certificate.cer -rfc -storepass changeit <<< yes

keytool -genkeypair -alias catalogKeyPair -keyalg RSA -keysize 2048 -dname "dc=ssb,dc=no,ou=dapla,cn=catalog" -validity 10000 -storetype PKCS12 -keystore catalog-signer_keystore.p12 -storepass changeit
keytool -exportcert -alias catalogKeyPair -storetype PKCS12 -keystore catalog-signer_keystore.p12 -file catalog-signer_certificate.cer -rfc -storepass changeit
keytool -importcert -alias catalogCertificate -storetype PKCS12 -keystore catalog-verifier_keystore.p12 -file catalog-signer_certificate.cer -rfc -storepass changeit <<< yes

cd -
cp localstack/secret/metadata-signer_keystore.p12 data-access/secret
cp localstack/secret/metadata-verifier_keystore.p12 metadata-distributor/secret

# DOTO cp the signer file to the right location of jupyter
cp localstack/secret/catalog-verifier_keystore.p12 dapla-catalog/secret
