<?php
echo "------ SERIALIZE ------\n\n";
echo "NULL\n";
var_dump(serialize(null));
echo "INT\n";
var_dump(serialize(23));
echo "DOUBLE\n";
var_dump(serialize(23.2));
var_dump(serialize(23.));
echo "STRING\n";
var_dump(serialize("test"));

echo "ARRAY\n";
var_dump(serialize(array(1, 2, 3)));
var_dump(serialize(array("first" => "bum", "second" => "bam")));
var_dump(serialize(array("first" => "bum", "nested" => array("bara", "kuba"), "x")));

echo "OBJECT: StdClass\n";
$o = new StdClass;
var_dump(serialize($o));
$o->prop = "result";
var_dump(serialize($o));

echo "OBJECT: Custom\n";
class Custom implements Serializable {
	public function serialize() {
		return "custom-datastr";
	}
	public function unserialize($str) {
	}
}
$c = new Custom;
var_dump(serialize($c));

echo "REFERENCE\n";
$o = 23;
$ro = &$o;
var_dump(serialize($ro));

echo "\n------ UNSERIALIZE ------\n\n";
echo "Array with object:\n";
class TestObj {
	public $a = 23;
	public $b = "xxx";
}
$serial = serialize(array("test" => new TestObj));
$data = unserialize($serial);
var_dump($data);