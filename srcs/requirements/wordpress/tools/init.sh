#!/bin/sh
set -e

mkdir -p /run/php

echo "Waiting for MariaDB to be available..."
for i in $(seq 1 60); do
    if mysqladmin ping -h "${MARIADB_HOST}" -u "${MARIADB_USER}" --password="${MARIADB_PASSWORD}" --silent; then
        echo "MariaDB is up."
        break
    else
        echo "MariaDB not available, retrying in 10 seconds..."
        sleep 10
    fi
done

# Download WP-CLI if not already installed
if [ ! -f /usr/local/bin/wp ]; then
    echo "Downloading WP-CLI..."
    curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x /usr/local/bin/wp
fi

if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Installing WordPress..."
    wp core download --allow-root
    wp config create \
        --dbname="$MARIADB_DATABASE" \
        --dbuser="$MARIADB_USER" \
        --dbpass="$MARIADB_PASSWORD" \
        --dbhost="$MARIADB_HOST" \
        --allow-root
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root
    wp user create \
        "$WP_USER" "$WP_USER_EMAIL" \
        --role=author \
        --user_pass="$WP_USER_PASSWORD" \
        --allow-root
    chmod -R 775 wp-content
else
    echo "WordPress already installed, skipping setup."
fi


# Start PHP-FPM in foreground
exec php-fpm8.2 -F
