#!/bin/sh
set -e
# Gamita ang PORT nga gihatag sa Cloud Run
PORT="${PORT:-8080}"

# Usba ang port sa Nginx aron maminaw sa $PORT ug sa TANANG interface
sed -i "s|listen 8080 ssl http2;|listen 0.0.0.0:${PORT} ssl http2;|g" /usr/local/openresty/nginx/conf/nginx.conf
sed -i "s|listen \[::\]:8080 ssl http2;|listen [::]:${PORT} ssl http2;|g" /usr/local/openresty/nginx/conf/nginx.conf

# Sugdi ang Xray
xray run -c /etc/xray.json &

# Sugdi ang OpenResty
exec /usr/local/openresty/bin/openresty -g "daemon off;"
