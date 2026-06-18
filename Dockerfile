# Stage 1: Get Xray
FROM alpine:3.19 AS xray-bin
RUN apk add --no-cache curl unzip ca-certificates
WORKDIR /tmp
RUN curl -fL https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o xray.zip \
 && unzip xray.zip xray \
 && chmod +x xray \
 && mv xray /usr/local/bin/xray \
 && rm -rf /tmp/*

# Stage 2: OpenResty WITH gRPC SUPPORT
FROM openresty/openresty:alpine-fat
RUN apk add --no-cache ca-certificates bash nginx-mod-http-grpc

# Copy Xray
COPY --from=xray-bin /usr/local/bin/xray /usr/local/bin/xray
RUN chmod +x /usr/local/bin/xray

# Copy configs
COPY config.json /etc/xray/config.json
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV PORT=8080
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
