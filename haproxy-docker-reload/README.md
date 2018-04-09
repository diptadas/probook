# HAProxy Hitless Reload

## Build and run docker container

```console
$ docker build -t diptadas/hp185 .
$ docker run -it -v $(pwd)/config:/etc/haproxy -p 9090:9090 diptadas/hp185
```
