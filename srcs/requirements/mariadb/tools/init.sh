#!/bin/sh
set -e

# Paths
SOCKET="/run/mysqld/mysqld.sock"
DATADIR="/var/lib/mysql"

# Ensure runtime dir exists
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Initialize database if empty
if [ ! -d "$DATADIR/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir="$DATADIR" --skip-test-db
fi

# Start MariaDB in background
echo "Starting temporary MariaDB server..."
mysqld --user=mysql --skip-networking=0 --skip-bind-address=0 --datadir="$DATADIR" &
pid="$!"

# Wait until MariaDB is ready (via UNIX socket, root only works here)
until mariadb -u root --protocol=socket -e "SELECT 1" >/dev/null 2>&1; do
    echo "Waiting for MariaDB server..."
    sleep 2
done
echo "MariaDB is ready!"

# Run setup SQL
mariadb -u root --protocol=socket <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOSQL

# Shutdown temporary server
echo "Stopping temporary MariaDB..."
kill -15 "$pid"
wait "$pid"

# Start MariaDB in foreground (normal mode)
echo "Launching MariaDB in foreground..."
exec mysqld
