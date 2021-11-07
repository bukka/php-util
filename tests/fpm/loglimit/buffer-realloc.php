<?php
file_put_contents('php://stderr', str_repeat('a', 100));
usleep(20000);
file_put_contents('php://stderr', str_repeat('b', 2500) . "\n");
