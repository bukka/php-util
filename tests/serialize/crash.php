<?php
class SerializeTest
{
    public $a = 1;

    public function __serialize()
    {
        return [ 'result' => serialize($this) ];
    }
}

var_dump(serialize(new SerializeTest()));
