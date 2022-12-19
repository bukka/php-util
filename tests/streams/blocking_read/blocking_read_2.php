<?php

echo 'Testing PHP version: '.phpversion()."\n";

$pair = stream_socket_pair(STREAM_PF_UNIX, STREAM_SOCK_STREAM, STREAM_IPPROTO_IP);

$pid = pcntl_fork();

if ($pid == -1) die("Failed to fork\n");

$i = 0;

if ($pid > 0) {
  // parent
  fclose($pair[0]);
  $data = fread($pair[1], 256);
  echo "read: " . strlen($data) . " bytes\n";
  $data = fread($pair[1], 256);
  echo "read: " . strlen($data) . " bytes\n";
  exit;
}

// child
fclose($pair[1]);
fwrite($pair[0], str_repeat('a', 300)."\n"); // 301 bytes
sleep(20);
