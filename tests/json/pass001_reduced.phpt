--TEST--
JSON (http://www.crockford.com/JSON/JSON_checker/test/pass1.json)
--INI--
serialize_precision=-1
--SKIPIF--
<?php
  if (!extension_loaded('jsond')) die('skip: jsond extension not available');
?>
--FILE--
<?php
// Expect warnings about INF.
ini_set("error_reporting", E_ALL & ~E_WARNING);

require_once "bootstrap.inc";

$jsond_decode = "jsond_decode";
$jsond_encode = "jsond_encode";

$test = '{"e": 0.123456789e-12}';
$obj = $jsond_decode($test);
var_dump($obj);
echo "ENCODE: FROM OBJECT\n";
$obj_enc = $jsond_encode($obj, jsond_constant('PARTIAL_OUTPUT_ON_ERROR'));
echo $obj_enc . "\n";
echo "DECODE AGAIN: AS OBJECT\n";
$obj = $jsond_decode($obj_enc);
var_dump($obj);


?>
--EXPECTF--
