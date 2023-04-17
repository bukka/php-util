#!/bin/bash

for (( i=1; i<=100; i++ ))
do
    sleep 0.01
    kill `ps aux | grep 'fpm: pool unconfined' | grep -v 'grep' | awk '{ print $2 }'`
done