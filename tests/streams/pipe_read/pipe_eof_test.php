<?php
$descriptorspec=array(
	0 => STDIN,
	1 => array("pipe", "w"),
	2 => STDERR
);
//$p = proc_open(['echo', '-n', '01234567890123456789'], $descriptorspec, $fd);
$p = proc_open(['./write_twice.sh'], $descriptorspec, $fd);

$res = '';
$size = $argv[1];
while (strlen($s = fread($fd[1], $size)) == $size) {
	$res .= $s;
}
$res .= $s;
fprintf(STDERR, "Result: %s, EOF: %d\n", $res, feof($fd[1]));

sleep(3);
while (strlen($s = fread($fd[1], $size)) == $size) {
	$res .= $s;
}
$res .= $s;

fprintf(STDERR, "Result: %s, EOF: %d\n", $res, feof($fd[1]));
