#!/bin/bash

cmd="php-fpm -F -y fpm.conf"

echo $cmd
exec $cmd
