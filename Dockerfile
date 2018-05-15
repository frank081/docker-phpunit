FROM php:5.6-alpine

# phpunit
ENV PHPUNIT_VERSION 4.8

RUN apk update \
    && apk add --update --virtual autoconf \
    && apk --no-cache add bash \
    build-base \
    openssl \
    git \
    openssh \
    && yes | pecl install xdebug-2.2.7 \
    && docker-php-ext-enable xdebug
RUN 
    

RUN echo "date.timezone = America/New_York" > /usr/local/etc/php/php.ini

RUN mkdir -p /root/src \
    && cd /root/src \
    && wget https://phar.phpunit.de/phpunit-${PHPUNIT_VERSION}.phar \
    && chmod +x phpunit-${PHPUNIT_VERSION}.phar \
    && mv phpunit-${PHPUNIT_VERSION}.phar /usr/local/bin/phpunit \
    && rm -rf /root/src \
    && phpunit --version
