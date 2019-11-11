################################## Base PHP dependencies ##################################

FROM php:7.3-fpm-stretch as base

ENV ACCEPT_EULA=Y
ENV DEBIAN_FRONTEND=noninteractive

# Install PHP extensions and PECL modules.
RUN buildDeps=" \
        default-libmysqlclient-dev \
        libbz2-dev \
        libmemcached-dev \
        libsasl2-dev \
    " \
    runtimeDeps=" \
        curl \
        git \
        libcurl3 \
        libcurl3-dev \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libldap2-dev \
        libmemcachedutil2 \
        libpng-dev \
        libpq-dev \
        libxml2-dev \
        libfontconfig1 \
        libxrender1 \
        openssl \
    " \
    && apt-get update && apt-get install -y zlib1g-dev libzip-dev git zip unzip \
    && apt-get install -y $buildDeps $runtimeDeps \
    && docker-php-ext-install bcmath bz2 calendar iconv intl mbstring mysqli opcache pdo_mysql pdo_pgsql pgsql soap zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap \
    && docker-php-ext-install exif \
    && pecl install memcached redis \
    && docker-php-ext-enable memcached.so redis.so \
    && apt-get purge -y --auto-remove $buildDeps \
    && docker-php-ext-install curl \
    && apt-get install -y gnupg apt-transport-https unixodbc-dev \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update -yqq \
    && apt-get install -y msodbcsql17 mssql-tools \
    && ln -fsv /opt/mssql-tools/bin/* /usr/bin \
    && pecl install sqlsrv \
    && pecl install pdo_sqlsrv \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

################################## Composer Base ##################################

FROM base as composer

RUN mkdir -p /var/www/app

RUN docker-php-ext-install zip

RUN rm -rf /var/lib/apt/lists/*

RUN curl --silent --show-error https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

################################## Symfony create project ##################################

FROM composer as symfony

################################## Composer PHP dependencies ##################################

FROM composer as vendor

COPY ./app/composer.json /var/www/app/composer.json
COPY ./app/composer.lock /var/www/app/composer.lock

RUN composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --prefer-dist \
    -d /var/www/app

################################## Frontend dependencies ##################################

FROM node:8.11 as frontend

RUN mkdir -p /app/public

#COPY ./app/package.json ./app/webpack.mix.js ./app/yarn.lock /app/

################################## Production Build ##################################

FROM base as production

COPY ./app /var/www/app
COPY --from=vendor /php-vendor/ /php-vendor/

################################## Development Build ##################################

FROM base as development

RUN apt-get update \
    && apt-get install --no-install-recommends --assume-yes --quiet ca-certificates curl git \
    && pecl install xdebug-2.7.2 && docker-php-ext-enable xdebug \
    && echo 'zend_extension="/usr/local/lib/php/extensions/no-debug-non-zts-20151012/xdebug.so"' >> /usr/local/etc/php/php.ini \
    && echo 'xdebug.remote_port=9000' >> /usr/local/etc/php/php.ini \
    && echo 'xdebug.remote_enable=1' >> /usr/local/etc/php/php.ini \
    && echo 'xdebug.remote_connect_back=1' >> /usr/local/etc/php/php.ini \
    && rm -rf /var/lib/apt/lists/*

COPY ./app /var/www/app
COPY --from=vendor /php-vendor/ /php-vendor/