FROM php:8.0-cli-buster

RUN apt-get update && apt-get -y install \
    curl \
    libcurl4-openssl-dev \
    gnupg \
    libzip-dev \
    libgmp-dev \
    zip \
    rsync \
    ssh \
    git \
    && \
    curl -sL https://deb.nodesource.com/setup_14.x  | bash - && \
    apt-get -y install nodejs

# https://stackoverflow.com/a/48700777/486917
RUN docker-php-ext-configure zip \
    && docker-php-ext-install zip
RUN pecl install redis-5.3.4 \
    && docker-php-ext-enable redis
RUN docker-php-ext-install gmp
RUN docker-php-ext-install curl

# yarn
RUN npm install --global yarn

# credit https://stackoverflow.com/a/42147748/486917
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
&& curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
# Make sure we're installing what we think we're installing!
&& php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
&& php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --snapshot \
&& rm -f /tmp/composer-setup.*
