<?php

var_dump(headers_sent());

while (ob_get_level() !== 0) {
    ob_end_flush();
}
flush();

var_dump(headers_sent());
var_dump(ob_get_level());
