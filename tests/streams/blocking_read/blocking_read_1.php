<?php

$pair = stream_socket_pair(STREAM_PF_UNIX, STREAM_SOCK_STREAM, STREAM_IPPROTO_IP);

$pid = pcntl_fork();

if ($pid == -1) die("Failed to fork\n");

$i = 0;

if ($pid > 0) {
  // parent
  fclose($pair[0]);
  while(!feof($pair[1])) {
    $data = fread($pair[1], 256);
    printf("fread read %d bytes\n", strlen($data));
    if ($i++ > 5) 
      break;
  }
  exit;
}

// child
fclose($pair[1]);
fwrite($pair[0], "Hello 1\n"); // 8 bytes
usleep(50000);
fwrite($pair[0], str_repeat('a', 300)."\n"); // 301 bytes
usleep(50000);
fwrite($pair[0], "Hello 1\n"); // 8 bytes