FROM alpine:3.5
MAINTAINER Dallas Harris

# USAGE
# $ docker build -t sshfs-client .
# $ docker run -it --privileged=true --net=host -v /mnt/sshfs-1 -e USER=ssh_user -e PASSWORD=XY -e SERVER=192.168.0.9 -e REMOTE_FOLDER=movies sshfs-client
#    or detached:
# $ docker run -itd --privileged=true --net=host -v /mnt/sshfs-1 -e USER=ssh_user -e PASSWORD=XY -e SERVER=192.168.0.9 -e REMOTE_FOLDER=movies sshfs-client


# This is the release of https://github.com/hashicorp/docker-base to pull in order
# to provide HashiCorp-built versions of basic utilities like dumb-init and gosu.
ENV DOCKER_BASE_VERSION=0.0.4
ENV DOCKER_BASE_SHA256SUM=5262aa8379782d42f58afbda5af884b323ff0b08a042e7915eb1648891a8da00

# Set up certificates and our base tools.
RUN apk add --no-cache ca-certificates openssl && \
    cd /tmp && \
    wget -O docker-base.zip https://releases.hashicorp.com/docker-base/${DOCKER_BASE_VERSION}/docker-base_${DOCKER_BASE_VERSION}_linux_amd64.zip && \
    echo "${DOCKER_BASE_SHA256SUM}  docker-base.zip" | sha256sum -c && \
    unzip -d / docker-base.zip && \
    rm docker-base.zip

ENV PORT 22
ENV RECONNECT_OPTIONS reconnect,ServerAliveInterval=15,ServerAliveCountMax=20480
ENV Mount_TYPE
ENV MOUNT_OPTIONS allow_other,StrictHostKeyChecking=no

RUN apk update && \
    apk add autofs && \
    apk add sshfs && \
    apk add nfs-common && \
    apk add cifs-utils && \
    rm -rf  /var/cache/apk/* \
            /sbin/halt \
            /sbin/poweroff \
            /sbin/reboot

# Add autofs mount configs and mount direcotry
RUN echo "/mounts /config/auto.mounts --timeout=20 --ghost" >> /etc/auto.master && \
    mkdir /config /mounts && \
    chattr +i /mounts
COPY auto.mymounts /config/auto.mymounts
COPY auto.master /etc/auto.master.d/auto.mount
VOLUME ["/config"]
VOLUME ["/mounts"]

#ENTRYPOINT ["/usr/local/bin/entry.sh"]
CMD ["/bin/sh"]
