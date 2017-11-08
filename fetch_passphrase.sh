#!/bin/bash

cat /var/run/secrets/boostport.com/vault-token | jq -r .clientToken > /tmp/token.txt

curl -X GET -H"X-VAULT-TOKEN: `cat /var/run/secrets/boostport.com/vault-token | jq -r .clientToken`" "http://tc-staging.ayla.com.cn:8200/v1/secret/ecryptfs-passphrase" > /tmp/passphrase.txt

# PASSPHRASE="<passphrase>"
# echo -n $PASSPHRASE | ecryptfs-add-passphrase		# get the sig into $SIG
# mount -t ecryptfs -o key=passphrase:passphrase_passwd=$PASSPHRASE,no_sig_cache=yes,verbose=no,ecryptfs_sig=$SIG,ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_passthrough=no,ecryptfs_enable_filename_crypto=no /ayla/dummy_prj

exec /sbin/my_init
