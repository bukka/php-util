<?php
$args = array(
	"curve_name" => "secp384r1",
	"private_key_type" => OPENSSL_KEYTYPE_EC,
);
echo "Testing openssl_pkey_new\n";
$key1 = openssl_pkey_new($args);

$d1 = openssl_pkey_get_details($key1);
var_dump($d1["bits"]);
var_dump(strlen($d1["key"]));
var_dump($d1["ec"]["curve_name"]);
var_dump($d1["type"] == OPENSSL_KEYTYPE_EC);

$key2 = openssl_pkey_new($d1);


