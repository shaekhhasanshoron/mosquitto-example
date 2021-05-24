FROM eclipse-mosquitto:2.0-openssl

ENV USERNAME=mosquitto
ENV PASSWORD=mosquitto

RUN apk upgrade --update-cache --available && \
    apk add openssl && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /mosquitto/certs

COPY ./config/. /mosquitto/config/.

COPY ./rootfs/docker-entrypoint.sh ./rootfs/passwordfile-generator.sh /

RUN chmod +x docker-entrypoint.sh
RUN chmod +x passwordfile-generator.sh

RUN chown -R mosquitto:mosquitto /mosquitto

USER mosquitto