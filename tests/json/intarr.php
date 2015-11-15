<?php
$data = [
	123 => (object)['name' => 'Example']
];

var_dump($data); // for reference, this shows the structure of the array $data
echo $data[123]->name; // working as intented

$data = json_encode($data); // serialize $data to {"123":{"name":"Example"}}

echo "\n\n\n";

$data = json_decode($data); // unserialize json
var_dump($data);
$data = (array)$data; // even though it was originally an array, $data is an object because JavaScript does not support non-contiguous arrays, so we have to explicitly convert to array
	
var_dump($data); // this shows the structure of the array $data looks just like it was before, all should be fine, but then...
	
echo $data['123']; // BOOM! Notice: Undefined offset: 123
