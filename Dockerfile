FROM php:7.2-cli

RUN apt-get update && apt-get -y install \
    curl \
    gnupg \
    libzip-dev \
    zip \
    rsync \
    ssh \
    && \
    curl -sL https://deb.nodesource.com/setup_11.x  | bash - && \
    apt-get -y install nodejs

# https://stackoverflow.com/a/48700777/486917
RUN docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-install zip
RUN pecl install redis-4.0.1 \
    && docker-php-ext-enable redis

# credit https://stackoverflow.com/a/42147748/486917
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
&& curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
# Make sure we're installing what we think we're installing!
&& php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
&& php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --snapshot \
&& rm -f /tmp/composer-setup.*
