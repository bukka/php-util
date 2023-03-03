<?php
$raw_pubkey = file_get_contents(__DIR__ . '/sm2pubkey30.pem');
var_dump($raw_pubkey);
$public_key = openssl_pkey_get_public($raw_pubkey);
$d1 = openssl_pkey_get_details($public_key);
var_dump($d1);
