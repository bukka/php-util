<?php

$pattern = '/pool:\s+unconfined
process manager:\s+static
start time:\s+\d+\/\w{3}\/\d{4}:\d{2}:\d{2}:\d{2}\s\+\d{4}
start since:\s+\d+
accepted conn:\s+1
listen queue:\s+0
max listen queue:\s+0
listen queue len:\s+\d+
idle processes:\s+0
active processes:\s+1
total processes:\s+1
max active processes:\s+1
max children reached:\s+0
slow requests:\s+0/';

$body = "pool:                 unconfined
process manager:      static
start time:           10/May/2018:19:24:21 +0100
start since:          0
accepted conn:        1
listen queue:         0
max listen queue:     0
listen queue len:     128
idle processes:       0
active processes:     1
total processes:      1
max active processes: 1
max children reached: 0
slow requests:        0";


var_dump(preg_match($pattern, $body));
