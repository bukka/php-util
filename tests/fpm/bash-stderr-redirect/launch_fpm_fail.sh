#!/bin/bash

function fpm_LaunchProcess()
{
    php-fpm -y fpm.conf --nodaemonize 2>&1> /dev/null &
    echo "$!"
}

pid=$(fpm_LaunchProcess)
echo "$pid"