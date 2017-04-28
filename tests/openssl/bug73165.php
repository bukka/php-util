<?php
$contents = file_get_contents(__DIR__ . "/bug73165.pem");
print_r(openssl_x509_parse($contents));
