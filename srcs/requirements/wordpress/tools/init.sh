#!/bin/sh

echo if mysqladmin ping -h "${MARIADB_HOST}" -u "${MARIADB_USER}" "--password=${MARIADB_PASSWORD}" --silent

mkdir -p /run/php

# to wait until MariaDB is available before proceeding
echo "Waiting for MariaDB to be available..."
for i in {1..60}; do
    if mysqladmin ping -h "${MARIADB_HOST}" -u "${MARIADB_USER}" "--password=${MARIADB_PASSWORD}" --silent; then
        echo "MariaDB is up."
        break
    else
        echo "MariaDB not available, retrying in 10 seconds..."
        sleep 10
    fi
done

# Download wordPress files 
if [ ! -f /usr/local/bin/wp ]; then
    echo "Downloading WP-CLI..."
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

    wp core download --allow-root

    # Create wp-config.php
    /usr/local/bin/wp.phar config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$MYSQL_HOST" \
        --allow-root

    # Install WordPress
    /usr/local/bin/wp.phar core install \
        --url="$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root

    # Create additional WordPress user
    /usr/local/bin/wp.phar user create \
        "$WP_USER" "$WP_USER_EMAIL" \
        --role=author \
        --user_pass="$WP_USER_PASSWORD" \
        --allow-root

    chmod -R 775 wp-content
fi

# Start PHP-FPM in foreground
exec php-fpm8.2 -F
