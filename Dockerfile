FROM php:8.1-cli-buster

COPY --from=mlocati/php-extension-installer:1.5.8 /usr/bin/install-php-extensions /usr/local/bin/

RUN IPE_GD_WITHOUTAVIF=1 install-php-extensions gd zip redis gmp curl intl

RUN apt-get update && apt-get -y install \
    curl \
    zip \
    rsync \
    ssh \
    git \
    && \
    curl -sL https://deb.nodesource.com/setup_14.x  | bash - && \
    apt-get -y install nodejs

# yarn
RUN npm install --global yarn

# credit https://stackoverflow.com/a/42147748/486917
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
&& curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
# Make sure we're installing what we think we're installing!
&& php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
&& php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --snapshot \
&& rm -f /tmp/composer-setup.*
