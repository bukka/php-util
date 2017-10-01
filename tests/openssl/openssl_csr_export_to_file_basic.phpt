--TEST--
openssl_csr_export_to_file() tests
--SKIPIF--
<?php if (!extension_loaded("openssl")) print "skip"; ?>
--FILE--
<?php
$csrfile = dirname(__FILE__) . "/openssl_csr_export_to_file_csr.tmp";
$wrong = "wrong";
$config = __DIR__ . DIRECTORY_SEPARATOR . 'openssl.cnf';
$config_arg = array('config' => $config);
$dn = array(
	"countryName" => "BR",
	"stateOrProvinceName" => "Rio Grande do Sul",
	"localityName" => "Porto Alegre",
	"commonName" => "Henrique do N. Angelo",
	"emailAddress" => "hnangelo@php.net"
);
$args = array(
	"digest_alg" => "sha1",
	"private_key_bits" => 2048,
	"private_key_type" => OPENSSL_KEYTYPE_DSA,
	"encrypt_key" => true,
	"config" => $config,
);
$privkey = openssl_pkey_new($config_arg);
$privkey = 'file://' . __DIR__ . '/private_rsa_2048.key';

$csr = openssl_csr_new($dn, $privkey, $args);
var_dump(openssl_csr_export_to_file($csr, $csrfile));
echo file_get_contents('openssl_csr_export_to_file_csr.tmp');
var_dump(openssl_csr_export_to_file($wrong, $csrfile));
var_dump(openssl_csr_export_to_file($privkey, $csrfile));
var_dump(openssl_csr_export_to_file(array(), $csrfile));
var_dump(openssl_csr_export_to_file($csr, $csrfile, false));
?>
--CLEAN--
<?php
if (file_exists($csrfile)) {
	unlink($csrfile);
}
?>
--EXPECTF--
bool(true)

Warning: openssl_csr_export_to_file() expects parameter 1 to be resource, string given in %s on line %d
NULL

Warning: openssl_csr_export_to_file(): supplied resource is not a valid OpenSSL X.509 CSR resource in %s on line %d

Warning: openssl_csr_export_to_file(): cannot get CSR from parameter 1 in %s on line %d
bool(false)

Warning: openssl_csr_export_to_file() expects parameter 1 to be resource, array given in %s on line %d
NULL
bool(true)
