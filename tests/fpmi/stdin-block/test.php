<?php
echo "Before\n";
stream_set_blocking(fopen('php://stdin', 'r'), false);
echo "After\n";

