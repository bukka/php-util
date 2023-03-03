#!/bin/bash

cmd="sudo /usr/local/nginx/sbin/nginx -c `pwd`/nginx.conf"

echo $cmd
exec $cmd
