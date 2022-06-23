#!/bin/bash

cmd="sudo apache2 -DFOREGROUND -f `pwd`/apache2.conf"

echo $cmd
exec $cmd
