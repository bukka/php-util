<?php

$server = stream_socket_server('127.0.0.1:8087');

$read = [$server];
$write = $except = null;


stream_select($read, $write, $except, 10);
sleep(10);
echo "ready to accept\n";
$conn = stream_socket_accept($server);

var_dump($conn);