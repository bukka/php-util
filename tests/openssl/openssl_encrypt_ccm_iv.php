<?php
function printTag($plaintext, $key, $iv, $aad, $taglength){
    $encrypted = openssl_encrypt($plaintext, 'aes-128-ccm', $key, OPENSSL_RAW_DATA, $iv, $tag, $aad, $taglength);
    print('ciphertext: ' . bin2hex($encrypted) . ' - tag: ' .  bin2hex($tag) . "\n");
}

$key = hex2bin('404142434445464748494a4b4c4d4e4f');
$aad = hex2bin('000102030405060708090a0b0c0d0e0f10111213');
$plaintext = hex2bin('202122232425262728292a2b2c2d2e2f3031323334353637');
$tagLength = 8;
                                                               
$iv = hex2bin('101112131415161718191a1b'); // 12 bytes
printTag($plaintext, $key, $iv, $aad, $tagLength); // ciphertext: 7162015bc051951e5918aeaf3c11f3d4ac363f8d5b6af3d3 - tag: af9831fb22f8931f

$iv = hex2bin('10111213141516'); // 7 bytes
printTag($plaintext, $key, $iv, $aad, $tagLength); // ciphertext: 7162015bc051951e5918aeaf3c11f3d4ac363f8d5b6af3d3 - tag: af9831fb22f8931f
