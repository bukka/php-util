<?php

$socket_path = '/tmp/test.socket';

if (file_exists($socket_path)) {
    unlink($socket_path);
}

$socket = stream_socket_server('unix://' . $socket_path);
var_dump('is connected? ' . (!feof($socket) ? 'true' : 'false'));