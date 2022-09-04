<?php

$port = isset($argv[1]) && $argv[1] === 'nginx' ? 8083 : 8084;

$fp = fopen("http://localhost:$port/slow.php", 'r');
var_dump(fread($fp, 1024));
fclose($fp);
file_get_contents("http://localhost:$port/slow.php");

