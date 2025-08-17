FROM debian:bookworm

# Install MariaDB and OpenRC
RUN apt-get update && \
    apt-get upgrade && \
    apt-get install -y mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# Copy initialization script
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

USER root

# Start MariaDB via your init script
ENTRYPOINT ["/init.sh"]
