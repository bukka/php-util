if [ "$1" = "apache" ]; then
  port=8084
else
  port=8083
fi
/usr/bin/curl http://localhost:$port/index.php
