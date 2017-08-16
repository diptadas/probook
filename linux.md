### Set environment variables in bash

```
$ nano ~/.bashrc

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

$ source ~/.bashrc
```