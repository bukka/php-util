<?php
$cnf = dirname(__FILE__) . DIRECTORY_SEPARATOR . 'bug73711.cnf';
var_dump(openssl_pkey_new(["private_key_type" => OPENSSL_KEYTYPE_DSA, 'config' => $cnf]));
var_dump(openssl_pkey_new(["private_key_type" => OPENSSL_KEYTYPE_DH, 'config' => $cnf]));
echo "Success!";
