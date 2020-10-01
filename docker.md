### Stop and remove all docker containers

```
$ docker stop $(docker ps -a -q)
$ docker rm $(docker ps -a -q)
```

### Remove all dangling images

```
$ docker images -qf dangling=true | xargs --no-run-if-empty docker rmi
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

### Running GUI apps with Docker

**Dockerfile**

```
FROM ubuntu:16.04
RUN apt-get update && apt-get install -y firefox
CMD /usr/bin/firefox
```

**Build and Run**

```

$ docker build -t firefox-docker .

$ xhost local:root

$ docker run -it --rm \
       -e DISPLAY=$DISPLAY \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       firefox-docker

```

### Run PostgreSQL and pgAdmin

```
$ docker run -p 5432:5432 -e POSTGRES_USER=docker -e POSTGRES_PASSWORD=docker -e POSTGRES_DB=docker postgres
$ docker run -p 5050:80 -e PGADMIN_DEFAULT_EMAIL=admin@example.com -e PGADMIN_DEFAULT_PASSWORD=admin dpage/pgadmin4
```
