<?php
$pair = generateKeyPair(true);
var_dump($pair);
$public = $pair['public'];

$ciphertext = "111-11-1111";
$res = openssl_public_encrypt($ciphertext, $enc, $public, OPENSSL_PKCS1_OAEP_PADDING);
if($res){
    var_dump(bin2hex($enc));
} else {
    while ($err = openssl_error_string()) echo $err . "\n";
    echo "Failed to encrypt :(";
}

function generateKeyPair(bool $ec){
    $params = $ec ? [
        'private_key_bits' => 384,
        'private_key_type' => OPENSSL_KEYTYPE_EC,
        'curve_name' => 'secp384r1'
    ] : [
        'private_key_bits' => 3072,
        'private_key_type' => OPENSSL_KEYTYPE_RSA
    ];
    
    $res = openssl_pkey_new($params);
    openssl_pkey_export($res, $privKey);

    $pubKey = openssl_pkey_get_details($res);
    $pubKey = $pubKey["key"];
    
    openssl_free_key($res);
    return ['private'=>$privKey, 'public'=>$pubKey];
}

