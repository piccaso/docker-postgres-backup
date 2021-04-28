FROM alpine:latest
RUN apk add --no-cache postgresql-client dcron tini tzdata
ENV PGHOST="db" \
    PGUSER="postgres" \
    PGDATABASE="postgres" \
    PGDUMPCMD="pg_dump" \
    PGDUMPOPTIONS="--clean --if-exists -f /pg-backups/backup-$(date +%u).sql" \
    CRONSCHEDULE="0 2 * * *"

VOLUME /pg-backups
COPY ./cmd.sh /cmd.sh
HEALTHCHECK --interval=10s --timeout=5s --retries=5 CMD pg_isready
ENTRYPOINT ["/sbin/tini", "-g", "--"]
CMD /cmd.sh
