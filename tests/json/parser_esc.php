<?php
$str = '{ "utf1": "\u0033", "utf2": "\u0100", "utf3": "\u2023", "utf4": "\u2325" }';
var_dump(json_decode($str));