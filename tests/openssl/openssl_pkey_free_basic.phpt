--TEST--
openssl_pkey_free()
--SKIPIF--
<?php
if (!extension_loaded("openssl")) die("skip");
?>
--FILE--
<?php
$key = openssl_pkey_get_private('file://' . dirname(__FILE__) . '/private_rsa_1024.key');
print_r(openssl_pkey_get_details($key));
openssl_pkey_free($key);
print_r(openssl_pkey_get_details($key));

