<?php

function test() {
	$a = 1;
	$b = 2;

	echo $a + $b + 1;
}

class Loop
{
	function loopFor(float $count = 2.0) {
		// for loop
		for ($i = 0; $i < 1; ++$i) {
			echo $count;
		}
	}

	function loopWhile($count) {
		$i = 0;
		while ($i < $count) {
			print $i;
			++$i;
		}
	}

	function loopDoWhile($count) {
		$i = 0;
		do {
			echo $i;
			++$i;
		} while ($i < $count);
	}

	function loopArray() {
		$a = [1, 2];
		$a[] = 3;
		foreach ($a as $val) {
			printf("a: %d\n", $val);
		}
	}	
}

function makeClass() {
	$a = new Loop;
	$a->loopFor(2);
	$a->loopWhile(2);
	$a->loopDoWhile(3);

	return $a;
}

function makeSwitch($val, &$result, $x) {
	$test = 2;
	switch ($val) {
	  case 1:
		  $result = $val;
		  break;
	  case $test:
		  $result = 0;
		  break;
	  default:
		  $result = -1;
		  break;
	}

	return true;
}

function makeException($val) {
	try {
		$x = "x" . $val;
		if ($x === 'x') {
			throw new \Exception("Value empty");
		}
	} catch (\Exception $e) {
		echo $e->getMessage();
	}
}

$g;

function makeAssign($val) {
	global $g;
	$g['test'] = &$val;

	return $g;
}

function makeClosure($val, $param) {
	$f = function ($v) use ($val) {
		return $val - $v + 1;
	};
	return $f($param);
}

function castToString($val) {
	$cast1 = (string) $val;
	$cast2 = $val . "";
	$cast3 = "$val";

	return $cast1 === $cast2 && $cast2 === $cast3;
}

test();
makeClass();
makeSwitch(1, $result, 2);
makeException('');
makeAssign(1);
makeClosure(10, 3); 