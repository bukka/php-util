<?php

$fp = fopen('http://localhost:8084/slow.php', 'r');
var_dump(fread($fp, 1024));
fclose($fp);
file_get_contents('http://localhost:8084/noop.php');

