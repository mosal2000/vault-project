# Vault project

Vault stores sensitive data such as tokens, keys, passwords, etc. The scripts set up Vault automatically. 

## Running Vault

```bash
$ docker-compose up -d
```

## Setting Up Vault

Run the following command from the docker host to initialize and unseal Vault. It needs to be run as a root (sudo).

```bash
$ ./run_init_vault_docker.sh 
```

## Resetting Vault

To clean Vault Docker images, data, and logs, run the following command.

```bash
$ ./reset_vault_docker.sh
```
