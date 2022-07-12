#!/usr/bin/env bash
sudo su -c 'openssl req -new -sha512 -nodes -out server.csr -newkey rsa:8192 -keyout vault.stil.io.key -config <( cat server.csr.cnf )'

sudo openssl x509 -req -in server.csr -CA ~/ssl/rootCA.pem -CAkey ~/ssl/rootCA.key -CAcreateserial -out server.crt -days 730 -sha512 -extfile v3.ext

sudo openssl x509 -in server.crt -out vault.pem -outform PEM

