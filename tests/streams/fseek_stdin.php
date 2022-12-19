<?php
$a = fopen('php://input', 'r');

//var_dump(stream_get_meta_data($a)['seekable']);

//var_dump(ftell($a));
var_dump(fseek($a, 10, SEEK_SET));
//var_dump(ftell($a));
