#!/bin/sh
set -e  # Stop script on error

mkdir -p /var/www/html
cd /var/www/html

# Check if WordPress is already installed
if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."
    wp.phar core download --allow-root

    echo "Creating wp-config.php..."
    wp.phar config create --dbname="$MARIADB_DATABASE" --dbuser="$MARIADB_USERNAME" \
        --dbpass="$MARIADB_PASSWORD" --dbhost="mariadb" --allow-root

    echo "Installing WordPress..."
    wp.phar core install --url="maxouvra.42.fr" --title="Inception" \   
        --admin_user="$ADMIN_USERNAME" --admin_password="$ADMIN_PASSWORD" \
        --admin_email="$ADMIN_MAIL" --allow-root

    echo "Creating additional user..."
    wp.phar user create "$USER_USERNAME" "$USER_MAIL" --role=author --user_pass="$USER_PASSWORD" --allow-root

    echo "Configuring WordPress debugging..."
    wp.phar config set WP_DEBUG true --raw --allow-root
    wp.phar config set WP_DEBUG_LOG true --raw --allow-root
    wp.phar config set WP_DEBUG_DISPLAY false --raw --allow-root

    echo "Installing and enabling Redis..."
    wp.phar plugin is-installed redis-cache || wp.phar plugin install redis-cache --activate --allow-root
    wp.phar redis enable --allow-root

    echo "Fixing permissions..."
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html
fi

echo "Starting PHP-FPM..."
exec php-fpm82 -F
