FROM teddysun/xray:latest AS xray-bin
FROM envoyproxy/envoy:v1.31.10
COPY --from=xray-bin /usr/bin/xray /usr/local/bin/
RUN chmod +x /usr/local/bin/xray
COPY config.json /etc/xray.json
COPY envoy.yaml /etc/envoy/envoy.yaml
EXPOSE 8080
CMD ["/bin/sh", "-c", "xray run -c /etc/xray.json & sleep 3 && exec envoy -c /etc/envoy/envoy.yaml --log-level warn"]
