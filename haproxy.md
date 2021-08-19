# HAProxy

## Serve a static file

```
$ nano /etc/haproxy/haproxy.cfg

global
    daemon
    maxconn 256

defaults
    mode http
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

listen http-1
    bind *:1234
    errorfile 503 "/home/dipta/all/oauth-test/err.http"
```

```
$ haproxy -c -f /etc/haproxy/haproxy.cfg
$ sudo service haproxy restart
```

## Redirect https with port

```
defaults
    timeout client 30s
    timeout server 30s
    timeout connect 5s

frontend fe-1
    bind *:8080
    mode http

    http-request replace-header Host ^(.*?):[0-9]+$ \1:8443
    redirect scheme https code 308
```

```
$ haproxy -d -f haproxy.cfg
 
$ curl -vv -H "Host: voyager.appscode.xy" 127.0.0.1:8080
< HTTP/1.1 308 Permanent Redirect
< Location: https://voyager.appscode.xy/
 
$ curl -vv -H "Host: voyager.appscode.xy:8080" 127.0.0.1:8080
< HTTP/1.1 308 Permanent Redirect
< Location: https://voyager.appscode.xy:8443/
```


## TCP SNI (TLS Passthrough)

```
defaults
    timeout client 30s
    timeout server 30s
    timeout connect 5s

frontend fe-1
    bind *:8090
    mode tcp

    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }

    use_backend be-1 if { req_ssl_sni -i -m end appscode.test }
    use_backend be-2 if { req_ssl_sni -i voyager.appscode.com }

backend be-1
    mode tcp
    server sv-1 127.0.0.1:6443     

backend be-2
    mode tcp
    server sv-2 127.0.0.1:3443
```

## TCP SNI (TLS Offload)

```
defaults
	timeout client 30s
    timeout server 30s
    timeout connect 5s

frontend fe-1
	bind *:8090 ssl crt /tmp/mycerts/
	mode tcp

	tcp-request inspect-delay 5s
	tcp-request content accept if { req_ssl_hello_type 1 }

	use_backend be-1 if { ssl_fc_sni -i voyager.appscode.test }
	use_backend be-2 if { ssl_fc_sni -i voyager.appscode.com }

backend be-1
	mode tcp
	server sv-1 127.0.0.1:9090    

backend be-2
	mode tcp
	server sv-2 127.0.0.1:8989
```
