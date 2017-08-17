### Set environment variables in bash

```
$ nano ~/.bashrc

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

$ source ~/.bashrc
```

### List of processes listening a specific port and kill them

```
$ fuser -k 8088/tcp
```

### Create user non-interactively

```
$ useradd -p $(echo "password" | openssl passwd -1 -stdin) "username"
```