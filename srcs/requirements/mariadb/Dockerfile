FROM debian:bookworm

# Install MariaDB and OpenRC
RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Remove default config if needed and copy custom config
RUN rm -f /etc/mysql/mariadb.conf.d/50-server.cnf
COPY conf/mariadb.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Create runtime directories
RUN mkdir -p /run/mysqld /usr/local/mysql \
    && chown -R mysql:mysql /run/mysqld /usr/local/mysql

# Copy initialization script
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

# Expose MariaDB port
EXPOSE 3306

# Start MariaDB via your init script
ENTRYPOINT ["/init.sh"]
