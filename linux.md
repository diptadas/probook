# Linux

## apt update

```
$ sudo bash -cx "apt -y update; apt -y dist-upgrade; apt -y autoremove; apt -y autoclean"

```

## (ctrl + alt + T) opens root terminal instead of Terminator:

``` 
$ gsettings set org.gnome.desktop.default-applications.terminal exec 'terminator'
```

## List of processes listening a specific port and kill them:

```	
$ fuser -k 8088/tcp
```

## Set environment variable in bash:

```
$ nano ~/.bashrc

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

$ source ~/.bashrc
```

## Set environment variable in fish:

```
$ nano ~/.bashrc

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

$ source ~/.bashrc
```

## Create user non-interactively

```
$ useradd -p $(echo "password" | openssl passwd -1 -stdin) username
```

## Logging bash script

- script.sh

```
#! /bin/bash
########### Appends stdout and stderr to filename.log ##########
exec > >(tee -a ${0##*/}.log)
exec 2>&1                  
echo ===  $(date --rfc-3339='seconds') ${0##*/} ===
set -x
###############################################################
pwd
echo hello world
```

- script.sh.log

```
=== 2017-08-11 01:49:50+06:00 script.sh ===
+ pwd
/home/dipta/all
+ echo hello world
hello world
```

## Insert text into a file

```
cat >> some-text-file.txt << EOF
text
more text
and another line
EOF
```

## Check process

```
#!/bin/bash
set -eou pipefail

PID_FILE="mayprocess.pid"

if [ -s $PID_FILE ] && ( ps -p $(cat $PID_FILE) > /dev/null ); then
    echo "running"
else
    echo "not running"
fi
```

- For alpine: 

```
$ apk --no-cache add procps
```

## OpenSSL TLS cert/key

```
$ openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /tmp/tls.key -out /tmp/tls.crt -subj "/CN=voyager.appscode.test"

$ cat /tmp/tls.crt /tmp/tls.key > /tmp/cert.pem

```

## curl resolve DNS

```
$ curl --resolve voyager.appscode.test:8090:127.0.0.1 voyager.appscode.test:8090
```

## bash echo with color

```
#!/bin/bash
set -eou pipefail

cecho() {
   tput setaf 14; echo $@; tput sgr 0
}

cecho "hello world"
cecho hello world
cecho
```

## ssh port forwarding

```
ssh -L 8760:127.0.0.1:8760 das@fire.ecs.baylor.edu
ssh -L 8760:127.0.0.1:8080 das@acmsac.ecs.baylor.edu
```
