#!/bin/bash

docker run --rm \
-v /home/your-user/nginx-container-config/letsencrypt:/etc/letsencrypt \
   -v /home/your-user/nginx-container-config/www:/tmp/letsencrypt \
   -v /home/your-user/nginx-container-config/certbot-log:/var/log \
   -e PUID=1000 \
   -e PGID=1000 \
   certbot/certbot \
   certonly \
   --webroot \
   --agree-tos \
   --renew-by-default \
   --preferred-challenges http-01 \
   --email YOUR_VALID_EMAIL@mail.com\
   --webroot-path /tmp/letsencrypt \
   -d test.duckdns.org
