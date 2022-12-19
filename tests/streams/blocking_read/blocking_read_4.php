<?php

$pid = pcntl_fork();

if ($pid == -1) die("Failed to fork\n");

$i = 0;

if ($pid > 0) {

  usleep(500000);
  $fp = fsockopen("tcp://127.0.0.1:64324");

  while(!feof($fp)) {
    $data = fread($fp, 256);
    printf("fread read %d bytes\n", strlen($data));
    if ($i++ > 5) 
      break;
  }
  exit;
}

// child
$server = stream_socket_server('tcp://127.0.0.1:64324');

$conn = stream_socket_accept($server);

fwrite($conn, "Hello 1\n"); // 8 bytes
usleep(50000);
fwrite($conn, str_repeat('a', 300)."\n"); // 301 bytes
usleep(50000);
fwrite($conn, "Hello 1\n"); // 8 bytes

fclose($conn);