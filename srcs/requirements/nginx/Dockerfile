FROM debian:bookworm

# Install packages with apt instead of apk
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Copy configs and scripts
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/ssl.sh /ssl.sh

# Make SSL script executable and run it
RUN mkdir -p /etc/nginx/ssl && chmod +x /ssl.sh && /ssl.sh

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]