<?php

class A extends ArrayObject {
	public function offsetGet($offset) {
		return isset($this[$offset]) ? parent::offsetGet($offset) : null;
	}
}

$a = new A;
$a['one'] = 10;
echo $a['one'];