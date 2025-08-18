#!/bin/sh

# Ensure /run/mysqld exists
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chmod 755 /run/mysqld

# Checks if MySQL database is already initialized
if [ -d "/var/lib/mysql/${MARIADB_DATABASE}" ]; then
    echo "[i] MySQL directory already present, skipping creation"
else
    echo "[i] Initializing database..."
    chown -R mysql:mysql /var/lib/mysql

    # Initialize system tables
    mysql_install_db --user=mysql --ldata=/var/lib/mysql 2>/dev/null || true

    echo "[i] Starting temporary MariaDB server..."
    /usr/sbin/mysqld --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
    pid="$!"

    # Wait until server is ready
    until mysqladmin ping --socket=/run/mysqld/mysqld.sock --silent; do
        sleep 1
    done

    # Create temp SQL file
    tfile=$(mktemp)
    cat << EOF > "$tfile"
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}' WITH GRANT OPTION;
GRANT ALL ON *.* TO 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}' WITH GRANT OPTION;
CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO '${MARIADB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    # Run SQL setup
    mysql --protocol=socket -uroot < "$tfile"
    rm -f "$tfile"

    # Stop temporary server
    kill "$pid"
    wait "$pid"
fi

echo "[i] MariaDB setup complete. Starting MariaDB server..."
# run database with external connections allowed
exec /usr/sbin/mysqld --user=mysql --console --bind-address=0.0.0.0
