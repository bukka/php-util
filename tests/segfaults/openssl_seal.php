<?php
$pkey = openssl_pkey_new(array(
             'digest_alg' => 'sha256',
             'x509_extensions' => 'v3_ca',
             'private_key_bits' => 4096,
             'private_key_type' => OPENSSL_KEYTYPE_RSA,
             'encrypt_key' => false
         ));
$details = openssl_pkey_get_details($pkey);
$Tpubkey = $details['key'];
$pubkey = openssl_pkey_get_public($Tpubkey);
$encrypted = null;
$ekeys = array();
$result = openssl_seal('test phrase', $encrypted, $ekeys, array($pubkey), 'aes256');
