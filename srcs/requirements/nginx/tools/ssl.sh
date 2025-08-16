#!/bin/sh
set -e

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/selfsigned.key \
  -out /etc/nginx/ssl/selfsigned.crt \
  -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=Student/CN=$DOMAIN_NAME"