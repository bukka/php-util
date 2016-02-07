--TEST--
Bug #69004 	openssl_pkcs12_export_to_file segfault
--SKIPIF--
<?php
if (!extension_loaded("openssl")) die("skip openssl not loaded");
?>
--FILE--
<?php
class PrivateKey {

	public $data;

	public function __construct($data) {
		$this->data = $data;
	}

	public function __toString() {
		openssl_pkey_export($this->data, $output);
		return $output;
	}

}

$csr = openssl_csr_new([], $privateKey);
$certificate = openssl_csr_sign($csr, NULL, $privateKey, 1);

$privateKey = new PrivateKey($privateKey);
openssl_pkcs12_export_to_file($certificate, '/tmp/test.p12', $privateKey, '');
?>
--EXPECTF--
