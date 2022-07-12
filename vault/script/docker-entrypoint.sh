#!/bin/bash

# PATH=/usr/local/bin/

echo "Running docker-entrypoint.sh"

# chmod 710  ./script/*.sh 

# Run vault
exec vault server -config=/vault/config/vault-config.json &

# Wait for vault to run
# wait-for-it.sh -t 120 localhost:8200 -- initialized_vault_data.sh
# dockerize  -wait localhost:8200 initialized_vault_data.sh

initialize_vault.sh > /vault/init/init.out

# chmod 700 /usr/local/bin/initialize_vault.sh
# chmod 700 /usr/local/bin/initialize_vault_data.sh
# chmod 700 /usr/local/bin/docker-entrypoint.sh

# chmod 700  ./script/*.sh 

chmod 600 /vault/init/init.out

while :; do sleep 1; done