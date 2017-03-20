<?php
$context = stream_context_create(['ssl' => ['verify_peer' => false]]);
$fp = stream_socket_client("tls://php.net:443", $errornum, $errorstr, 300, STREAM_CLIENT_CONNECT, $context);
var_dump($fp);
var_dump($errornum);
var_dump($errorstr);

stream_set_blocking($fp, 0);

$str = "GET / HTTP/1.1\r\n";
$str .= str_repeat("a", 1048576);

$result = fwrite($fp, $str);
var_dump($result);
$result = fwrite($fp, $str);
var_dump($result);