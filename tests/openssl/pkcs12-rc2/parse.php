<?php

$cert_store = file_get_contents(__DIR__ . "/keystore-rc2.p12");

if (openssl_pkcs12_read($cert_store, $cert_info, "test")) {
    echo "Certificate Information\n";
    print_r($cert_info);
} else {
    echo "Error: Unable to read the cert store.\n";
}
