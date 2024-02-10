<?php


$connection = stream_socket_client("tcp://127.0.0.1:8087", $errno, $errstr, 60, STREAM_CLIENT_CONNECT);

var_dump($connection, $errno, $errstr);