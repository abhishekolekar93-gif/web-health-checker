
FROM alpine:3.22

RUN apk add --no-cache bash curl coreutils procps

WORKDIR /app

COPY monitor.sh /app/monitor.sh

RUN chmod +x /app/monitor.sh

CMD ["/bin/bash", "/app/monitor.sh"]
