# [0xff/postgres-backup](https://hub.docker.com/r/0xff/postgres-backup)
A (very) simple daily backup solution for PostgreSQL.
Built around [dcron](https://github.com/dubiousjim/dcron) and [`pg_dump`](https://www.postgresql.org/docs/current/app-pgdump.html)   
in a very small package - thanks to [Alpine](https://alpinelinux.org/).


## Usage
with docker-compose
```
version: "2.2"
services:
  db:
    image: postgres:11-alpine
    environment:
      POSTGRES_PASSWORD: "9p4O6ICIGf9hmdA1GJFwDN8"
  backup:
    image: 0xff/postgres-backup
    environment:
      PGPASSWORD: "9p4O6ICIGf9hmdA1GJFwDN8"
    volumes:
      - ./pg-backups:/pg-backups
```
And you will have a daly backup in `./pg-backups` for 7 days.  
After that, old backups will be overwritten.  
This can be customized to some extent by environment variables.  
See [Dockerfile](./Dockerfile) for defaults.  
[`libpq` environment variables](https://www.postgresql.org/docs/current/libpq-envars.html) will also be passed on.  

## Advanced usage
By default backups are made as SQL dumps, wich is nice for readability but might not be what you want.  
In that case you may want to use a different format, for example `tar`.  
You can do so by changing the `PGDUMPOPTIONS` environment variable like:
```
  backup:
    environment:
      PGDUMPOPTIONS: "-F t -f /pg-backups/backup-$$(date +%u).tar"
```
The example above is for a `docker-compose.yml` file where you have to use `$$` in order to write a single dollar sign.  

For a full example of using the `custom` format please have a look at [example.yml](./example.yml).  
## Restore
`docker exec` into the container and use [`pg_restore`](https://www.postgresql.org/docs/current/app-pgrestore.html) or [`psql`](https://www.postgresql.org/docs/current/app-psql.html).

### pg_restore with tar or custom format.  
Inspect backup:
```sh
docker-compose exec backup pg_restore -l /pg-backups/backup-1.tar
```
Restore - **and thereby destroy existing data** - backup into `postgres` database:
```sh
docker-compose exec backup pg_restore -d postgres --clean --if-exists /pg-backups/backup-1.tar
```

### psql for sql dumps
By default sql dumps are created with `--clean --if-exists` wich will **ovrwrite existing data** in this case.
```sh
docker-compose exec backup psql -f /pg-backups/backup-1.sql
```

## Why
I really tried hard to find a simple postgres-backup solution but I did not find any.  
If someone finds something similar please drop me a line - i'd appreciate it.

