FROM alpine:3.20

RUN ["apk", "update"]
RUN ["apk", "upgrade"]

RUN		["apk", "add", "mysql", "mariadb", "mariadb-client", "mariadb-server-utils"]
RUN		["apk", "add", "openrc"]

RUN		["rm", "-f", "/etc/my.cnf.d/mariadb-server.cnf"]
COPY	["conf/mariadb.conf", "/etc/my.cnf.d/mariadb-server.cnf"]