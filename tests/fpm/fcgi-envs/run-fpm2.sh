#!/bin/bash

cmd="php-fpm -F -y fpm2.conf"

echo $cmd
exec $cmd
