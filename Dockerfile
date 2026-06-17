FROM teddysun/xray:latest AS xray-bin
FROM openresty/openresty:alpine-fat

COPY --from=xray-bin /usr/bin/xray /usr/local/bin/xray
RUN chmod +x /usr/local/bin/xray

COPY config.json /etc/xray.json
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

EXPOSE 8080

CMD ["/bin/sh", "-c", "openresty -g 'daemon off;' & xray run -c /etc/xray.json"]
