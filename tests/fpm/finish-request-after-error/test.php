<?php

echo "Hi!";
fastcgi_finish_request();

sleep(10);
file_put_contents("test.log",  date('c') . "\n\n", FILE_APPEND);

ksbkdbsd();