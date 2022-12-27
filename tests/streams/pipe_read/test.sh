#!/bin/bash

time -p (
[ -p fifo ] || mkfifo fifo
( [ -e closewait ] && [ closewait -nt closewait.c ] ) || gcc closewait.c -o closewait
( [ -e fifotest ] && [ fifotest -nt fifotest.c ] ) || gcc fifotest.c -o fifotest
( [ -e pipetest ] && [ pipetest -nt pipetest.c ] ) || gcc pipetest.c -o pipetest
( [ -e pipereadtest ] && [ pipereadtest -nt pipereadtest.c ] ) || gcc pipereadtest.c -o pipereadtest

echo '===>FIFO test (C)'
./closewait 63 1 > fifo & ./fifotest fifo
./closewait 64 1 > fifo & ./fifotest fifo
./closewait 65 1 > fifo & ./fifotest fifo

echo '===>FIFO test (PHP)'
./closewait 63 1 > fifo & php ./fifotest.php fifo
./closewait 64 1 > fifo & php ./fifotest.php fifo
./closewait 65 1 > fifo & php ./fifotest.php fifo

echo '===>pipe test (File C)'
./pipetest 63 1
./pipetest 64 1
./pipetest 65 1

echo '===>pipe test (Desc C)'
./pipereadtest 63 1
./pipereadtest 64 1
./pipereadtest 65 1

echo '===>pipe test (PHP)'
php ./pipetest.php 63 1
php ./pipetest.php 64 1
php ./pipetest.php 65 1
)
