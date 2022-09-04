<?php
ini_set('open_basedir', __DIR__ . '/bs');
$flags = STREAM_SERVER_BIND|STREAM_SERVER_LISTEN;
$ctx = stream_context_create(['ssl' => [
    //'local_cert' => __DIR__ . '/domain1.pem',
    'SNI_server_certs' => [
        "domain1.com" => __DIR__ . "/sni_server_domain1.pem",
        "domain2.com" => __DIR__ . "/sni_server_domain2.pem",
        "domain3.com" => __DIR__ . "/sni_server_domain3.pem"
    ]
]]);

$server = stream_socket_server('tls://127.0.0.1:64321', $errno, $errstr, $flags, $ctx);

for ($i=0; $i < 3; $i++) {
   stream_socket_accept($server, 300000);
}
