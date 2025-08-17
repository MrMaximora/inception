#!/bin/sh
set -e

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
until mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1;" >/dev/null 2>&1; do
    echo "MariaDB not ready yet, sleeping..."
    sleep 2
done
echo "MariaDB is ready!"

# Initialize WordPress if not already done
if [ ! -f /var/www/html/wp-config.php ]; then
    cd /var/www/html

    # Download WordPress if not present
    if [ ! -f index.php ]; then
        php -d memory_limit=512M /usr/local/bin/wp.phar core download --allow-root
    fi

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

    cd /
fi

# Start PHP-FPM in foreground
exec php-fpm8.2 -F
