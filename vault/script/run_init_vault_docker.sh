#!/bin/bash

# PATH=/usr/local/bin/

# exit when any command fails
set -e

# Need to run this script as root

if [ "$EUID" -ne 0 ]
  then echo "Plea se run this script as root!!!"
  exit
fi

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT


docker exec -it $(docker ps | awk '/_vault_/  {print $NF}') bash initialize_vault_data.sh

if [ ! -d "/vault" ];then
  mkdir /vault
fi

if [ ! -d "/vault/init" ];then
  mkdir /vault/init 
fi

docker cp $(docker ps | awk '/_vault_/  {print $1}'):/vault/init/vault_token.ini /vault/init/vault_token.ini
docker cp $(docker ps | awk '/_vault_/  {print $1}'):/vault/init/vault_keys.ini /vault/init/vault_keys.ini

chmod 640 /vault/init/*.ini


echo "Script is completed and Vault is unsealed!"
