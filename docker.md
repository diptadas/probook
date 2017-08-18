### Stop and remove all docker containers

```
$ docker stop $(docker ps -a -q)
$ docker rm $(docker ps -a -q)
```

### Remove all dangling images

```
$ docker images --qf dangling=true | xargs --no-run-if-empty docker rmi
```

### Export/import docker image/container

```
docker save: save an image in tar file
$ docker save diptadas/bkz-utils > docker-bkz-utils.tar

docker export: save a container in tar file
$ docker export 2fe669cc6128 > docker-bkz-utils.tar

docker commit: create a new image based on a container
$ docker commit 2fe669cc6128 diptadas/bkz-utils

docker load: load a image from tar file
$ docker load < docker-bkz-utils.tar
```

### Docker without sudo

```
$ sudo groupadd docker
$ sudo gpasswd -a $USER docker
```