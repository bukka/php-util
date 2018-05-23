

php_base_path=$(dirname $(dirname $(dirname $PWD)))
echo gdb -i=mi --args $php_base_path/master/sapi/fpmi/php-fpmi -F -y $PWD/fpmi-log-buffered.conf
