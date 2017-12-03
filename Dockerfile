FROM centos:centos7
MAINTAINER Dallas Harris

RUN yum -y update; yum clean all
RUN yum -y swap -- remove fakesystemd -- install systemd systemd-libs
RUN yum -y install nfs-utils; yum clean all
RUN systemctl mask dev-mqueue.mount dev-hugepages.mount \
    systemd-remount-fs.service sys-kernel-config.mount \
    sys-kernel-debug.mount sys-fs-fuse-connections.mount
RUN systemctl mask display-manager.service systemd-logind.service
RUN systemctl disable graphical.target; systemctl enable multi-user.target

# Copy the dbus.service file from systemd to location with Dockerfile
COPY dbus.service /usr/lib/systemd/system/dbus.service

VOLUME ["/sys/fs/cgroup"]
VOLUME ["/run"]

CMD  ["/usr/lib/systemd/systemd"]

RUN yum -y update && \
    yum install -y autofs && \
    yum install -y fuse-sshfs && \
    yum install -y nfs-utils && \
    yum install -y cifs-utils && \
    yum clean all && \
    rm -rf  /sbin/halt \
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
