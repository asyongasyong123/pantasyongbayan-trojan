# Stage 1: Kuhaon ang Xray
FROM alpine:3.19 AS xray-bin
RUN apk add --no-cache curl unzip ca-certificates
WORKDIR /tmp
RUN curl -fL https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o xray.zip \
 && unzip -q xray.zip xray \
 && chmod +x xray \
 && mv xray /usr/local/bin/xray \
 && rm -rf /tmp/*

# Stage 2: Base nga Nginx nga naay built-in gRPC support
FROM nginx:1.27-alpine

# Ibutang ang gikinahanglan
RUN apk add --no-cache ca-certificates bash

# Ibutang ang Xray
COPY --from=xray-bin /usr/local/bin/xray /usr/local/bin/xray
RUN chmod +x /usr/local/bin/xray

# Ibutang ang tanang config
COPY config.json /etc/xray/config.json
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV PORT=8080
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
