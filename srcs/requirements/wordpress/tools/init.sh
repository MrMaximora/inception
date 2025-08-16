#!/bin/sh
set -e

# Use correct PHP path for WP-CLI
ln -sf /usr/bin/php82 /usr/bin/php

# Wait for MariaDB to be ready
echo "Attente de MariaDB..."
until mariadb -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1" >/dev/null 2>&1; do
    echo "MariaDB non disponible, attente 2s..."
    sleep 2
done
echo "MariaDB disponible !"

# WordPress installation
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Téléchargement et configuration de WordPress..."
    curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz
    tar -xzf wordpress.tar.gz --strip-components=1 -C /var/www/html
    rm wordpress.tar.gz

    wp config create --path=/var/www/html \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$MYSQL_HOST" \
        --allow-root

    wp core install --path=/var/www/html \
        --url="$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --allow-root
fi

# Lancer PHP-FPM
php-fpm82 -F
