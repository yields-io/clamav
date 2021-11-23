# ClamAV

[ClamAV] docker environment. This environment is packaged in all Yields
Amazon Machine Images >= 22112021.

## Scan files

### [One-Time Scanning]

Scan files:
```lang-shell
docker-compose run --rm -v /:/rootfs:ro --entrypoint clamscan clamav -i -r --stdout /rootfs
```

#### Configuration

Ad-hoc `clamscan` configuration options can set in the command, e.g.
`--exclude-dir=REGEX` to exlude a directory matching `REGEX` from the scan.

> Use `clamscan --help` to show all options available for `clamscan`.

### [ClamDScan]

Create the clamd volume:
```lang-shell
docker volume create clamd
docker run --rm -it --entrypoint chown -v clamd:/clamd alpine:3 -R 100:101 /clamd
```

Set the environment and run `clamdscan`:
```lang-shell
export COMPOSE_FILE="docker-compose.yml:docker-compose.clamd.yml"
docker-compose up -d
docker-compose run --rm --entrypoint clamdscan clamav --fdpass --stdout -v /rootfs
```

> The hosts `/` (root) directory is bind-mounted as read-only at `/rootfs`
> in clamav container.

#### Configuration

##### Listener

The ClamAV server listens on the recommended `LocalSocket`.

##### ExcludePath

The following directories are recursively excluded from scans:
- `/rootfs/proc/`
- `/rootfs/sys/`
- `/rootfs/dev/`
- `/rootfs/media/`
- `/rootfs/mnt/`
- `/rootfs/var/lib/containerd/`
- `/rootfs/var/lib/docker/overlay2/`
- `/rootfs/var/lib/lxcfs/cgroup/`
- `/rootfs/snap/`


[ClamAV]: https://www.clamav.net/
[ClamDScan]: https://docs.clamav.net/manual/Usage/Scanning.html#clamdscan
[One-Time Scanning]: https://docs.clamav.net/manual/Usage/Scanning.html#clamscan
