<?php
use Crypto\Cipher;
use Crypto\Rand;

$tag_length = 16;
$key_length = 128;
$key = str_repeat('a', 16);
$iv = Rand::generate(16);
$aad = 'test'; 

$cipher = Cipher::aes(Cipher::MODE_GCM, $key_length);
$cipher->setAAD($aad);
$cipher->setTagLength($tag_length);
$ciphertext = $cipher->encrypt(null, $key, $iv);
$tag = $cipher->getTag();

var_dump($ciphertext);

$tag = null;
$ciphertext = openssl_encrypt("", 'aes-128-gcm', $key, OPENSSL_RAW_DATA | OPENSSL_ZERO_PADDING, $iv, $tag, $aad, $tag_length);
var_dump($ciphertext);
