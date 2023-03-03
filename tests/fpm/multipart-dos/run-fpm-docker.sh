exec docker run -p 9012:9000 -v $PWD:$PWD php:8.2-fpm -R -y $PWD/fpm-docker.conf -F
