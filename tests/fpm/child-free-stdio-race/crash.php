<?php

file_put_contents('php://stderr', str_repeat('a', 100) . "\n");
zend_test_crash("crashing\n");

