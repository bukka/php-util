<?php

file_put_contents('test.data', 'hello');
$r1 = fopen('test.data', 'r');
$r2 = fopen('test.data', 'r');
$read = [$r1, $r2];
$write = null;
$except = null;

stream_select($read, $write, $rexcept, 0);
var_dump($read);

var_dump(fread($r1, 1));

stream_select($read, $write, $rexcept, 0);
var_dump($read);


