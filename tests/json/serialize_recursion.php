<?php

class SomeClass implements JsonSerializable {
	
	public function jsonSerialize() {
		return [get_object_vars($this)];
	}
}

$class = new SomeClass;
var_dump(json_encode($class));
var_dump(json_last_error() == JSON_ERROR_RECURSION);

$arr = [$class];
var_dump(json_encode($arr));
var_dump(json_last_error() == JSON_ERROR_RECURSION);

var_dump(get_object_vars($class));
