#!/bin/bash

if [ -n "$1" ]; then
  log_type=$1
else
  log_type=buffered
fi


exec php-fpmi -F -y fpmi-log-$log_type.conf
