<?php
pcntl_sigprocmask(SIG_BLOCK, [SIGQUIT, SIGTERM]);
sleep(2);
