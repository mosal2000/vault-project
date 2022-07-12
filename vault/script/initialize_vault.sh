#!/bin/bash

# PATH=/usr/local/bin/

# exit when any command fails
set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

echo "Running initialize_vault.sh"

# Run vault
# vault server -config=/vault/config/vault-config.json &

# Wait for vault to run

echo "Initalization process"

sleep 7 

if [ ! -d "/vault" ];then
  mkdir /vault
fi

if [ ! -d "/vault/init" ];then
  mkdir /vault/init
fi

# rm -f /vault/init/*.*

InitStatus=`vault status -tls-skip-verify | awk '/Initialized/ {print $2}'`

if $InitStatus; then

  echo "Vault has been previously initialized. Unseal Vault and copy token to Djangoapp docker."

  vault operator unseal -tls-skip-verify $(awk -F ":" '/UnsealKey1/ {print $2}' /vault/init/vault_keys.ini)
  vault operator unseal -tls-skip-verify $(awk -F ":" '/UnsealKey2/ {print $2}' /vault/init/vault_keys.ini)
  vault operator unseal -tls-skip-verify $(awk -F ":" '/UnsealKey3/ {print $2}' /vault/init/vault_keys.ini)

  vault login -tls-skip-verify $(awk -F ":" '/InitialRootToken/ {print $2}' /vault/init/vault_token.ini)

else

  echo "Vault has not been initialized. Initialize Vault with new keys and token."

  vault operator init -tls-skip-verify > /vault/keys

  awk 'BEGIN{printf "[VAULT_KEYS]\n"} /Unseal|Initial/ {gsub(" ","");print}' /vault/keys  > /vault/init/vault_keys.ini

  awk 'BEGIN{printf "[VAULT_TOKEN]\n"} /Initial/ {print}' /vault/init/vault_keys.ini > /vault/init/vault_token.ini

  # ENV_TOKEN=(cat vault_token.ini | awk '/Initial/ {gsub(":","=")} {print} ')
  # echo $ENV_TOKEN

  chmod 600 /vault/init/vault_keys.ini
  chmod 600 /vault/init/vault_token.ini

  rm -f /vault/keys

  vault operator unseal -tls-skip-verify $(awk -F ":" '/UnsealKey1/ {print $2}' /vault/init/vault_keys.ini)
  vault operator unseal -tls-skip-verify $(awk -F ":" '/UnsealKey2/ {print $2}' /vault/init/vault_keys.ini)
  vault operator unseal -tls-skip-verify $(awk -F ":" '/UnsealKey3/ {print $2}' /vault/init/vault_keys.ini)

  vault login -tls-skip-verify $(awk -F ":" '/InitialRootToken/ {print $2}' /vault/init/vault_token.ini)

  vault secrets enable -tls-skip-verify -path=secret kv
  vault kv enable-versioning -tls-skip-verify secret

  if [ ! -d "/vault/logs" ]; then
    mkdir /vault/logs
  fi

  vault audit enable -tls-skip-verify file file_path=/vault/logs/audit.log

fi

initialize_vault_data.sh

echo "Initialization is completed!"