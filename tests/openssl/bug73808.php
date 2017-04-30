<?php
var_dump(openssl_encrypt('data', 'aes-256-ccm', 'password', 0, '1234567', $tag));
