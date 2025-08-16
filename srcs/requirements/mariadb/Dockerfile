FROM alpine:3.21

# Installer MariaDB + PHP + bash
RUN apk update && apk add --no-cache \
    mariadb mariadb-client \
    less

# Copier le script d'init
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

# Créer le répertoire pour le socket MariaDB
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

USER mysql

EXPOSE 3306

ENTRYPOINT ["/init.sh"]
