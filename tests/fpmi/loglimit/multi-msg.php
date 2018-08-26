<?php
file_put_contents('php://stderr', "msg 1 - ");
usleep(1);
file_put_contents('php://stderr', "msg 2 - ");
usleep(1);
file_put_contents('php://stderr', "msg 3");