<?php
$public_key = openssl_pkey_get_public(file_get_contents(__DIR__ . '/sm2pubkey30.pem'));
$d1 = openssl_pkey_get_details($public_key);
var_dump($d1);
