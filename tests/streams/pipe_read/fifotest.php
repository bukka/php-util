<?php
define('BUF_SIZE',64);

if ($argc!=2)
{
	fprintf(STDERR,"Usage: %s <fifo>\n",$argv[0]);
	return 1;
}

$fp=fopen($argv[1],"r");
if (!$fp)
{
	return 0;
}

while (strlen($s=fread($fp,BUF_SIZE))==BUF_SIZE) fprintf(STDERR,"n: %d ",strlen($s));
fprintf(STDERR,"n: %d EOF: %d\n",strlen($s),feof($fp));