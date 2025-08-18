# WordPress Dockerfile
FROM debian:bookworm

# Install PHP 8.2 and required extensions, MariaDB client, wget, etc.
RUN apt-get update && apt-get install -y \
    php8.2 \
    php8.2-fpm \
    php8.2-mysql \
    mariadb-client \
    curl

# Copy PHP-FPM config
COPY conf/php.conf /etc/php/8.2/fpm/php-fpm.conf

# Copy init script
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 9000

ENTRYPOINT ["/init.sh"]
