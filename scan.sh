#!/bin/bash

docker run -it \
           --mount type=bind,readonly,source=/,target=/scandir \
           --mount source=clamav_db,target=/var/lib/clamav \
           --mount type=bind,source=/usr/local/docker/clamav/freshclam.conf,target=/etc/clamav/freshclam.conf \
           --rm \
           --name clamav clamav/clamav:0.104.1 clamscan -i -r --stdout /scandir
