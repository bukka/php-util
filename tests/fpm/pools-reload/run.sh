#!/bin/bash

cmd="php-fpm -F -y fpm.conf"

rm -rf /tmp/fpm-uds 
mkdir /tmp/fpm-uds
ulimit -n 2000

echo $cmd
exec $cmd
