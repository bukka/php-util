#!/bin/bash

cmd="sudo apache2 -DFOREGROUND -f `pwd`/apache2-uds.conf"

echo $cmd
exec $cmd
