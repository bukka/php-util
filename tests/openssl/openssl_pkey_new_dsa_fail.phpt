--TEST--
Bug # (openssl_pkey_new does not fail for invalid DSA params)
--SKIPIF--
<?php if (!extension_loaded("openssl")) print "skip"; ?>
--FILE--
<?php
$p =
'00f8000ae45b2dacb47dd977d58b71' .
'9d097bdf07cb2c17660ad898518c08' .
'1a61659a16daadfaa406a0a994c743' .
'df5eda07e36bd0adcad921b77432ff' .
'24ccc31e782d647e66768122b57885' .
'7e9293df78387dc8b44af2a4a3f305' .
'1f236b1000a3e31da489c6681b0031' .
'f7ec37c2e1091bdb698e7660f135b6' .
'996def90090303b7ad';

$q = '009b3734fc9f7a4a9d6437ec314e0a78c2889af64b';

$g = '00b320300a0bc55b8f0ec6edc218e2' .
'185250f38fbb8291db8a89227f6e41' .
'00d47d6ccb9c7d42fc43280ecc2ed3' .
'86e81ff65bc5d6a2ae78db7372f5dc' .
'f780f4558e7ed3dd0c96a1b40727ac' .
'56c5165aed700a3b63997893a1fb21' .
'4e882221f0dd9604820dc34e2725dd' .
'6901c93e0ca56f6d76d495c332edc5' .
'b81747c4c447a941f3';

function output_dsa($dsa) {
	global $p, $q, $g;
	if (!$dsa) {
		echo "Creating DSA failed\n";
		return;
	}

	$details = openssl_pkey_get_details($dsa);
	$dsa_details = $details['dsa'];
	var_dump(ltrim($p, '0') === bin2hex($dsa_details['p']));
	var_dump(ltrim($q, '0') === bin2hex($dsa_details['q']));
	var_dump(ltrim($g, '0') === bin2hex($dsa_details['g']));
	var_dump(strlen($dsa_details['priv_key']));
	var_dump(strlen($dsa_details['pub_key']));
}

output_dsa(openssl_pkey_new(array('dsa' => array('p' => $p, 'q' => $q, 'g' => $g))));
output_dsa(openssl_pkey_new(array('dsa' => array('p' => hex2bin($p), 'q' => hex2bin($q), 'g' => hex2bin($g)))));

/* actual:
bool(false)
bool(false)
bool(false)
int(42)
int(0)
bool(true)
bool(true)
bool(true)
int(20)
int(128)
*/
?>
--EXPECTF--
Creating DSA failed
bool(true)
bool(true)
bool(true)
int(20)
int(128)