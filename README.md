# ClamAV

[ClamAV] docker environment. This environment is packaged in all Yields
Amazon Machine Images >= 22112021.

## Scan files

### [One-Time Scanning]

Scan files:
```lang-shell
docker-compose run --rm -v /:/rootfs:ro --entrypoint clamscan clamav -i -r --stdout /rootfs
```

### [ClamDScan]

Create the clamd volume:
```lang-shell
docker volume create clamd
docker run --rm -it --entrypoint chown -v clamd:/clamd alpine:3 -R 100:101 /clamd
```

```lang-shell
export COMPOSE_FILE="docker-compose.yml:docker-compose.clamd.yml"
docker-compose up -d
docker-compose run --rm --entrypoint clamdscan clamav --fdpass --stdout -v /rootfs
```


[ClamAV]: https://www.clamav.net/
[ClamDScan]: https://docs.clamav.net/manual/Usage/Scanning.html#clamdscan
[One-Time Scanning]: https://docs.clamav.net/manual/Usage/Scanning.html#clamscan
