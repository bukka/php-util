#!/bin/bash

cat /dev/urandom | od -An -vtx1 | head -c 40960 > input.txt