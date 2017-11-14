#!/bin/bash

##### 1. fetch PASSPHRASE from Ayla Vault
#cat /var/run/secrets/boostport.com/vault-token | jq -r .clientToken > /tmp/token.txt
curl -X GET -H"X-VAULT-TOKEN: `cat /var/run/secrets/boostport.com/vault-token | jq -r .clientToken`" "http://tc-staging.ayla.com.cn:8200/v1/secret/ecryptfs-passphrase" > /tmp/passphrase.txt

#PASSPHRASE=$(curl -X GET -H"X-VAULT-TOKEN: `cat /var/run/secrets/boostport.com/vault-token | jq -r .clientToken`" "http://tc-staging.ayla.com.cn:8200/v1/secret/ecryptfs-passphrase" | jq -r .data.value)


##### 2. decrypt & extract & remove the source code tarball
SRC_FILE="/ayla/source_tarball.tgz"
/usr/bin/ccdecrypt -K `cat /tmp/passphrase.txt | jq -r .data.value` ${SRC_FILE}.cpt
#/usr/bin/ccdecrypt -K ${PASSPHRASE} ${SRC_FILE}.cpt
(cd /ayla/dummy_prj/; tar zxf ${SRC_FILE})
rm -f ${SRC_FILE}	# has to remove it since it's been decrypted


##### 3. start init, get passenger ready to receive requests
exec /sbin/my_init
