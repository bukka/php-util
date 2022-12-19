#!/bin/bash

function fpm_LaunchProcess()
{
    php-fpm -F -y fpm.conf 2>&1>/dev/null &
    echo "$!"
}

pid=$(fpm_LaunchProcess)
echo "$pid"
