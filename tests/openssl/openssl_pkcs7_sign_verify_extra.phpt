--TEST--
openssl_pkcs7_verify() tests
--SKIPIF--
<?php if (!extension_loaded("openssl")) print "skip"; ?>
--FILE--
<?php

$filePrefix = __DIR__ . DIRECTORY_SEPARATOR . '/openssl_pkcs7_sign_verify___test_';

$inFile = __DIR__ . "/cert.crt";
$cmsFile = $filePrefix . 'cms.pem';
$signersFile = $filePrefix . 'signers.pem';
$outFile = $filePrefix . 'out.txt';
$certFile = $filePrefix . 'cert.pem';

include 'CertificateGenerator.inc';
$certificateGenerator = new CertificateGenerator();
$certificateGenerator->saveNewCertAsFileWithKey('pkcs7_sign_verify', $certFile);


if (openssl_pkcs7_sign($inFile, $cmsFile, $certificateGenerator->getCaCert(), $certificateGenerator->getCaKey(), [$certFile], PKCS7_NOCERTS)) {
	var_dump(file_get_contents($cmsFile));
	var_dump(openssl_pkcs7_verify($cmsFile, PKCS7_NOVERIFY|PKCS7_NOINTERN|PKCS7_NOCHAIN, $signersFile, [$certFile], $certFile, $outFile));
	var_dump(file_get_contents($signersFile));
	var_dump(file_get_contents($outFile));
	while($msg=openssl_error_string()) echo "$msg\n"; 
}

?>
--CLEAN--
<?php
$filePrefix = __DIR__ . DIRECTORY_SEPARATOR . '/openssl_pkcs7_sign_verify___test_';

@unlink($filePrefix . 'cms.pem');
@unlink($filePrefix . 'signers.pem');
@unlink($filePrefix . 'out.pem');
@unlink($filePrefix . 'cert.pem');
?>
--EXPECTF--
