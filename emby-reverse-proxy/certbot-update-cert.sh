#!/bin/bash

docker run --rm \
-e PUID=1000 \
-e PGID=1000 \
-v /home/your-user/nginx-container-config/letsencrypt:/etc/letsencrypt \
-v /home/your-user/nginx-container-config/www:/tmp/letsencrypt \
-v /home/your-user/nginx-container-config/certbot-log:/var/log certbot/certbot renew

docker exec nginx nginx -s reload
