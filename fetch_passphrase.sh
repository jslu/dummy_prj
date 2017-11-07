#!/bin/bash

cat /var/run/secrets/boostport.com/vault-token | jq -r .clientToken > /tmp/token.txt

curl -X GET -H"X-VAULT-TOKEN: `cat /var/run/secrets/boostport.com/vault-token | jq -r .clientToken`" "http://tc-staging.ayla.com.cn:8200/v1/secret/ecryptfs-passphrase" > /tmp/passphrase.txt

exec /sbin/my_init
