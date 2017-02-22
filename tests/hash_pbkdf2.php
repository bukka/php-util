<?php
$password = "password";
$iterations = 1000;

$salt = str_repeat('a', 16);

$hash = hash_pbkdf2("sha256", $password, $salt, $iterations, 32);
echo $hash;
?>
