#!/bin/sh

# Ensure /run/mysqld exists
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chmod 755 /run/mysqld

# Checks if MySQL database is already initialized
if [ -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "[i] MySQL directory already present, skipping creation"
else
    echo "[i] Initializing database..."
    chown -R mysql:mysql /var/lib/mysql

# Create a temportaire file to initialize the database 
    tfile=$(mktemp)
    if [ ! -f "$tfile" ]; then
        echo "Failed to create temp file"
        exit 1
    fi

    # Configuration database
    # Create User
    cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;
GRANT ALL ON *.* TO 'root'@'%'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    #Initialize database
    echo "[i] Starting temporary MariaDB server..."
    /usr/sbin/mysqld --user=mysql < $tfile
    rm -f $tfile
fi

mysql_install_db --user=mysql --ldata=/var/lib/mysql 2>/dev/null || true

echo "[i] MariaDB setup complete. Starting MariaDB server..."
# run database
exec /usr/sbin/mysqld --user=mysql --console --skip-networking=0 --bind-address=0.0.0.0
