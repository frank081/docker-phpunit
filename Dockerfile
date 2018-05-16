FROM php:5.6-alpine

# phpunit version
ENV PHPUNIT_VERSION 4.8

RUN apk update \
    && apk add --update --virtual autoconf \
    && apk add --no-cach bash \
    build-base \
    openrc \
    openssl \
    git \
    openssh
#    && yes | pecl install xdebug-2.2.7 \
#    && docker-php-ext-enable xdebug

# Setup php.ini file
RUN pecl config-set php_ini /usr/local/etc/php/php.ini
RUN echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20131226/xdebug.s" >> /usr/local/etc/php/php.ini
RUN echo "date.timezone = America/New_York" >> /usr/local/etc/php/php.ini

# Install xdebug
RUN apk add --no-cache $PHPIZE_DEPS \
	&& pecl install xdebug-2.5.5 \
	&& docker-php-ext-enable xdebug

# Install phpunit
RUN mkdir -p /root/src \
    && cd /root/src \
    && wget https://phar.phpunit.de/phpunit-${PHPUNIT_VERSION}.phar \
    && chmod +x phpunit-${PHPUNIT_VERSION}.phar \
    && mv phpunit-${PHPUNIT_VERSION}.phar /usr/local/bin/phpunit \
    && rm -rf /root/src \
    && phpunit --version
