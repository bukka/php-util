<?php
//error_log(str_repeat('a', 2048) . "\n");
file_put_contents('php://stderr', str_repeat('a', 2048) . "\n");
