FROM alpine:3.14

RUN ["apk", "update"]
RUN ["apk", "upgrade"]

RUN ["apk" ,"add", "--no-cache", "nginx"]

RUN ["rm", "-rf", "/etc/nginx/http.d/default.conf"]
COPY ["conf/nginx.conf", "/etc/nginx/nginx.conf"]

RUN	[ "apk", "add", "openssl" ]
RUN	[ "mkdir", "-p", "/etc/nginx/ssl" ]

RUN ["openssl", "req", "-x509", "-nodes", "-out", "/etc/nginx/ssl/inception.crt", "-keyout", "/etc/nginx/ssl/inception.key", "-subj", "/C=FR/ST=Charente/L=Angouleme/O=42/OU=42/CN=Inception/UID=maxouvra"]

CMD ["nginx", "-g", "daemon off;"]