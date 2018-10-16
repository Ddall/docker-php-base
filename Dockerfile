# See https://github.com/docker-library/php/blob/master/7.1/fpm/Dockerfile
FROM php:7.2-fpm
ARG TIMEZONE="Europe/Paris"

RUN apt-get update && apt-get install -y \
    git \
    ssh \
    unzip \
    libxml2-dev \
    libxslt-dev \
    zlib1g-dev \
    libicu-dev \
    g++ \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

# Install PHPUnit
RUN curl -L https://phar.phpunit.de/phpunit.phar --output /usr/local/bin/phpunit.phar && chmod +x /usr/local/bin/phpunit.phar && ln -s /usr/local/bin/phpunit.phar /usr/local/bin/phpunit

# Set timezone
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone
RUN printf '[PHP]\ndate.timezone = "%s"\n', ${TIMEZONE} > /usr/local/etc/php/conf.d/tzone.ini
RUN "date"

# Install extensions
RUN docker-php-ext-install xsl json intl opcache

RUN echo 'alias sf="php bin/console"' >> ~/.bashrc
RUN echo 'alias ll="ls -alF"' >> ~/.bashrc
RUN echo 'alias la="ls -A"' >> ~/.bashrc
RUN echo 'alias l="ls -CF"' >> ~/.bashrc

WORKDIR /var/www/symfony
