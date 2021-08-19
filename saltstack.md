# Saltstack

## Links:

- https://docs.saltstack.com/en/getstarted/
- https://docs.saltstack.com/en/latest/topics/tutorials/states_pt1.html
- https://oliverveits.wordpress.com/2015/12/04/it-automation-part-iii-saltstack-hello-world-example/
- http://eon01.com/blog/salt-stack-tutorial-for-beginners/


## Set up the Salt-Master machine:

```
$ sudo apt-get install -y python-software-properties
$ sudo add-apt-repository -y ppa:saltstack/salt
$ sudo apt-get update
$ sudo apt-get install -y salt-master salt-api

$ systemctl status salt-master
$ salt --version
$ salt-api --version
```

## Set up the Salt-Minion machine:

```
$ sudo apt-get install -y python-software-properties
$ sudo add-apt-repository -y ppa:saltstack/salt
$ sudo apt-get update
$ sudo apt-get install -y salt-minion

$ systemctl status salt-minion
$ salt-minion --version
```

Note: We can install salt-minion in master machine to configure itself.

## Register Salt Minion:

```
Minion $ sudo nano /etc/salt/minion
master: <public-ip for salt-master> (uncomment)

Minion $ sudo systemctl restart salt-minion
```

## Accept keys:
	
- List of keys:

```
Master $ sudo salt-key -L
```

- Accept all pending keys:

```
Master $ sudo salt-key -A
```

## Ping all minions:

```
Master $ sudo salt '*' test.ping
```

## Targeting:

```
Master $ sudo salt '*' test.ping (all)
Master $ sudo salt 'minion_1' test.ping (name minion_1)
Master $ sudo salt 'minion*' test.ping (name started with minion)
Master $ sudo salt -L 'minion_1,minion_2' test.ping (list)
Master $ sudo salt -E 'minion_[0-9]' test.ping (regular expression)
Master $ sudo salt -G 'os:Ubuntu' test.ping (grains)
Master $ sudo salt C 'G@os:Ubuntu and minion* or S@192.168.50.*' test.ping (combined)
```

## Node Groups:

```
Master $ nano /etc/salt/master

nodegroups:
  group1: 'L@foo.domain.com,bar.domain.com or bl*.domain.com'
  group2: 'G@os:Debian and foo.domain.com'
  group3: 'G@os:Debian and N@group1'
  group4:
    - 'G@foo:bar'
    - 'or'
    - 'G@foo:baz'

Master $ sudo salt -N group1 test.ping
```

## State File:

```
Master $ sudo mkdir -p /srv/salt
Master $ nano /srv/salt/hello.sls

# This state file will write "Hello World!" to the file hello_world
run_echo_hello_world:
  cmd.run:
    - name: echo Hello World > hello_world
    - user: root

Master $ sudo salt '*' state.apply hello

Minion $ cat hello_world
```
