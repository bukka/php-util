<?php

function jde($str) {
	var_dump(json_decode($str));
	echo json_last_error_msg() . "\n";
}

jde('{ [ ]');
jde('{ "aha" "bb"}');
jde('dd');
jde('{ s');
jde('["str');
jde('"ss');
jde('["\t"]');
jde('');
jde('');
jde('');
