#!/bin/bash

echo "Starting runit"
exec /sbin/runsvdir -P /etc/service
