<?php
$flags = STREAM_CLIENT_CONNECT;
$ctxArr = [
'cafile' => __DIR__ . '/sni_server_ca.pem',
'capture_peer_cert' => true
];

$ctxArr['peer_name'] = 'domain1.com';
$ctx = stream_context_create(['ssl' => $ctxArr]);
$client = stream_socket_client("tls://127.0.0.1:64321", $errno, $errstr, 1, $flags, $ctx);
$cert = stream_context_get_options($ctx)['ssl']['peer_certificate'];
var_dump(openssl_x509_parse($cert)['subject']['CN']);

$ctxArr['peer_name'] = 'domain2.com';
$ctx = stream_context_create(['ssl' => $ctxArr]);
$client = @stream_socket_client("tls://127.0.0.1:64321", $errno, $errstr, 1, $flags, $ctx);
$cert = stream_context_get_options($ctx)['ssl']['peer_certificate'];
var_dump(openssl_x509_parse($cert)['subject']['CN']);

$ctxArr['peer_name'] = 'domain3.com';
$ctx = stream_context_create(['ssl' => $ctxArr]);
$client = @stream_socket_client("tls://127.0.0.1:64321", $errno, $errstr, 1, $flags, $ctx);
$cert = stream_context_get_options($ctx)['ssl']['peer_certificate'];
var_dump(openssl_x509_parse($cert)['subject']['CN']);
