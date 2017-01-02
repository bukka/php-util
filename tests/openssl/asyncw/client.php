<?php

$context = stream_context_create(['ssl' => ['verify_peer' => false, 'peer_name' => 'bug54992.local']]);
$fp = stream_socket_client("ssl://127.0.0.1:10011", $errornum, $errorstr, 3000, STREAM_CLIENT_CONNECT, $context);
stream_set_blocking($fp, 0);

$str = str_repeat("a", 2500000);
$total = 0;

$read = $except = null;
$write = [$fp];
while (stream_select($read, $write, $except, 10)) {
	// we could write the same string again
	$result = fwrite($fp, $str);
	if ($result) {
		$total += $result;
		var_dump($result . ' : ' . $total);
	}
}

// this is going to fail
fwrite($fp, 'aa');
