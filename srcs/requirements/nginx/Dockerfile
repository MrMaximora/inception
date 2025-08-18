FROM debian:bookworm

RUN apt update -y && apt upgrade -y && \
    apt install -y nginx vim openssl && \
    mkdir -p /etc/nginx/ssl

RUN  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/selfsigned.key \
    -out /etc/nginx/ssl/selfsigned.crt \
    -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=Student/CN=$DOMAIN_NAME"

RUN mkdir -p /var/run/nginx /var/www/html
# Copy configs and scripts
COPY conf/nginx.cnf /etc/nginx/nginx.cnf

RUN chmod -R 755 /var/www/html && \
    chown -R www-data:www-data /var/www/html

CMD ["nginx", "-g", "daemon off;"]