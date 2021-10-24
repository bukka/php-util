#!/bin/bash

cmd="sudo nginx -c `pwd`/nginx.conf"

echo $cmd
exec $cmd
