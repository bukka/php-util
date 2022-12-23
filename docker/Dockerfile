FROM ubuntu:22.04

RUN apt-get update

RUN apt-get install -y \
        autoconf \
        bison \
        re2c \
        gcc \
        g++ \
        gdb \
        vim \
        make \
        locales \
        openssl \
        language-pack-de \
        libgmp-dev \
        libicu-dev \
        libtidy-dev \
        libenchant-2-dev \
        libaspell-dev \
        libpspell-dev \
        libsasl2-dev \
        libxpm-dev \
        libzip-dev \
        libsqlite3-dev \
        libwebp-dev \
        libonig-dev \
        libkrb5-dev \
        libgssapi-krb5-2 \
        libcurl4-openssl-dev \
        libxml2-dev \
        libxslt1-dev \
        libpq-dev \
        libreadline-dev \
        libldap2-dev \
        libsodium-dev \
        libargon2-0-dev \
        libmm-dev \
        freetds-dev \
        libc-client-dev \
        libjpeg-dev \
        libpng-dev \
        libfreetype6-dev

ADD . php/

WORKDIR php

RUN ./buildconf --force

RUN ./configure \
        --enable-option-checking=fatal \
        --prefix=/usr \
        --enable-phpdbg \
        --enable-fpm \
        --enable-intl \
        --without-pear \
        --enable-gd \
        --with-jpeg \
        --with-webp \
        --with-freetype \
        --with-zip \
        --with-zlib \
        --with-zlib-dir=/usr \
        --enable-soap \
        --enable-pcntl \
        --with-readline \
        --enable-mbstring \
        --with-curl \
        --enable-sockets \
        --with-openssl \
        --with-gmp \
        --with-kerberos \
        --enable-sysvmsg \
        --with-ffi \
        --enable-zend-test \
        --enable-dl-test=shared \
        --with-config-file-path=/etc \
        --with-config-file-scan-dir=/etc/php.d

RUN make -j8 && make install

RUN mkdir /etc/php.d && chmod 777 /etc/php.d