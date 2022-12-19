<?php

echo 'Testing PHP version: '.phpversion()."\n";

$pair = stream_socket_pair(STREAM_PF_UNIX, STREAM_SOCK_STREAM, STREAM_IPPROTO_IP);

$pid = pcntl_fork();

if ($pid == -1) die("Failed to fork\n");

$i = 0;

if ($pid > 0) {
  // parent
  fclose($pair[0]);
  while(!feof($pair[1])) {
    $start = microtime(true);
    $data = fread($pair[1], 256);
    printf("fread took %01.2fms to read %d bytes\n", (microtime(true)-$start)*1000, strlen($data));
    if ($i++ > 5) exit;
  }
  exit;
}

// child
fclose($pair[1]);
while(!feof($pair[0])) {
  fwrite($pair[0], "Hello 1\n"); // 8 bytes
  usleep(5000);
  fwrite($pair[0], str_repeat('a', 300)."\n"); // 301 bytes
  if ($i++ > 1) exit;
  sleep(1);
}
