ARG BUILD_FROM
FROM $BUILD_FROM

ARG SEAT_VERSION
ARG SKODA_VERSION
ARG VW_VERSION
ARG TRIONITY_VERSION
ARG MQTT_VERSION
ARG MQTTHA_VERSION

WORKDIR /tmp/
ADD carconnectivity.json.gtpl .
ADD entrypoint.sh .

RUN apk add --no-cache python3 py3-pip build-base libffi-dev && \
    python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip --no-cache && \
    /opt/venv/bin/pip install --no-cache carconnectivity-connector-seatcupra==${SEAT_VERSION} \
        carconnectivity-connector-skoda==${SKODA_VERSION} \
        carconnectivity-connector-volkswagen==${VW_VERSION} \
        carconnectivity-connector-tronity==${TRIONITY_VERSION} \
        carconnectivity-plugin-mqtt_homeassistant==${MQTTHA_VERSION} && \
    echo "SEAT_VERSION=${SEAT_VERSION}" > versions.txt && \
    echo "SKODA_VERSION=${SKODA_VERSION}" >> versions.txt && \
    echo "VW_VERSION=${VW_VERSION}" >> versions.txt && \
    echo "TRIONITY_VERSION=${TRIONITY_VERSION}" >> versions.txt && \
    echo "MQTT_VERSION=${MQTT_VERSION}" >> versions.txt && \
    echo "MQTTHA_VERSION=${MQTTHA_VERSION}" >> versions.txt && \
    chmod +x /tmp/entrypoint.sh && \
    touch /tmp/carconnectivity.token && \
    apk del build-base libffi-dev && \
    rm -rf /var/cache/apk/*

ARG BUILD_ARCH
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_VERSION

LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION}

ENTRYPOINT ["/bin/sh", "-c", "/tmp/entrypoint.sh"]