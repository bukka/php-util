export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@3/lib/pkgconfig:/opt/homebrew/opt/libedit/lib/pkgconfig"

./configure --enable-debug --enable-cli --enable-gd --enable-fpm --enable-pcntl --with-openssl --with-libedit=/opt/homebrew/opt/libedit --with-zlib --with-iconv=/opt/homebrew/opt/libiconv --with-gettext=/opt/homebrew/opt/gettext --without-pear
