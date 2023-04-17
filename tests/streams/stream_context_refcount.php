<?php
$context = stream_context_create();
debug_zval_dump($context);
$result = stream_socket_server('tcp://127.0.0.1:0', context: $context);
debug_zval_dump($context);
unset($result);
debug_zval_dump($context);