<?php
$handle = fopen('http://example.com', 'r');
var_dump(stream_isatty($handle));
//echo stream_get_contents($handle);
