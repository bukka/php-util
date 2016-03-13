--TEST--
openssl_error_string() tests
--SKIPIF--
<?php if (!extension_loaded("openssl")) print "skip"; ?>
--FILE--
<?php
// ENCRYPTION
$data = "test";
$method = "AES-128-ECB";
$enc_key = str_repeat('x', 40);
// error because password is longer then key length and
// EVP_CIPHER_CTX_set_key_length fails for AES
openssl_encrypt($data, $method, $enc_key);
$enc_error = openssl_error_string();
var_dump($enc_error);
// make sure that error is cleared now
var_dump(openssl_error_string());
// internally OpenSSL ERR won't save more than 15 (16 - 1) errors so lets test it
for ($i = 0; $i < 20; $i++) {
	openssl_encrypt($data, $method, $enc_key);
}
$error_queue_size = 0;
while (($enc_error_new = openssl_error_string()) !== false) {
	if ($enc_error_new !== $enc_error) {
		echo "The new encoding error doesn't match the expected one\n";
	}
	++$error_queue_size;
}
var_dump($error_queue_size);
?>
--EXPECTF--
string(89) "error:0607A082:digital envelope routines:EVP_CIPHER_CTX_set_key_length:invalid key length"
bool(false)
int(15)