FROM alpine:3.20

RUN ["apk", "update"]
RUN ["apk", "upgrade"]

RUN	["apk", "add", \
"php82", \
"php82-fpm", \
"php82-mysqli", \
"php82-json", \
"php82-curl", \
"php82-dom", \
"php82-exif", \
"php82-fileinfo", \
"php82-mbstring", \
"php82-openssl", \
"php82-xml", \
"php82-zip", \
"php82-mbstring", \
"php82-phar", \
"php82-redis", \
"php82-tokenizer", \
"php82-ctype"]

RUN	["apk", "add", "mariadb-client"]
RUN ["apk", "add", "wget", "tar", "sudo"]

RUN	["rm", "-rf", "/etc/php82/php-fpm.d/www.conf"]
ADD	["conf/www.conf", "/etc/php82/php-fpm.d/www.conf"]

RUN	["wget", "https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar"]
RUN	["chmod", "+x", "wp-cli.phar"]
RUN	["mv", "wp-cli.phar", "/usr/local/bin/wp.phar"]
RUN	["mkdir", "-p", "/var/www"]
RUN	["mkdir", "-p", "/var/www/html"]

ADD ["tools/wordpress.sh", "."]
RUN ["chmod", "+x", "wordpress.sh"]
CMD	["./wordpress.sh"]