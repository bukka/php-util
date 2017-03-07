<?php

$context = stream_context_create(['ssl' => ['verify_peer' => false, 'peer_name' => 'bug54992.local']]);
$fp = stream_socket_client("ssl://127.0.0.1:10011", $errornum, $errorstr, 3000, STREAM_CLIENT_CONNECT, $context);
//stream_set_blocking($fp, 0);

$str1 = random_bytes(2500000);
$str2 = random_bytes(2500000);
fwrite($fp, $str1);
fwrite($fp, $str2);
fwrite($fp, 'c');

echo "done: " . sha1($str1 . $str2 . 'c');
