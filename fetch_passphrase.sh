#!/bin/bash

##### 1. fetch PASSPHRASE from Ayla Vault
#cat /var/run/secrets/boostport.com/vault-token | jq -r .clientToken > /tmp/token.txt
#curl -X GET -H"X-VAULT-TOKEN: `cat /var/run/secrets/boostport.com/vault-token | jq -r .clientToken`" "http://tc-staging.ayla.com.cn:8200/v1/secret/ecryptfs-passphrase" > /tmp/passphrase.txt

VAULT_ADDR='http://tc-staging.ayla.com.cn:8200'
VAULT_TOKEN=`cat /var/run/secrets/boostport.com/vault-token | jq -r .clientToken`
PASSPHRASE=$(curl -X GET -H"X-VAULT-TOKEN: ${VAULT_TOKEN}" "${VAULT_ADDR}/v1/secret/src-decrypt-pass" | jq -r .data.value)


##### 2. decrypt & extract & remove the source code tarball
SRC_FILE="/ayla/source_tarball.tgz.cpt"
DST_FILE="/ayla/userservice/source_tarball.tgz"
mv ${SRC_FILE} ${DST_FILE}.cpt
#/usr/bin/ccdecrypt -K `cat /tmp/passphrase.txt | jq -r .data.value` ${SRC_FILE}.cpt
/usr/bin/ccdecrypt -K ${PASSPHRASE} ${DST_FILE}.cpt
(cd /ayla/userservice/; tar zxf ${DST_FILE})
rm -f ${DST_FILE}	# has to remove it since it's been decrypted
chown -R www-data /ayla/userservice


##### 3. start init, get passenger ready to receive requests
exec /sbin/my_init
