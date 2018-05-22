<?php

$key = "-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDLXp6PkCtbpV+P1gwFQWH6Ez0U
83uEmS8IGnpeI8Fk8rY/vHOZzZZaxRCw+loyc342qCDIQheMOCNm5Fkevz06q757
/oooiLR3yryYGKiKG1IZIiplmtsC95oKrzUSKk60wuI1mbgpMUP5LKi/Tvxes5Pm
kUtXfimz2qgkeUcPpQIDAQAB
-----END PUBLIC KEY-----";
$message = '123';
$passed = openssl_public_encrypt($message, $response, $key);
echo (($passed) ? "Function Passed" : "Function Failed") . PHP_EOL;
echo ((is_null($response)) ? "No Result Returned" : "Result Returned Successfully") . PHP_EOL;
if ($error = openssl_error_string()) {
    echo "Error Returned: ";
    echo $error . "\n";
}
var_dump(openssl_error_string());
