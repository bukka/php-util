<?php

require_once __DIR__ . "/include.php";

if (!isset($argv[1])) {
	die("The script is not supplied");
}

$port = 9012;

$req = run_request('127.0.0.1', $port, $argv[1]);

var_dump($req);