<?php

$context = stream_context_create(['ssl' => ['verify_peer' => false, 'peer_name' => 'bug54992.local']]);
$fp = stream_socket_client("ssl://127.0.0.1:10011", $errornum, $errorstr, 3000, STREAM_CLIENT_CONNECT, $context);
stream_set_blocking($fp, 0);

function blocking_fwrite($fp, $buf) {
	$write = [$fp];
	$total = 0;
	while (stream_select($read, $write, $except, 180)) {
		$result = fwrite($fp, $buf);
		$total += $result;
		echo "$result : $total\n";
		if ($total >= strlen($buf)) {
			return $total;
		}
		$buf = substr($buf, $total);
	}
}

$str1 = str_repeat("a", 2500000);
$str2 = str_repeat("b", 2500000);

var_dump(blocking_fwrite($fp, $str1) + blocking_fwrite($fp, $str2) + blocking_fwrite($fp, 'b'));
