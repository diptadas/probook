# HAProxy TCP SNI

## Run test server

```console
$ docker run -p 6443:6443 -p 3443:3443 appscode/test-server:2.2

https server running on port :6443
http server running on port :8080
tcp server listening on port :4343
tcp server listening on port :4545
tcp server listening on port :5656
proxy server listening on port :6767
http server running on port :8989
http server running on port :9090
https server running on port :3443
2018/04/17 09:39:45 written cert.pem
2018/04/17 09:39:45 written key.pem
2018/04/17 09:39:46 written cert.pem
2018/04/17 09:39:46 written key.pem
```

## Run haproxy

```console
$ cat config.cfg

defaults
    timeout client 30s
    timeout server 30s
    timeout connect 5s

frontend fe-1
    bind *:8090
    mode tcp

    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }

    use_backend be-1 if { req_ssl_sni -i voyager.appscode.test }
    use_backend be-2 if { req_ssl_sni -i voyager.appscode.com }

backend be-1
    mode tcp
    server sv-1 127.0.0.1:6443     

backend be-2
    mode tcp
    server sv-2 127.0.0.1:3443
```

```console
$ haproxy -d -f config.cfg 

Note: setting global.maxconn to 2000.
Available polling systems :
      epoll : pref=300,  test result OK
       poll : pref=200,  test result OK
     select : pref=150,  test result FAILED
Total: 3 (2 usable), will use epoll.

Available filters :
    [SPOE] spoe
    [COMP] compression
    [TRACE] trace
Using epoll() as the polling mechanism.
```

## Update /etc/hosts

```console
$ nano /etc/hosts

127.0.0.1   voyager.appscode.test
127.0.0.1   voyager.appscode.com
127.0.0.1   voyager.appscode.org
```

## Send request

```console
$ curl -k http://voyager.appscode.test:8090
curl: (52) Empty reply from server

$ curl -k https://voyager.appscode.test:8090
{"type":"http","host":"voyager.appscode.test:8090","serverPort":":6443","path":"/","method":"GET","headers":{"Accept":["*/*"],"User-Agent":["curl/7.47.0"]}}

$ curl -k https://voyager.appscode.com:8090
{"type":"http","host":"voyager.appscode.com:8090","serverPort":":3443","path":"/","method":"GET","headers":{"Accept":["*/*"],"User-Agent":["curl/7.47.0"]}}

$ curl -k https://voyager.appscode.org:8090
curl: (35) gnutls_handshake() failed: The TLS connection was non-properly terminated.
```