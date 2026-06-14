#!/bin/sh
set -e
PORT="${PORT:-8080}"
sed -i "s|listen 8080 ssl http2;|listen ${PORT} ssl http2;|g" /usr/local/openresty/nginx/conf/nginx.conf
sed -i "s|listen \[::\]:8080 ssl http2;|listen \[::\]:${PORT} ssl http2;|g" /usr/local/openresty/nginx/conf/nginx.conf
xray run -c /etc/xray.json &
exec /usr/local/openresty/bin/openresty -g "daemon off;"
