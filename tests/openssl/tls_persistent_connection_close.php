<?php

set_error_handler(function($errno, $errstring, $errfile, $errline) {
        foreach (get_resources() as $res) {
            if (get_resource_type($res) === "persistent stream") {
                echo "ERROR: persistent stream not closed\n";
            }
        }
        echo "DONE\n";
        exit(1);
});


stream_socket_client("tcp://9999.9999.9999.9999:9999", $error_code, $error_message, 0.2, STREAM_CLIENT_CONNECT | STREAM_CLIENT_PERSISTENT);

echo "ERROR: this should not be visible";