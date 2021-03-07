#!/bin/bash -xe

# all paths are specific to default ones in Ubuntu 20.04
pool_d="/etc/php/7.4/fpm/pool.d"
pool_0="$pool_d/www.conf"
sed -i "s/^pm = dynamic$/pm = ondemand/" "$pool_0"
for i in {1001..1128}; do
    pool_i="$pool_d/www_$i.conf"
    cp -p "$pool_0" "$pool_i"
    sed -i "s/^\[www\]$/\[www_$i\]/" "$pool_i"
    sed -i "s|^listen = /run/php/php7.4-fpm.sock$|listen = /run/php/php7.4-fpm.$i.sock|" "$pool_i"
done

systemctl restart php7.4-fpm
rm -f "$pool_d/www_1001.conf"
date
systemctl reload php7.4-fpm
systemctl reload php7.4-fpm
sleep 5
grep ERROR /var/log/php7.4-fpm.log
rm -f $pool_d/www_*
