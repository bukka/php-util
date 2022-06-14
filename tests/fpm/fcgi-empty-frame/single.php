<?php
// YMMV. Ideally leave log_errors_max_len at the default of 1024
define('ERR_HDR', 'Warning: ');
define('FCGI_OUT_BUF_SIZE', 8192);
define('FCGI_HDR_SIZE', 8);

$max = 10000;
$len = FCGI_OUT_BUF_SIZE - FCGI_HDR_SIZE - strlen($_SERVER["SCRIPT_FILENAME"]) - strlen(" on line 15");
$bytes = 0;

while ($bytes < $len) {
    $p = str_repeat('a', min($max, $len - $bytes) - strlen(ERR_HDR) - 1);
    $bytes += strlen($p) + strlen(ERR_HDR) + 1;
    trigger_error($p, E_USER_WARNING);
}
