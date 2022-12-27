<?php
define('BUF_SIZE',64);

if ($argc!=3)
{
	fprintf(STDERR,"Usage: %s <count> <wait>\n",$argv[0]);
	return 1;
}

$descriptorspec=array(
	0 => STDIN,
	1 => array("pipe", "w"),
	2 => STDERR
);
$argv[0]= __DIR__ . "/closewait";
$p = proc_open($argv, $descriptorspec, $fd);

// fread($fd[1],BUF_SIZE);
// fread($fd[1],BUF_SIZE);
// fread($fd[1],BUF_SIZE);

while (strlen($s=fread($fd[1],BUF_SIZE))==BUF_SIZE) fprintf(STDERR,"n: %d ",strlen($s));
fprintf(STDERR,"n: %d EOF: %d\n",strlen($s),feof($fd[1]));