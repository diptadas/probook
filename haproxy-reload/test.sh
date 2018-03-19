#!/bin/bash
set -eou pipefail

sed -i -e 's/9080/9090/g' config/haproxy.cfg
sleep 1

xterm -hold -title "test-1" -e "curl 127.0.0.1:9090/1"

sed -i -e 's/9090/9080/g' config/haproxy.cfg
sleep 1

xterm -hold -title "test-2" -e "curl 127.0.0.1:9090/2"
xterm -hold -title "test-3" -e "curl 127.0.0.1:9080/3"
