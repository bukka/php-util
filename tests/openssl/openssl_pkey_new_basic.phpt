--TEST--
openssl_pkey_new() basic usage tests
--SKIPIF--
<?php if (!extension_loaded("openssl")) print "skip"; ?>
--FILE--
<?php
// RSA

// DSA
$phex = '00f8000ae45b2dacb47dd977d58b719d097bdf07cb2c17660ad898518c08' .
		'1a61659a16daadfaa406a0a994c743df5eda07e36bd0adcad921b77432ff' .
		'24ccc31e782d647e66768122b578857e9293df78387dc8b44af2a4a3f305' .
		'1f236b1000a3e31da489c6681b0031f7ec37c2e1091bdb698e7660f135b6' .
		'996def90090303b7ad';

$qhex = '009b3734fc9f7a4a9d6437ec314e0a78c2889af64b';

$ghex = '00b320300a0bc55b8f0ec6edc218e2185250f38fbb8291db8a89227f6e41' .
		'00d47d6ccb9c7d42fc43280ecc2ed386e81ff65bc5d6a2ae78db7372f5dc' .
		'f780f4558e7ed3dd0c96a1b40727ac56c5165aed700a3b63997893a1fb21' .
		'4e882221f0dd9604820dc34e2725dd6901c93e0ca56f6d76d495c332edc5' .
		'b81747c4c447a941f3';
$dsa = openssl_pkey_new(array('dsa' => array('p' => hex2bin($p), 'q' => hex2bin($q), 'g' => hex2bin($g))));
$details = openssl_pkey_get_details($dsa);
$dsa_details = $details['dsa'];
var_dump(ltrim($p, '0') === bin2hex($dsa_details['p']));
var_dump(ltrim($q, '0') === bin2hex($dsa_details['q']));
var_dump(ltrim($g, '0') === bin2hex($dsa_details['g']));
var_dump(strlen($dsa_details['priv_key']));
var_dump(strlen($dsa_details['pub_key']));

// DH
$phex = 'dcf93a0b883972ec0e19989ac5a2ce310e1d37717e8d9571bb7623731866e61e' .
		'f75a2e27898b057f9891c2e27a639c3f29b60814581cd3b2ca3986d268370557' .
		'7d45c2e7e52dc81c7a171876e5cea74b1448bfdfaf18828efd2519f14e45e382' .
		'6634af1949e5b535cc829a483b8a76223e5d490a257f05bdff16f2fb22c583ab';
$dh_details = array( 'p' => $phex, 'g' => '2' );
$dh = openssl_pkey_new(array( 'dh'=> array( 'p' => hex2bin($phex), 'g' => '2' )));
$details = openssl_pkey_get_details($dh);
var_dump($phex === $details['dh']['p']));
var_dump($details['dh']['g']);
var_dump(strlen($details['dh']['pub_key']));
var_dump(strlen($details['dh']['priv_key']));

?>
--EXPECTF--

