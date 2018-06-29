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

# Setup php.ini file
# Set timeszone for test that use date
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

# Install PHP Code Sniffer
RUN mkdir -p /root/src \
    && cd /root/src \
    && wget https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar \
    && wget https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar \
    && chmod +x phpcs.phar \
    && chmod +x phpcbf.phar \
    && mv phpcs.phar /usr/local/bin/phpcs \
    && mv phpcbf.phar /usr/local/bin/phpcbf \
    && phpcs --version \
    && phpcbf --version \
    && mkdir /usr/phpcs_standards \
    && git clone https://github.com/wimg/PHPCompatibility.git /usr/phpcs_standards/PHPCompatibility \
    && git clone --branch 7.x-2.x https://git.drupal.org/project/coder.git /usr/phpcs_standards/coder/coder_sniffer \
    && rm -rf /root/src \
    && phpcs --config-set installed_paths /usr/phpcs_standards/PHPCompatibility \
#    && phpcs --config-set installed_paths /usr/phpcs_standards/coder/coder_sniffer \
    && phpcs -i
