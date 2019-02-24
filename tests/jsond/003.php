<?php
$a = array();
$a[] = &$a;

var_dump($a);

echo "\n";

var_dump(jsond_encode($a));
var_dump(jsond_last_error(), jsond_last_error_msg());

echo "\n";

var_dump(jsond_encode($a, JSOND_PARTIAL_OUTPUT_ON_ERROR));
var_dump(jsond_last_error(), jsond_last_error_msg());

echo "Done\n";

