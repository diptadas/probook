### Stop and remove all docker containers

```
$ docker stop $(docker ps -a -q)
$ docker rm $(docker ps -a -q)
```

### Remove all dangling images

```
$ docker images --qf dangling=true | xargs --no-run-if-empty docker rmi
```