<?php
for ($i = 0; $i < 100; $i++) {
    file_put_contents('php://stderr', str_repeat('a', 100) . "\n");
}
echo "done\n";
