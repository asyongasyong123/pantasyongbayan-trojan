#!/bin/sh
set -e
PORT="${PORT:-8080}"
sed -i.bak "s|listen 8080 ssl http2;|listen 0.0.0.0:${PORT} ssl http2;|g" /usr/local/openresty/nginx/conf/nginx.conf
sed -i.bak "s|listen \[::\]:8080 ssl http2;|listen [::]:${PORT} ssl http2;|g" /usr/local/openresty/nginx/conf/nginx.conf
rm -f /usr/local/openresty/nginx/conf/nginx.conf.bak
xray run -c /etc/xray.json &
exec /usr/local/openresty/bin/openresty -g "daemon off;"
