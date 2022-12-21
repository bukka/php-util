#!/bin/bash

function fpm_LaunchProcess()
{
    echo `/usr/local/sbin/php-fpm -y fpm_workaround.conf 2>&1`
}

pid=$(fpm_LaunchProcess)
echo "$pid"