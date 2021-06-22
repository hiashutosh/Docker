FROM php:8.0-fpm
RUN set -ex; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
                libfreetype6-dev \
                libjpeg-dev \
                libpng-dev \
                libzip-dev \
        ; \
        \
        docker-php-ext-configure gd \
                --with-freetype \
                --with-jpeg \
        ; \
        docker-php-ext-install \
                gd \
                mysqli \
                zip;
RUN set -eux; \
    curl -o wordpress.tar.gz -fL "https://wordpress.org/latest.tar.gz"; \
    tar -xzf wordpress.tar.gz -C /usr/src/; \
    rm wordpress.tar.gz; \
    chown -R www-data:www-data /var/www/html
VOLUME /var/www/html

COPY --chown=www-data:www-data wp-config.php /usr/src/
COPY entrypoint.sh /usr/local/bin/

ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm"]