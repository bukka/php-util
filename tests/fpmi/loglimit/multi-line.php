<?php
file_put_contents('php://stderr', str_repeat('a', 1005) . "\n" . str_repeat('b', 10) . "\n" . str_repeat('c', 3));

