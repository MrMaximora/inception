#!/bin/sh
set -e

DATA_DIR="/usr/local/mysql/var"

if [ ! -d "$DATA_DIR/mysql" ]; then
    chown -R mysql:mysql "$DATA_DIR"

    # Initialize database without root password
    mysqld --user=mysql --datadir="$DATA_DIR"

    # Start MariaDB in the background
    mysqld_safe --datadir="$DATA_DIR" &
    pid="$!"

    sleep 5

    # Secure root everywhere
    mariadb -h127.0.0.1 -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mariadb -h127.0.0.1 -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mariadb -h127.0.0.1 -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"

    # Create WordPress database and user
    mariadb -h127.0.0.1 -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mariadb -h127.0.0.1 -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mariadb -h127.0.0.1 -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"

    mariadb -h127.0.0.1 -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

    # Shutdown temporary MariaDB
    mysqladmin -h127.0.0.1 -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
fi

# Start MariaDB in foreground
exec mysqld_safe --datadir="$DATA_DIR"
