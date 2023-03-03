<?php

$s1 = stream_socket_server('127.0.0.1:8501');
$s2 = stream_socket_server('127.0.0.1:8502');

$conn1 = stream_socket_accept($s1);
$conn2 = stream_socket_accept($s2);

$pid = pcntl_fork();

if ($pid > 0) {
    $read = [$conn1, $conn2];
    $write = $except = null;
    var_dump(stream_select($read, $write, $except, 10));
    sleep(1);
    fwrite($conn1, "parent test conn 1\n");
    fwrite($conn2, "parent test conn 2\n");
    fclose($conn1);
    fclose($conn2);
    echo "Parent ends\n";
} else {
    sleep(1);
    fwrite($conn1, "child test conn 1\n");
    fwrite($conn2, "child test conn 2\n");
    fclose($conn1);
    fclose($conn2);
    echo "Child ends\n";
}