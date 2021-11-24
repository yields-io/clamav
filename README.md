# ClamAV

[ClamAV] docker environment.

## Prerequisites

- [docker]
- [docker-compose]

## Scan files

### [One-Time Scanning]

Scan files using `clamscan`:
```lang-shell
docker-compose run --rm -v /:/rootfs:ro --entrypoint clamscan clamav -i -r --stdout /rootfs
```

#### Configuration

Ad-hoc `clamscan` configuration options can be set in the command, e.g.
`--exclude-dir=REGEX` to exlude a directory matching `REGEX` from the scan:

```lang-shell
docker-compose run --rm -v /:/rootfs:ro --entrypoint clamscan \
    clamav -i -r --stdout /rootfs --exclude-dir=/rootfs/sys --exlude-dir=/rootfs/proc
```

> Use `clamscan --help` to show all options available for `clamscan`.

### [ClamDScan]

Create the clamd volume:
```lang-shell
docker volume create clamd
docker run --rm -it --entrypoint chown -v clamd:/clamd alpine:3 -R 100:101 /clamd
```

Set the environment, start the services, and scan files using `clamdscan`:
```lang-shell
export COMPOSE_FILE="docker-compose.yml:docker-compose.clamd.yml"
docker-compose up -d
docker-compose run --rm --entrypoint clamdscan clamav --fdpass --stdout -v /rootfs
```

> The hosts `/` (root) directory is bind-mounted as read-only at `/rootfs`
> in the clamav container.

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

## Deployment

### Local

ClamAV can be deployed locally using `docker-compose`:

1. Clone the [yields-io/clamav] repository
1. (Optional) update the `etc/clamd/clam.conf` for your PC
1. Set `COMPOSE_FILE=docker-compose.yml:docker-compose.clamd.yml` in the
   projects `.env` file
1. Start the services using docker-compose, e.g.: `docker-compose up -d`
1. (Optional) create a cronjob to scan the hosts files, e.g.:

```lang-shell
@daily /home/ubuntu/.local/bin/docker-compose -f /usr/local/docker/clamav/docker-compose.yml -f /usr/local/docker/clamav/docker-compose.clamd.yml run --rm --entrypoint clamdscan clamav --multiscan --stdout --fdpass /rootfs
```

### AWS

ClamAV can be deployed to existing Yields managed AWS instances using
the [clamav.yaml] ansible-playbook in the [yields-io/aws] repository, e.g.:

```lang-shell
docker run --rm -it \
    -u ubuntu \
    -e AWS_DEFAULT_REGION=eu-west-1 \
    -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
    -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
    -v ${HOME}/.ssh:/home/ubuntu/.ssh \
    -v ${PWD}/.ansible:/.ansible \
    -v ${PWD}/etc/ansible:/etc/ansible \
    --entrypoint ansible-playbook \
    -v ${PWD}/playbook.yaml:/playbook.yaml \
    build.yields.io/ansible:v4.0.0 /playbook.yaml -i /etc/ansible/aws_ec2.yaml --user ubuntu --ssh-common-args='-o ProxyCommand="ssh -p 2222 bastion.yields.io -W [%h]:%p" -o StrictHostKeyChecking=no' --extra-vars target=all:\!tag_ClamAV_disabled
```


[AMIs]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html
[ClamAV]: https://www.clamav.net/
[clamav.yaml]: https://github.com/yields-io/aws/blob/clamav/playbooks/clamav.yaml
[ClamDScan]: https://docs.clamav.net/manual/Usage/Scanning.html#clamdscan
[docker]: https://docs.docker.com/get-docker/
[docker-compose]: https://docs.docker.com/compose/install/
[One-Time Scanning]: https://docs.clamav.net/manual/Usage/Scanning.html#clamscan
[yields-io/aws]: https://github.com/yields-io/aws
[yields-io/clamav]: https://github.com/yields-io/clamav
