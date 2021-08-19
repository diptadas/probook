# Docker

## Stop and remove all docker containers

```
$ docker stop $(docker ps -a -q)
$ docker rm $(docker ps -a -q)
```

## Remove all dangling images

```
$ docker images -qf dangling=true | xargs --no-run-if-empty docker rmi
```

## Networking

```
$ docker network inspect bridge

$ docker run -itd --name=container1 busybox
$ docker run -itd --name=container2 busybox

$ docker network inspect bridge

$ docker attach container1 # ifconfig (ctrl-p + ctrl-q)

$ docker network create myNet
$ docker network inspect myNet

$ docker network connect myNet container1
$ docker network connect myNet container2

$ docker network inspect myNet

$ docker attach container1 # ping 172.18.0.2
```

## Export/import image/container

- docker save: save an image in a tar file

```
$ docker save diptadas/bkz-utils > docker-bkz-utils.tar
```

- docker export: save a container in a tar file

```
$ docker export 2fe669cc6128 > docker-bkz-utils.tar
```

- docker commit: create a new image based on a container

```
$ docker commit 2fe669cc6128 diptadas/bkz-utils
```

- docker load: load an image from a tar file

```
$ docker load < docker-bkz-utils.tar
```

## Docker without sudo

- https://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo

```
$ sudo groupadd docker
$ sudo gpasswd -a $USER docker
```

## Docker local registry

- Run docker-registry at localhost:5000

```
$ docker run -d -p 5000:5000 --restart=always --name registry registry
```

- Build and tag docker image

```
$ docker build -t localhost:5000/my-image .
```

- Push image to repository

```
$ docker push localhost:5000/my-image
```

- Verify repository

```
$ curl -s -S localhost:5000/v2/_catalog
```

- Pull and run image

```
$ docker run -it localhost:5000/my-image sh
```

- Use image in minikube

```
$ curl -s -S http://192.168.99.1:5000/v2/_catalog
$ minikube start --insecure-registry=192.168.99.1:5000
$ kubectl run -it my-app --image=192.168.99.1:5000/my-image --port=9090 --command -- sh
```

#3 Bind volume mount

```
$ mkdir -p /tmp/busybox
$ touch /tmp/busybox/hello.txt

$ docker run -it --mount type=bind,source=/tmp/busybox,target=/app busybox
ls app  
```

## Docker multi-stage build

- https://medium.com/travis-on-docker/multi-stage-docker-builds-for-creating-tiny-go-images-e0e1867efe5a

```
FROM golang:alpine AS build-env
ADD . /src
RUN cd /src && go build -o goapp

FROM alpine
WORKDIR /app
COPY --from=build-env /src/goapp /app/
ENTRYPOINT ./goapp
```

## MySQL + PHPMyAdmin

```
$ docker run --name my-own-mysql -e MYSQL_ROOT_PASSWORD=mypass123 -d mysql:8.0.1
$ docker run --name my-own-phpmyadmin -d --link my-own-mysql:db -p 8081:80 phpmyadmin/phpmyadmin
```

- MySQL Dump

```
$ docker exec 8541e255c1d7 usr/bin/mysqldump -u root --password=pAss acmsacdb > db-2020-backup.sql
```

- MySQL Import

```
$ docker exec -i 33773096eab9 mysql -u root --password=pAss acmsacdb < sessionsDB.sql
```

### Run PostgreSQL and pgAdmin

```
$ docker run -p 5432:5432 -e POSTGRES_USER=docker -e POSTGRES_PASSWORD=docker -e POSTGRES_DB=docker postgres
$ docker run -p 5050:80 -e PGADMIN_DEFAULT_EMAIL=admin@example.com -e PGADMIN_DEFAULT_PASSWORD=admin dpage/pgadmin4
```

## Run Ubuntu desktop in Docker

```
$ docker run -p 6080:80 -e USER=das -e PASSWORD=das -v /Users/das/Downloads/dev/shm:/dev/shm dorowu/ubuntu-desktop-lxde-vnc
```

## Running GUI apps with Docker

- Dockerfile

```
FROM ubuntu:16.04
RUN apt-get update && apt-get install -y firefox
CMD /usr/bin/firefox
```

- Build and Run

```
$ docker build -t firefox-docker .

$ xhost local:root

$ docker run -it --rm \
       -e DISPLAY=$DISPLAY \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       firefox-docker
```
