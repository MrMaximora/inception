# WordPress Dockerfile
FROM debian:bookworm

# Install PHP 8.2 and required extensions, MariaDB client, wget, etc.
RUN apt-get update && apt-get install -y \
    php8.2 \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-curl \
    php8.2-mbstring \
    php8.2-phar \
    mariadb-client \
    curl \
    tar \
    sudo \
    unzip \
    less \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Copy PHP-FPM config
COPY conf/php.conf /etc/php/8.2/fpm/php-fpm.conf

# Install WP-CLI
# Installer WP-CLI
RUN curl -o /usr/local/bin/wp.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp.phar \
    && ln -s /usr/local/bin/wp.phar /usr/local/bin/wp

# Create WordPress directory and set permissions
RUN mkdir -p /var/www/html /var/log/php8.2 \
    && chown -R www-data:www-data /var/www/html /var/log/php8.2

# Copy init script
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 9000

ENTRYPOINT ["/init.sh"]
