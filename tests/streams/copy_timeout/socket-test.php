<?php
const SEND_BYTES = 10 * 1024;

if (pcntl_fork() == 0) {
    doSender();
}

doServer();
pcntl_wait($status); // wait for the sender process

function doSender() {
    $socket = socket_create(AF_INET, SOCK_STREAM, SOL_TCP);
    socket_connect($socket, '127.0.0.1', 9638);

    $string = str_repeat("0", SEND_BYTES);
    $written = 0;

    for ($i = 0; $i < 2; ++ $i) {
        $bytes = socket_write($socket, $string . "\n");
        assert($bytes !== false, "server died");

        $written += $bytes;

        sleep((int)ini_get('default_socket_timeout') * 2);
    }

    printf("written: %d\n", $written);
    exit;
}


function doServer() {
    $server = new Server;
    $server->doServer();
}

class Server
{
    private $socket_server;

    function doServer()
    {
        $this->socket_server = $this->startSocketServer();

        while (true) {
            //stream_socket_accept emits a warning if interrupted by a signal
            if (@$client = stream_socket_accept($this->socket_server, 0)) {
                $this->handleClient($client);
                break;
            }

            usleep(10000); //0.01 sec
        }

        fclose($this->socket_server);
    }

    function startSocketServer()
    {
        $socket_server = stream_socket_server("tcp://0.0.0.0:9638", $errno, $errstr);
        assert(!empty($socket_server), "Could not start socket server [$errno]: $errstr");

        if (!stream_set_blocking($socket_server, false)) {
            assert(false, "Could not set socket server to non-blocking mode");
        }

        return $socket_server;
    }

    protected function handleClient($client)
    {
        $handle = fopen("/dev/null", 'w');
        assert(!empty($handle), "Could not open client output stream for write");

        $bytes_copied = stream_copy_to_stream($client, $handle);
        printf("read %d bytes\n", $bytes_copied);

        fclose($handle);
        fclose($client);
    }
}