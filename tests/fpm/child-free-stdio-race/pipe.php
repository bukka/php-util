<?php
$proc = proc_open("cat fpm.conf", [['pipe', 'r'], ['pipe', 'w'], ['pipe', 'w']], $pipe);

if ($proc) {
    fclose($pipe[1]);
    usleep(50000);
    fwrite($pipe[0], 'fail');
    fclose($proc);
}

