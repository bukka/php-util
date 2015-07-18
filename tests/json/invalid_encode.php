<?php
$key = "Foo " . chr(163);

$array = array($key => "");

var_dump($array);

$json = json_encode($array, JSON_PARTIAL_OUTPUT_ON_ERROR);

var_dump($json);
var_dump(json_last_error_msg());

var_dump(json_decode($json));
var_dump(json_last_error_msg());