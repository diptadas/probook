# HAProxy Soft Reload

## Build and run docker container

```console
$ docker build -t diptadas/ha184 .
$ docker run -it -v $(pwd)/config:/etc/haproxy -p 9090:9090 -p 9080:9080 diptadas/ha184
```

## Run test

```console
$ ./test.sh
```
