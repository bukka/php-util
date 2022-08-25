export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@1.1/lib/pkgconfig:/opt/homebrew/opt/libedit/lib/pkgconfig"

./configure --enable-cli --enable-fpm --enable-pcntl --with-openssl --with-libedit=/opt/homebrew/opt/libedit --with-zlib --with-iconv=/opt/homebrew/opt/libiconv
