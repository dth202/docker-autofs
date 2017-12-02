# docker-sshfs-client

Docker image for a light SSHFS client (~14.5MB).

## Usage

### Run

    $ docker run -it --privileged=true --net=host -v /mnt/sshfs-1 -e USER=ssh_user -e PASSWORD=XY -e SERVER=192.168.0.9 -e REMOTE_FOLDER=movies sshfs-stffabi/client

or, detached:

    $ docker run -itd --privileged=true --net=host -v /mnt/sshfs-1 -e USER=ssh_user -e PASSWORD=XY -e SERVER=192.168.0.9 -e REMOTE_FOLDER=movies sshfs-client

### Environment

Any of the environment variables described below can be passed to the sshfs-client by setting them in the `docker run` string:

* `USER` User used to connect to the SFTP server.
* `PASSWORD` Password of the user.
* `SERVER` Address or FQDN of the SFTP server.
* `PORT` Port used to connect to the SFTP server, defaults to 22.
* `REMOTE_FOLDER` Remote folder on the SFTP server to be mounted.
* `RECONNECT_OPTIONS` Options used to reconnect, defaults to `reconnect,ServerAliveInterval=15,ServerAliveCountMax=20480`. Please see [ManPage](https://linux.die.net/man/1/sshfs).
* `MOUNT_OPTIONS` Additional mount options passed to sshfs, defaults to `allow_other,StrictHostKeyChecking=no`. Please see [ManPage](https://linux.die.net/man/1/sshfs).