<?php
$max_num_objects = 20;
for ($num_objects = 5; $num_objects <= $max_num_objects; $num_objects++) {
        echo PHP_EOL . 'Number of Objects: ' . $num_objects . PHP_EOL;

        // Create the objects and link them to each other.
        $objects = new stdClass;
        for ($i = 0; $i < $num_objects; $i++) {
                $objects->$i = new stdClass;
        }
        for ($i = 0; $i < $num_objects; $i++) {
                for ($j = 0; $j < $num_objects; $j++) {
                        if ($i != $j) {
                                $objects->$i->$j = $objects->$j;
                        }
                }
        }

        $starttime = microtime(true);
        serialize($objects);
        echo '$objects serialize: ' . number_format(microtime(true) - $starttime, 3) . ' seconds' . PHP_EOL;
        
        $starttime = microtime(true); 
        if (json_encode($objects) === FALSE) {
                echo 'JSON Error #' . json_last_error() . ': ' . json_last_error_msg() . PHP_EOL;
        }
        echo '$objects json_encode: ' . number_format(microtime(true) - $starttime, 3) . ' seconds' . PHP_EOL;
}
