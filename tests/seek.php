<?php

$file_path = "/tmp/bigfile.img";
if (!is_file($file_path) && system("dd if=/dev/zero of=$file_path bs=1000 count=0 seek=$[1000*1000*5]") === false) {
	die("File could not be created");
}

$giga = 1 << 31;

$handle = fopen($file_path, "r");

fseek($handle, $giga);
fseek($handle, $giga, SEEK_CUR);

var_dump(ftell($handle));

unlink($file_path);
