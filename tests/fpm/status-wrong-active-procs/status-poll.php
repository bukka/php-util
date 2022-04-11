<?php

while(true){
    $json = file_get_contents("http://127.0.0.1:8083/status.php?json&full");
    $result = json_decode($json);
    if($result->{"active processes"} > 10) {
        echo "Value greater than max found!";
        print_r($result);
        echo "\n";
        die();
    }
}
