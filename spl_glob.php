<?php
error_reporting(-1);
ini_set('display_errors', 1);
ini_set('open_basedir', __DIR__);

class Globber
{
	public function __destruct()
	{
		var_dump(__DIR__);
		var_dump(glob(__DIR__ . '/*.php'));
		var_dump(iterator_to_array(new \GlobIterator(__DIR__ 
.'/*.php')));
	}
}

$globber = new Globber;
