<?php

$publicKey = "file://" . dirname(__FILE__) . "/public.key";
$privateKey = "file://" . dirname(__FILE__) . "/private_rsa_1024.key";

function test($envkey) {
  global $publicKey, $privateKey;
  openssl_public_encrypt($envkey, $envelope, $publicKey);
  $sealed = openssl_encrypt('plaintext', 'rc4', $envkey, OPENSSL_RAW_DATA);
  var_dump(strlen($sealed));
  openssl_open($sealed, $output, $envelope, $privateKey, 'rc4');
  var_dump($output);
  var_dump($output === 'plaintext');
}


// works - key of 16 bytes
test('1234567890123456i');
// fails - key of 15 bytes
test('123456789012345');


