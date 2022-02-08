<?php

while(true){
    $json = file_get_contents("http://127.0.0.1:8083/status.php?json&full");
    $result = json_decode($json);
    $processes = $result->processes;
    foreach ($processes as $proc){
        //a dummy page should take low time to be gen no ?
        if($proc->{"request duration"} > 1000000){
            echo "impossible value found!";
            print_r($proc);
            echo "\n";
            die();
        }
    }
}
