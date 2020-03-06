#!/usr/bin/env bash

keytool -genkeypair -alias dataAccessKeyPair -keyalg RSA -keysize 2048 -dname "dc=ssb,dc=no,ou=dapla,cn=data-access" -validity 10000 -storetype PKCS12 -keystore metadata-signer_keystore.p12 -storepass changeit
keytool -exportcert -alias dataAccessKeyPair -storetype PKCS12 -keystore metadata-signer_keystore.p12 -file metadata-signer_certificate.cer -rfc -storepass changeit
keytool -importcert -alias dataAccessCertificate -storetype PKCS12 -keystore metadata-verifier_keystore.p12 -file metadata-signer_certificate.cer -rfc -storepass changeit
