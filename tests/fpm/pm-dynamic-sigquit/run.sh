#!/bin/bash

cmd="php-fpm -F -c php.ini -y fpm.conf"

echo $cmd
exec $cmd
