<?php
$ann = fann_create_from_file(__DIR__ . "/01-00-00.net");
var_dump($ann);
var_dump(fann_get_connection_array($ann));
