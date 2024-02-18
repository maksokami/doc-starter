#!/bin/bash

echo $0

docker run -d -p 80:80  -p 443:443 --name nginx --rm \
   -e PARANOIA=1 \
   --memory=1g \
   -e EXECUTING_PARANOIA=2 \
   -e ENFORCE_BODYPROC_URLENCODED=1 \
   -e ANOMALY_INBOUND=10 \
   -e ANOMALY_OUTBOUND=5 \
   -e ALLOWED_METHODS="GET POST PUT" \
   -e ALLOWED_REQUEST_CONTENT_TYPE="|text/xml|application/xml|text/plain|" \
   -e ALLOWED_REQUEST_CONTENT_TYPE_CHARSET="utf-8|iso-8859-1" \
   -e ALLOWED_HTTP_VERSIONS="HTTP/1.1 HTTP/2 HTTP/2.0" \
   -e RESTRICTED_EXTENSIONS=".cmd/ .com/ .config/ .dll/" \
   -e RESTRICTED_HEADERS="/proxy/ /if/" \
   -e STATIC_EXTENSIONS="/.jpg/ /.jpeg/ /.png/ /.gif/" \
   -e MAX_NUM_ARGS=128 \
   -e ARG_NAME_LENGTH=50 \
   -e ARG_LENGTH=200 \
   -e TOTAL_ARG_LENGTH=6400 \
   -e MAX_FILE_SIZE=100000 \
   -e COMBINED_FILE_SIZES=1000000 \
   -e TIMEOUT=60 \
   -e LOGLEVEL=warn \
   -e ERRORLOG='/proc/self/fd/2' \
   -e SERVER_ADMIN=test@localhost \
   -e SERVER_NAME=test.duckdns.org \
   -e PORT=80 \
   -e SSL_PORT=443 \
   -e PROXY=1 \
   -e MODSEC_RULE_ENGINE=On \
   -e MODSEC_REQ_BODY_ACCESS=on \
   -e MODSEC_REQ_BODY_LIMIT=13107200 \
   -e MODSEC_REQ_BODY_NOFILES_LIMIT=131072 \
   -e MODSEC_RESP_BODY_ACCESS=on \
   -e MODSEC_RESP_BODY_LIMIT=524288 \
   -e MODSEC_PCRE_MATCH_LIMIT=1000 \
   -e MODSEC_PCRE_MATCH_LIMIT_RECURSION=1000 \
   -e VALIDATE_UTF8_ENCODING=1 \
   -e CRS_ENABLE_TEST_MARKER=1 \
-v /home/your-user/nginx-container-config/letsencrypt/live/test.duckdns.org/fullchain.pem:/etc/nginx/conf/server.crt \
-v /home/your-user/nginx-container-config/letsencrypt/live/test.duckdns.org/privkey.pem:/etc/nginx/conf/server.key \
-v /home/your-user/nginx-container-config/default.conf:/etc/nginx/templates/conf.d/default.conf.template \
-v /home/your-user/nginx-container-config/www:/usr/share/nginx/html \
-v /home/your-user/nginx-container-config/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf:/etc/modsecurity.d/owasp-crs/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf \
--restart=unless-stopped \
owasp/modsecurity-crs:nginx
