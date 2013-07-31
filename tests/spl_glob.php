<?php
ini_set('open_basedir', __DIR__); 

$path = (dirname(__DIR__) . '/../*');

$std_glob = glob($path);
$spl_glob = array();
try {
	$spl_glob_it = new \GlobIterator($path);
	foreach ($spl_glob_it as $file_info) {
		$spl_glob[] = $file_info->getPathname();
	}
} catch (Exception $e) {
	var_dump($e->getMessage());
}

print_r($std_glob);
print_r($spl_glob);

