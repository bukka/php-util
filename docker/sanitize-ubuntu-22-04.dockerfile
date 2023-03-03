FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
        autoconf \
        bison \
        re2c \
        clang \
        gdb \
        vim \
        make \
        locales

ADD . php/

WORKDIR php

RUN ./buildconf --force

ENV CC=clang
ENV CXX=clang++
ENV CFLAGS="-DZEND_TRACK_ARENA_ALLOC"

RUN ./configure \
        --enable-debug \
        --enable-zts \
        --enable-option-checking=fatal \
        --prefix=/usr \
        --without-sqlite3 \
        --without-pdo-sqlite \
        --without-libxml \
        --disable-dom \
        --disable-simplexml \
        --disable-xml \
        --disable-xmlreader \
        --disable-xmlwriter \
        --without-pcre-jit \
        --disable-opcache-jit \
        --enable-phpdbg \
        --enable-fpm \
        --without-pear \
        --enable-exif \
        --enable-sysvsem \
        --enable-sysvshm \
        --enable-shmop \
        --enable-pcntl \
        --enable-mbstring \
        --disable-mbregex \
        --enable-sockets \
        --enable-zend-test \
        --enable-werror \
        --enable-address-sanitizer \
        --with-config-file-path=/etc \
        --with-config-file-scan-dir=/etc/php.d

RUN make -j8 && make install

RUN mkdir /etc/php.d && chmod 777 /etc/php.d