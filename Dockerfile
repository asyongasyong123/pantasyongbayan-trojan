# Stage 1: Kuhaon ang Xray
FROM alpine:3.19 AS xray-bin
RUN apk add --no-cache curl unzip ca-certificates
WORKDIR /tmp
RUN curl -fL https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o xray.zip \
 && unzip -q xray.zip xray \
 && chmod +x xray \
 && mv xray /usr/local/bin/xray \
 && rm -rf /tmp/*

# Stage 2: Base nga OpenResty nga naay gRPC
FROM openresty/openresty:alpine

# I-install ang gRPC module ug mga kinahanglanon
RUN apk update && apk add --no-cache \
    ca-certificates \
    bash \
    nginx-mod-http-grpc

# Ibutang ang Xray
COPY --from=xray-bin /usr/local/bin/xray /usr/local/bin/xray
RUN chmod +x /usr/local/bin/xray

# Ibutang ang tanang config
COPY config.json /etc/xray/config.json
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# I-load ang gRPC module
RUN echo "load_module modules/ngx_http_grpc_module.so;" >> /usr/local/openresty/nginx/conf/nginx.conf

ENV PORT=8080
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
