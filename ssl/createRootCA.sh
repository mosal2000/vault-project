#!/usr/bin/env bash

if [ ! -d "~/ssl" ]; then
  mkdir ~/ssl
fi

openssl genrsa -des3 -out ~/ssl/rootCA.key 8192
openssl req -x509 -new -nodes -key ~/ssl/rootCA.key -sha512 -days 730 -out ~/ssl/rootCA.pem
