#!/bin/bash

fpmi_pid=`ps -aux | grep fpmi | awk '{ if (index($0, "php")) print $2 }'`

if [ -n "$fpmi_pid" ]; then
  kill $fpmi_pid
fi
