<?php

class A extends ArrayObject {
	public function offsetGet($offset) {
		isset($this[$offset]);
	}
}

$a = new A;
$a['one'] = 10;
echo $a['one'];