#!/bin/sh
set -e

echo "✅ Starting Xray..."
xray run -c /etc/xray/config.json &

sleep 6

echo "✅ Starting Nginx..."
nginx -g "daemon off;"
