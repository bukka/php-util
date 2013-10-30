<?php
$dt = new DateTime('1985-03-26 00:30:23');
$dt->xx = 23;
$serialized = serialize($dt);
echo $serialized . "\n";
print_r($dt);
$dt = unserialize($serialized);
print_r($dt);
