<?php

$pid = getmypid();
exec("lsof -p $pid | grep pipe", $output);
var_dump($output);
$fd = preg_split('/\s+/', $output[count($output) - 1])[7];

file_put_contents('php://stderr', str_repeat('a', 2048) . "\n");
// the below doesn't work as it tries to reopen the pipe -
// we just need to close the existing fd which I'm not sure how atm.
//$fh = fopen("php://fd/$fd", "w");
//fclose($fh);