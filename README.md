### Deploy

```bash
pip3 install ansible==2.9.*
ansible-playbook -i inventory.yaml playbook.yaml
```

### Run scan manually

```bash
docker run -it \
           --mount type=bind,readonly,source=/,target=/scandir \
           --mount source=clamav_db,target=/var/lib/clamav \
           --mount type=bind,source=/usr/local/docker/clamav/freshclam.conf,target=/etc/clamav/freshclam.conf \
           --rm \
           --name clamav clamav/clamav:0.104.1 clamscan -r --stdout /scandir
```
