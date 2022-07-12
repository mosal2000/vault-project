# base image
FROM alpine:3.10
MAINTAINER Mohammad Ronosentono <mohammad.ronosentono@gmail.com>

# set vault version
ENV VAULT_VERSION 1.4.0

# create a new directory
RUN mkdir /vault && mkdir /vault/init

# download dependencies
RUN apk --no-cache add \
      openssl musl-dev \
      bash \
      ca-certificates \
      wget 
    #   libcap

# Update CA-Certificates
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
# RUN update-ca-certificates

# download and set up vault
RUN wget --quiet --output-document=/tmp/vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
    unzip /tmp/vault.zip -d /vault && \
    rm -f /tmp/vault.zip && \
    chmod +x /vault

# RUN setcap cap_ipc_lock=+ep /vault/vault

# update PATH
ENV PATH="PATH=$PATH:/vault"

# add the config file
COPY ./config/vault-config.json /vault/config/vault-config.json

# add the script file
COPY ./script/initialize_vault.sh /usr/local/bin/initialize_vault.sh
COPY ./script/initialize_vault_data.sh /usr/local/bin/initialize_vault_data.sh
COPY ./script/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# add the script file
COPY ./script/wait-for-it.sh /usr/local/bin/wait-for-it.sh

# expose port 8200
EXPOSE 8200

# run vault
ENTRYPOINT ["docker-entrypoint.sh"]

