FROM alpine:3.21

RUN apk update && apk add --no-cache nginx openssl

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/ssl.sh /ssl.sh

RUN mkdir -p /etc/nginx/ssl && chmod +x /ssl.sh && /ssl.sh

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]