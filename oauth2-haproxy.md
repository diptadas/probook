# HAProxy OAuth2

## Requirements

- [bitly/oauth2_proxy](https://github.com/bitly/oauth2_proxy)
- [TimWolla/haproxy-auth-request](https://github.com/TimWolla/haproxy-auth-request)

## Demo without SSL

### HAProxy config

```console
$ cat /etc/haproxy/haproxy.cfg

global
        lua-load /root/auth-request.lua

        log /dev/log    local0
        log /dev/log    local1 notice
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
        stats timeout 30s
        user haproxy
        group haproxy
        daemon

        # Default SSL material locations
        ca-base /etc/ssl/certs
        crt-base /etc/ssl/private

        # Default ciphers to use on SSL-enabled listening sockets.
        # For more information, see ciphers(1SSL). This list is from:
        #  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
        # An alternative list with additional directives can be obtained from
        #  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
        ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES$
        ssl-default-bind-options no-sslv3

defaults
        log     global
        mode    http
        option  httplog
        option  dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
        errorfile 400 /etc/haproxy/errors/400.http
        errorfile 403 /etc/haproxy/errors/403.http
        errorfile 408 /etc/haproxy/errors/408.http
        errorfile 500 /etc/haproxy/errors/500.http
        errorfile 502 /etc/haproxy/errors/502.http
        errorfile 503 /etc/haproxy/errors/503.http
        errorfile 504 /etc/haproxy/errors/504.http

backend auth_request
        mode http
        server auth_request 127.0.0.1:4180

backend app
        mode http

        http-request lua.auth-request auth_request /oauth2/auth
        http-request redirect location /oauth2/start?rd=http://voyager.appscode.ninja if ! { var(txn.auth_response_successful) -m bool }

        server app 138.197.59.213:80

frontend http
        mode http
        bind *:80

        acl acl_host hdr(host) -i voyager.appscode.ninja
        acl acl_host hdr(host) -i voyager.appscode.ninja:80

        acl acl_path_oauth2 path_beg /oauth2
        use_backend auth_request if acl_path_oauth2 acl_host

        use_backend app if acl_host
```

### Setup github oauth app

```
callback-url: http://voyager.appscode.ninja/oauth2
```

### Run oauth2_proxy

```console
$ ./oauth2_proxy \
-provider=github \
-client-id=... \
-client-secret=... \
-email-domain=* \
-upstream=file:///dev/null \
-cookie-secret=secretsecret \
-cookie-secure=false
```

## Demo with SSL

### Notes

- Set cookie-secure=true (default value)
- Remove ending `$` from `ssl-default-bind-ciphers`, otherwise you will get `unable to set SSL cipher` error
- Use `https` in redirect-url and github callback-url 
- Redirect `http` to `https`, otherwise you will get `permission denied: http: named cookie not present` error

### Generate certs

```
$ openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /tmp/tls.key -out /tmp/tls.crt -subj "/CN=voyager.appscode.ninja"
$ cat /tmp/tls.crt /tmp/tls.key | tee /tmp/tls.pem
```

### HAProxy config

```console
$ cat /etc/haproxy/haproxy.cfg

global
        lua-load /root/auth-request.lua

        log /dev/log    local0
        log /dev/log    local1 notice
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
        stats timeout 30s
        user haproxy
        group haproxy
        daemon

        # Default SSL material locations
        ca-base /etc/ssl/certs
        crt-base /etc/ssl/private

        # Default ciphers to use on SSL-enabled listening sockets.
        # For more information, see ciphers(1SSL). This list is from:
        #  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
        # An alternative list with additional directives can be obtained from
        #  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
        ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES
        ssl-default-bind-options no-sslv3

defaults
        log     global
        mode    http
        option  httplog
        option  dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
        errorfile 400 /etc/haproxy/errors/400.http
        errorfile 403 /etc/haproxy/errors/403.http
        errorfile 408 /etc/haproxy/errors/408.http
        errorfile 500 /etc/haproxy/errors/500.http
        errorfile 502 /etc/haproxy/errors/502.http
        errorfile 503 /etc/haproxy/errors/503.http
        errorfile 504 /etc/haproxy/errors/504.http

backend auth_request
        mode http
        server auth_request 127.0.0.1:4180

backend app
        mode http

        http-request lua.auth-request auth_request /oauth2/auth
        http-request redirect location /oauth2/start?rd=https://voyager.appscode.ninja if ! { var(txn.auth_respons$

        server app 138.197.59.213:80

frontend http
        mode http

        bind *:80

        bind *:443 ssl crt /tmp/tls.pem
        redirect scheme https if !{ ssl_fc }

        acl acl_host hdr(host) -i voyager.appscode.ninja
        acl acl_host hdr(host) -i voyager.appscode.ninja:80
```

### Setup github oauth app

```
callback-url: https://voyager.appscode.ninja/oauth2
```

### Run oauth2_proxy

```console
$ ./oauth2_proxy \
-provider=github \
-client-id=... \
-client-secret=... \
-email-domain=* \
-upstream=file:///dev/null \
-cookie-secret=secretsecret
```
