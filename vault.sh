#!/bin/bash

vault server -config=vault-example.hcl &
export VAULT_ADDR='http://127.0.0.1:8200'
vault init > secrets.txt
sed -n 1p secrets.txt | cut -d':' -f2| tr -d '[[:space:]]' | xargs vault unseal
sed -n 2p secrets.txt | cut -d':' -f2| tr -d '[[:space:]]' | xargs vault unseal
sed -n 3p secrets.txt | cut -d':' -f2| tr -d '[[:space:]]' | xargs vault unseal
eval $(echo export VAULT_TOKEN=$(sed -n 6p secrets.txt | cut -d':' -f2| tr -d '[[:space:]]'))

sleep 5
echo $VAULT_TOKEN | xargs vault auth

vault write secret/example/production/username value=user
vault write secret/example/production/password value=password12345
vault write secret/example/production/foo value=bar
