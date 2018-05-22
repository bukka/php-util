<?php

$dir = __DIR__ . '/bug76296_openbasedir';
$pem = 'file://' . __DIR__ . '/public.key';
if (!is_dir($dir)) {
	mkdir($dir);
}

ini_set('open_basedir', $dir);

var_dump($pkey = openssl_pkey_get_public($pem));

rmdir($dir);