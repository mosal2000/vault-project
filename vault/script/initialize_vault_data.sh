#!/bin/bash

# PATH=/usr/local/bin/

# exit when any command fails
set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

echo "Running initialize_vault_data.sh"

# vault login -tls-skip-verify $(awk -F ":" '/InitialRootToken/ {print $2}' /vault/init/vault_token.ini)

vault kv put -tls-skip-verify secret/portal \
    django_secret_key=t8gng\=6p4\#hhu7lu\@kvi7wbh5i0_a7oj\^\#5sf\(5umg \
    gitlab_token=kDkaQQ 
