# Kuhaon ang Xray
FROM ghcr.io/xtls/xray-core:latest AS xray

# Base nga OpenResty
FROM openresty/openresty:alpine

# Ibutang ang gikinahanglan
COPY --from=xray /usr/bin/xray /usr/local/bin/xray
RUN chmod +x /usr/local/bin/xray && \
    apk add --no-cache ca-certificates

# Ibutang ang mga config
COPY config.json /etc/xray/config.json
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

# Port
EXPOSE 8080

# Saktong pagsugod
CMD ["/bin/sh", "-c", "set -e; xray run -c /etc/xray/config.json & sleep 6; openresty -g 'daemon off;'"]
