#!/bin/bash

cmd="php-fpm -F -y fpm-uds.conf"

echo $cmd
exec $cmd
