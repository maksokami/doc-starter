#!/bin/bash

docker stop nginx
docker rm nginx

docker image rm owasp/modsecurity-crs:nginx
docker pull owasp/modsecurity-crs:nginx:latest
./nginx-start.sh
