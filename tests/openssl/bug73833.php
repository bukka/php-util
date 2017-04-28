<?php
//This will fail to decrypt using the first password due to the null byte (\x00)
$passwords = ["abc\x00defghijkl", "abcdefghikjl"];

foreach($passwords as $password){
    $key = openssl_pkey_new();

    if(openssl_pkey_export($key, $privatePEM, $password) === FALSE){
        echo "Failed to encrypt.\n";
    }else{
        echo "Encrypted!\n";
    }

    //This will throw a warning and fail to decrypt.
    if(openssl_pkey_get_private($privatePEM, $password) === FALSE){
        echo "Failed to decrypt.\n";
    }else{
        echo "Decrypted!\n";
    }


}
