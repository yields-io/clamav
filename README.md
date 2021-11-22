# ClamAV

[ClamAV] docker environment. This environment is packaged in all Yields
Amazon Machine Images >= 22112021.

## Scan files

Deploy clamav:

```lang-shell
docker-compose up -d
```

Scan files:
```lang-shell
docker-compose run --rm -v /:/rootfs --entrypoint clamscan clamav -i -r --stdout /rootfs
```


[ClamAV]: https://www.clamav.net/
