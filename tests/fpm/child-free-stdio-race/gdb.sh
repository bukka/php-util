

php_base_path=$(dirname $(dirname $(dirname $PWD)))
echo gdb -i=mi --args $php_base_path/74/sapi/fpm/php-fpm -F -y $PWD/fpm.conf
