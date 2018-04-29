<?php
$flags = STREAM_CLIENT_CONNECT;
$ctx = stream_context_create(
	[
		'ssl' => [
			'verify_peer' => false,
			'verify_peer_name' => false,
		]
	]
);

$client = stream_socket_client("tlsv1.2://127.0.0.1:64321", $errno, $errstr, 3, $flags, $ctx);
var_dump($client);

$client = @stream_socket_client("sslv3://127.0.0.1:64321", $errno, $errstr, 3, $flags, $ctx);
var_dump($client);

$client = @stream_socket_client("tlsv1.1://127.0.0.1:64321", $errno, $errstr, 3, $flags, $ctx);
var_dump($client);