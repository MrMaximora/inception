FROM debian:bookworm

# Install MariaDB
RUN apt-get update && apt-get install -y mariadb-server mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Copy init script
COPY ./tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Create mysql user & group if not already in image
RUN chown -R mysql:mysql /var/lib/mysql

# Expose MariaDB port
EXPOSE 3306

# Run init script (entrypoint)
ENTRYPOINT ["/usr/local/bin/init.sh"]
