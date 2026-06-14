#!/bin/sh
set -e
PORT="${PORT:-8080}"
# Paghimo og valid certificate
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /tmp/srv.key -out /tmp/srv.crt -subj "/CN=localhost"
# Sugdi ang Xray
xray run -c /etc/xray.json &
# Sugdi ang Nginx uban ang saktong port ug certificate
exec /usr/local/openresty/bin/openresty -g "daemon off; error_log /dev/stdout info;" -c <(cat <<CONF
worker_processes auto;
worker_rlimit_nofile 1048576;
events { worker_connections 1048576; multi_accept on; use epoll; }
http {
  sendfile on; tcp_nopush on; tcp_nodelay on;
  keepalive_timeout 3600s; client_max_body_size 0;
  ssl_protocols TLSv1.2 TLSv1.3;
  ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
  server {
    listen 0.0.0.0:${PORT} ssl http2;
    listen [::]:${PORT} ssl http2;
    server_name _;
    ssl_certificate /tmp/srv.crt;
    ssl_certificate_key /tmp/srv.key;
    location / { proxy_pass https://www.google.com; proxy_set_header Host www.google.com; }
    location /trojan-jonathan {
      proxy_pass http://127.0.0.1:10001; proxy_http_version 1.1;
      proxy_set_header Upgrade \$http_upgrade; proxy_set_header Connection "upgrade";
      proxy_set_header Host \$host; proxy_read_timeout 86400s;
    }
    location /vless-jonathan {
      proxy_pass http://127.0.0.1:10002; proxy_http_version 1.1;
      proxy_set_header Upgrade \$http_upgrade; proxy_set_header Connection "upgrade";
      proxy_set_header Host \$host; proxy_read_timeout 86400s;
    }
  }
}
CONF
)
