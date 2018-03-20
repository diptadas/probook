#!/bin/bash
set -eou pipefail

# define pidfile & stats socket in global config
# benchmark-test: ab -r -c 200 -n 10000 http://127.0.0.1:9080/

function check {
	echo "check haproxy"
	sudo haproxy -c -f haproxy.cfg
}

function stop {
	echo "stop haproxy"
	sudo kill $(cat /var/run/haproxy.pid) || true
}

function start {
	echo "start haproxy"
	sudo haproxy -f haproxy.cfg
}

function hard-reload {
	echo "hard-reload haproxy"
	sudo haproxy -f haproxy.cfg -sft$(cat /var/run/haproxy.pid)
}

function soft-reload {
	echo "soft-reload haproxy"
	sudo haproxy -f haproxy.cfg -sf $(cat /var/run/haproxy.pid)
}

function hitless-reload {
	echo "hitless-reload haproxy"
	sudo haproxy -f haproxy.cfg -x /var/run/haproxy.sock -sf $(cat /var/run/haproxy.pid)
}

trap stop EXIT

stop
check
start

while true; do
	hitless-reload
	# soft-reload
	# hard-reload
  	sleep 0.2
done