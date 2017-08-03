## common useful commands

### one liner self-signed certificate
```shell
openssl req \  
-subj '/CN=domain.com/O=My Company Name LTD./C=US' \  
-new \  
-newkey rsa:2048 \  
-days 365 \  
-nodes \  
-x509 \  
-sha256  \  
-keyout server.key \  
-out server.crt
```
