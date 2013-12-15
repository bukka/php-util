<?php

function foo() {
	throw new Exception();
}

try {
	$cipher = new Crypto\Cipher('aes-128-ecb');
	$cipher->encryptInit('0123456789abcdef');
	$cipher->encryptUpdate('test') . foo();
}
catch (Exception $e) {}

