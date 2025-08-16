FROM alpine:3.21

# Installer les paquets nécessaires
RUN apk add --no-cache mariadb-client php82 php82-fpm php82-mysqli php82-curl php82-mbstring php82-json php82-openssl php82-phar bash curl tar

# Installer WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier scripts et conf
COPY tools/init.sh /init.sh
COPY conf/php.conf /etc/php82/php-fpm.conf

# Rendre le script exécutable
RUN chmod +x /init.sh

# Exposer le port de PHP-FPM
EXPOSE 9000

# Entrypoint
ENTRYPOINT ["/init.sh"]
