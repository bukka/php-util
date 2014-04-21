<?php
$r = json_decode('{ "\uDC33 key starting with zero": "value" }');
var_dump($r);
if ($r === NULL)
	var_dump(jsond_last_error_msg());

$r = json_decode('{ "\u0001 key starting with zero": "value" }');
var_dump($r);
if ($r === NULL)
	var_dump(json_last_error_msg());