<?php
$flags = STREAM_SERVER_BIND|STREAM_SERVER_LISTEN;
$ctx = stream_context_create(
	[
		'ssl' => [
			'local_cert' => __DIR__ . '/streams_crypto_method.pem',
		]
	]
);

$server = stream_socket_server('tlsv1.2://127.0.0.1:64321', $errno, $errstr, $flags, $ctx);

for ($i=0; $i < 3; $i++) {
	@stream_socket_accept($server, 3);
}