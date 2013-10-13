<?php
$dt = new DateTime('1985-03-26 00:30:23');
var_export($dt);
$dt->test = "testik";
$dt_export = var_export($dt, true);
echo $dt_export . PHP_EOL;
eval('$dt_new = ' . $dt_export . '; var_dump($dt_new);');

class A {
	public $a = 1;
	public $b = "data";
}
$a = new A;
var_export($a);
echo PHP_EOL;


