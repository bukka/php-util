--TEST--
openssl_error_string() tests
--SKIPIF--
<?php if (!extension_loaded("openssl")) print "skip"; ?>
--FILE--
<?php
// helper function to dump openssl errors
function dump_openssl_errors() {
	while (($error_string = openssl_error_string()) !== false) {
		var_dump($error_string);
	}
}

// common output file
$output_file =  __DIR__ . "/openssl_error_string_basic_output.tmp";
// invalid file for read is something that does not exist in current directory
$invalid_file_for_read = __DIR__ . "/invalid_file_for_read_operation.txt";
// invalid file for is the test dir as writting file to existing dir should alway fail
$invalid_file_for_write = __DIR__;
// crt file
$crt_file = "file://" . __DIR__ . "/cert.crt";
// csr file
$csr_file = "file://" . __DIR__ . "/cert.csr";
// private key file
$private_key_file = "file://" .__DIR__ . "/private_rsa_1024.key";

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

// PKEY
echo "PKEY errors\n";
// file for pkey (file:///) fails when opennig (BIO_new_file)
openssl_pkey_export_to_file("file://" . $invalid_file_for_read, $output_file);
dump_openssl_errors();
// file or private pkey is not correct PEM - failing PEM_read_bio_PrivateKey
openssl_pkey_export_to_file($csr_file, $output_file);
dump_openssl_errors();
// file to export cannot be written
openssl_pkey_export_to_file($private_key_file, $invalid_file_for_write);
dump_openssl_errors();

// X509
echo "X509 errors\n";
// file for x509 (file:///) fails when opennig (BIO_new_file)
openssl_x509_export_to_file("file://" . $invalid_file_for_read, $output_file);
dump_openssl_errors();
// file or str cert is not correct PEM - failing PEM_read_bio_X509 or PEM_ASN1_read_bio
openssl_x509_export_to_file($csr_file, $output_file);
dump_openssl_errors();
// file to export cannot be written
openssl_x509_export_to_file($crt_file, $invalid_file_for_write);
dump_openssl_errors();

// other possible cuases that are difficult to catch:
// - ASN1_STRING_to_UTF8 fails in add_assoc_name_entry
// - invalid php_x509_request field (NULL) would cause error with CONF_get_string

?>
--CLEAN--
<?php
$output_file =  __DIR__ . "/openssl_error_string_basic_output.tmp";
if (is_file($output_file)) {
	unlink($output_file);
}
?>
--EXPECTF--
string(89) "error:0607A082:digital envelope routines:EVP_CIPHER_CTX_set_key_length:invalid key length"
bool(false)
int(15)
PKEY errors

Warning: openssl_pkey_export_to_file(): cannot get key from parameter 1 in %s on line %d
string(61) "error:02001002:system library:fopen:No such file or directory"
string(53) "error:2006D080:BIO routines:BIO_new_file:no such file"

Warning: openssl_pkey_export_to_file(): cannot get key from parameter 1 in %s on line %d
string(54) "error:0906D06C:PEM routines:PEM_read_bio:no start line"
string(68) "error:0E06D06C:configuration file routines:NCONF_get_string:no value"
string(68) "error:0E06D06C:configuration file routines:NCONF_get_string:no value"
string(68) "error:0E06D06C:configuration file routines:NCONF_get_string:no value"
string(68) "error:0E06D06C:configuration file routines:NCONF_get_string:no value"
string(68) "error:0E06D06C:configuration file routines:NCONF_get_string:no value"
string(68) "error:0E06D06C:configuration file routines:NCONF_get_string:no value"
string(50) "error:02001015:system library:fopen:Is a directory"
string(51) "error:2006D002:BIO routines:BIO_new_file:system lib"
X509 errors

Warning: openssl_x509_export_to_file(): cannot get cert from parameter 1 in %s on line %d
string(61) "error:02001002:system library:fopen:No such file or directory"
string(53) "error:2006D080:BIO routines:BIO_new_file:no such file"

Warning: openssl_x509_export_to_file(): cannot get cert from parameter 1 in %s on line %d
string(54) "error:0906D06C:PEM routines:PEM_read_bio:no start line"

Warning: openssl_x509_export_to_file(): error opening file %s in %s on line %d
string(50) "error:02001015:system library:fopen:Is a directory"
string(51) "error:2006D002:BIO routines:BIO_new_file:system lib"