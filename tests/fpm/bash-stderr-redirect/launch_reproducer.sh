#!/bin/bash

function launchProcess()
{
    ./reproducer 2>&1> /dev/null &
    echo "$!"
}

pid=$(launchProcess)
echo "$pid"