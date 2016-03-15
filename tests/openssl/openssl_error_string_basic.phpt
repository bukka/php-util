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

// openssl_x509_export_to_file
// - file for x509 (file:///) fails when opennig (BIO_new_file)
// - file or str cert is not correct PEM - failing PEM_read_bio_X509 or PEM_ASN1_read_bio
// - file to export cannot be written


// other possible cuases that are difficult to catch:
// - ASN1_STRING_to_UTF8 fails in add_assoc_name_entry
// - invalid php_x509_request field (NULL) would cause error with CONF_get_string

?>
--EXPECTF--
string(89) "error:0607A082:digital envelope routines:EVP_CIPHER_CTX_set_key_length:invalid key length"
bool(false)
int(15)