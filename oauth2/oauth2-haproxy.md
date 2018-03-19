# HAProxy OAuth2

## Requirements

- [bitly/oauth2_proxy](https://github.com/bitly/oauth2_proxy)
- [TimWolla/haproxy-auth-request](https://github.com/TimWolla/haproxy-auth-request)
- HAProxy 1.8.4

## Demo without SSL

### HAProxy config

```console
$ cat /etc/haproxy/haproxy.cfg

global
        lua-load auth-request.lua

defaults
        mode    http
        timeout connect 5000
        timeout client  50000
        timeout server  50000

backend auth_request
        server auth_request 127.0.0.1:4180

backend app
        http-request lua.auth-request auth_request /oauth2/auth
        http-request redirect location /oauth2/start?rd=http://voyager.appscode.ninja if ! { var(txn.auth_response_successful) -m bool }

        server app 138.197.59.213:80

frontend http
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

- Set `cookie-secure=true` (default value)
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
        lua-load auth-request.lua
        tune.ssl.default-dh-param 2048

defaults
        mode    http
        timeout connect 5000
        timeout client  50000
        timeout server  50000

backend auth_request
        server auth_request 127.0.0.1:4180

backend app
        http-request lua.auth-request auth_request /oauth2/auth
        http-request redirect location /oauth2/start?rd=https://voyager.appscode.ninja if ! { var(txn.auth_response_successful) -m bool }

        server app 138.197.59.213:80

frontend http
        bind *:80

        bind *:443 ssl crt /tmp/tls.pem
        redirect scheme https if !{ ssl_fc }

        acl acl_host hdr(host) -i voyager.appscode.ninja
        acl acl_host hdr(host) -i voyager.appscode.ninja:80

        acl acl_path_oauth2 path_beg /oauth2
        use_backend auth_request if acl_path_oauth2 acl_host

        use_backend app if acl_host
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
