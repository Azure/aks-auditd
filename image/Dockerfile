FROM  alpine:latest
ADD ./app/* /app/
ADD ./entrypoint.sh /entrypoint.sh

VOLUME /node
VOLUME /audit-rules
VOLUME /oms-config
VOLUME /audisp-plugins

CMD ["/entrypoint.sh"]

