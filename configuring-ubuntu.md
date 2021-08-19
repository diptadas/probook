# Configuring Ubuntu

## Dual Boot: remove `memtest` from grub

```
$ sudo apt remove memtest86+
```

## Chrome

- https://www.google.com/chrome/
- Font setting for bangla

## VSCode

- https://code.visualstudio.com/

## VLC Player

```
$ sudo apt install vlc
```

## Net Speed Indicator

```
$ sudo add-apt-repository ppa:nilarimogard/webupd8
$ sudo apt update
$ sudo apt install indicator-multiload indicator-netspeed
```

- Update: use GNOME shell extension

## Terminator

```
$ sudo apt install terminator
```

## Fish shell

```
$ sudo apt-add-repository ppa:fish-shell/release-3
$ sudo apt update
$ sudo apt install fish
```

- Configure `fundle` (ref: AppsCode doc)


## Git

```
$ sudo apt install git git-gui xclip
$ ssh-keygen -t rsa -b 4096 -C "dipta670@gmail.com"
$ xclip -sel clip < ~/.ssh/id_rsa.pub
```

- Update: use `Fork`

## Go

```
$ sudo rm -rf /usr/local/go
$ wget https://dl.google.com/go/go1.X.linux-amd64.tar.gz  
$ sudo tar -C /usr/local -xzf go1.X.linux-amd64.tar.gz
$ sudo chown -R $USER:$USER /usr/local/go
$ rm go1.X.linux-amd64.tar.gz
```

```
$ mkdir $HOME/go
$ nano ~/.bashrc

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

$ source ~/.bashrc
```

```
$ go version
```

## Goland

- https://www.jetbrains.com/go/download/#section=linux

```
$ tar xzf goland-2017.3.3.tar.gz
$ sudo mv GoLand-2017.3.3/ /opt
```

- Update: Install using toolbox: https://www.jetbrains.com/toolbox/app/
- Configure > create desktop entry

## Docker CE

```
$ curl -fsSL https://get.docker.com | sh
$ sudo usermod -aG docker $USER (logout and login again)
```

## VirtualBox

- https://www.virtualbox.org/wiki/Linux_Downloads

## Minikube & kubectl

```
$ curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
```

```
$ curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v1.X.X/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/
```

## Fish kubectl

- https://github.com/evanlucas/fish-kubectl-completions


## HAProxy

```
$ sudo apt install python-software-properties
$ sudo add-apt-repository ppa:vbernat/haproxy-1.9
$ sudo apt update
$ sudo apt install haproxy

$ cat /etc/haproxy/haproxy.cfg
$ sudo service haproxy start | stop | restart
```

## 18.04/GNOME specific

- Click to minimize

```
$ gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
```

- Gnome-tweak-tool

```
$ sudo apt install gnome-tweak-tool
```

- Shell extensions
    - https://itsfoss.com/gnome-shell-extensions/
    - Chrome extension: https://chrome.google.com/webstore/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep
    - Connector: `$ sudo apt install chrome-gnome-shell`
    - https://extensions.gnome.org/extension/1160/dash-to-panel/
    - https://extensions.gnome.org/extension/104/netspeed/
    - https://extensions.gnome.org/extension/1262/bing-wallpaper-changer/
    - https://extensions.gnome.org/extension/19/user-themes/

- Themes
    - https://itsfoss.com/install-themes-ubuntu/
    - Arc-Ambiance theme: https://www.gnome-look.org/p/1193861/
