<?php

$context = stream_context_create(['ssl' => ['local_cert' => __DIR__ . '/cert.pem']]);

$flags = STREAM_SERVER_BIND|STREAM_SERVER_LISTEN;
$fp = stream_socket_server("ssl://127.0.0.1:10011", $errornum, $errorstr, $flags, $context);
$conn = stream_socket_accept($fp);

$total = 0;
while (true) {
	$data = fread($conn, 100000);
	$total += strlen($data);
	echo "\r$total";
	usleep(200000);
}