<?php

$config = __DIR__ . DIRECTORY_SEPARATOR . 'openssl.cnf';
$phex = 'dcf93a0b883972ec0e19989ac5a2ce310e1d37717e8d9571bb7623731866e61e' .
		'f75a2e27898b057f9891c2e27a639c3f29b60814581cd3b2ca3986d268370557' .
		'7d45c2e7e52dc81c7a171876e5cea74b1448bfdfaf18828efd2519f14e45e382' .
		'6634af1949e5b535cc829a483b8a76223e5d490a257f05bdff16f2fb22c583ab';
$dh_details = array('p' => $phex, 'g' => '2');
$dh = openssl_pkey_new(array(
	'dh'=> array('p' => hex2bin($phex), 'g' => '2'))
);

$dn = array(
	"countryName" => "BR",
	"stateOrProvinceName" => "Rio Grande do Sul",
	"localityName" => "Porto Alegre",
	"commonName" => "Henrique do N. Angelo",
	"emailAddress" => "hnangelo@php.net"
);

$args = array(
	"digest_alg" => "sha1",
	"private_key_bits" => 2048,
	"private_key_type" => OPENSSL_KEYTYPE_DSA,
	"encrypt_key" => true,
	"config" => $config,
);

$privkey_file = 'file://' . dirname(__FILE__) . '/private_rsa_2048.key';

for ($i = 0; $i < 100000; $i++) { 
  $csr = openssl_csr_new($dn, $privkey_file, $args);
  openssl_csr_get_subject($csr);
  unset($csr);
  if ($i % 1000 === 0) {
	  print memory_get_usage() . "\n";
  }
}
