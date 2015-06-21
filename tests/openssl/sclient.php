<?php

$data = file_get_contents("https://packagist.org");
if (!$data) {
	var_dump(openssl_get_cert_locations());
} else {
	echo "SUCCESS";
}