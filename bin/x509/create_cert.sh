#!/bin/bash
openssl genrsa \
  -out machine.key 2048



openssl req \
  -new \
  -key machine.key \
  -out machine.csr





openssl x509 \
  -req \
  -in machine.csr \
  -CA rootCA.pem \
  -CAkey rootCA.key \
  -CAcreateserial \
  -out machine.crt \
  -days 500 \
  -sha256
