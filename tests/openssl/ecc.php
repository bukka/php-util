<?php
$args = array(
	"curve_name" => "secp384r1",
	"private_key_type" => OPENSSL_KEYTYPE_EC,
);
echo "Testing openssl_pkey_new\n";
$key1 = openssl_pkey_new($args);
var_dump($key1);

$d1 = openssl_pkey_get_details($key1);
var_dump($d1["bits"]);
var_dump(strlen($d1["key"]));
var_dump($d1["ec"]["curve_name"]);
var_dump($d1["type"] == OPENSSL_KEYTYPE_EC);

$dn = array(
	"countryName" => "BR",
	"stateOrProvinceName" => "Rio Grande do Sul",
	"localityName" => "Porto Alegre",
	"commonName" => "Henrique do N. Angelo",
	"emailAddress" => "hnangelo@php.net"
);

$args["digest_alg"] = "sha1";
echo "Testing openssl_csr_new with existing ecc key\n";
$csr = openssl_csr_new($dn, $key1, $args);
var_dump($csr);

$pubkey1 = openssl_pkey_get_details(openssl_csr_get_public_key($csr));
var_dump(isset($pubkey1["ec"]["priv_key"]));
unset($d1["ec"]["priv_key"]);
var_dump($d1["ec"], $pubkey1["ec"]);
var_dump(array_diff($d1["ec"], $pubkey1["ec"]));
