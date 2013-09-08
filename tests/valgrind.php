<?php
$a =array();
callgrind_toggle();
for ($i=0;$i<100;$i++) {
   $a[$i] = 2;
}
callgrind_toggle();
callgrind_dump();