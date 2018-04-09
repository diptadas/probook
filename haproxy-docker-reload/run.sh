#!/bin/bash
set -eou pipefail

CONFIG_FILE="/etc/haproxy/haproxy.cfg"
PID_FILE="/var/run/haproxy.pid"
SOCK_FILE="/var/run/haproxy.sock"

function check {
	echo "check haproxy"
	haproxy -c -f $CONFIG_FILE
}

function stop {
	echo "stop haproxy"
	kill $(cat $PID_FILE) || true
}

function start {
	echo "start haproxy"
	haproxy -f $CONFIG_FILE
}

function hard-reload {
	echo "hard-reload haproxy"
	haproxy -f $CONFIG_FILE -st $(cat $PID_FILE)
}

function soft-reload {
	echo "soft-reload haproxy"
	haproxy -f $CONFIG_FILE -sf $(cat $PID_FILE)
}

function hitless-reload {
	echo "hitless-reload haproxy"
	haproxy -f $CONFIG_FILE -x $SOCK_FILE -sf $(cat $PID_FILE)
}

function start-or-reload {
	# check config before start/reload
	check

	if [ -s $PID_FILE ] && ( ps -p $(cat $PID_FILE) > /dev/null ); then
		echo "haproxy daemon running"
		hitless-reload
	else
		echo "haproxy daemon not running"
		start
	fi
}

trap stop EXIT

# start for the first time
start-or-reload

# reload when config changes
while inotifywait -e close_write $CONFIG_FILE; do
	echo "haproxy config changed"
	start-or-reload
done