<?php

$iters = isset($argv[1]) ? $argv[1] : 100000;

function test_serialization($object) {
	global $iters;
	
	// output serialization
	$s = serialize($object);
	echo serialize($object) . PHP_EOL;
	$start = microtime(true);
	for ($j = 0; $j < $iters; $j++) {
		serialize($object);
	}
	$end = microtime(true);
	$duration = $end - $start;
	printf("time for %d iterations: %f" . PHP_EOL, $iters, $duration);
	return $s;
}

function test_unserialization($string) {
	global $iters;
	
	// output unserialization
	var_dump(unserialize($string));
	$start = microtime(true);
	for ($j = 0; $j < $iters; $j++) {
		unserialize($string);
	}
	$end = microtime(true);
	$duration = $end - $start;
	printf("time for %d iterations: %f" . PHP_EOL, $iters, $duration);
}


$n = gmp_init(42);

echo "SERIALIZATION" . PHP_EOL;
$s = test_serialization($n);

echo PHP_EOL;

echo "UNSERIALIZATION" . PHP_EOL;
test_unserialization($s);
