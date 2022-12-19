<?php

class X implements JsonSerializable {
    public $prop = "value";
    public function jsonSerialize(): mixed {
        var_dump($this);
        return ['p' => $this->prop];
    }
}

echo json_encode(new X());
