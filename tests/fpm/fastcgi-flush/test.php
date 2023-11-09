<?php

header('x-test1: yes');
flush();
sleep(1);
header('x-test2: yes');

var_dump(headers_sent());
