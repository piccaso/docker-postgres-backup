#!/bin/sh
echo "$CRONSCHEDULE $PGDUMPCMD $PGDUMPOPTIONS" | crontab -
crond -f -d -L /dev/stdout
