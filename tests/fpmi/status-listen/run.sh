#!/bin/bash

cmd="php-fpmi -F -c php.ini -y fpmi.conf"

echo $cmd
exec $cmd
