# TLS

## TLS Server Client:

### Generate certs:

- Server: CA + server-key ---> server.crt
- Client: CA + client-key ---> client.crt

### Handshake:

1. Client ---> hello ---> Server
2. Server ---> server.crt ---> Client
3. Client ---> verifies server.crt using CA
4. Client ---> client.crt + encrypted session-key using server.crt ---> Server
5. Server ---> verifies client.crt using CA and decrypt session-key using server.key
6. Server ---> encrypted session-key using client.crt ---> Client
7. Client ---> decrypt session-key using client.key and matches it with session-key he sent before

### Communicate:

- Client-Server communicate using symmetric session-key established by handshaking

## Openssl Generate Certs:

```
$ openssl genrsa -aes256 -out ca.key 2048
$ openssl req -new -x509 -days 7300 -key ca.key -sha256 -extensions v3_ca -out ca.crt

$ openssl genrsa -out server.key 2048
$ openssl req -sha256 -new -key server.key -out server.csr
$ openssl x509 -sha256 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 7300

$ openssl verify -CAfile ca.crt server.crt
```

## Reference:

- https://superuser.com/questions/620121/what-is-the-difference-between-a-certificate-and-a-key-with-respect-to-ssl
- https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs
- https://gist.github.com/kyledrake/d7457a46a03d7408da31
- https://gist.github.com/Soarez/9688998
