# docker-autofs
docker sidekick container for mounting external volumes vi sshfs (SFTP and SSH), nfs, and cifs

Inspired by stffabi/sshfs-client and docker-centos7-nfs-client-autofs but modifying to a different way to kill this bird using config directory.


# Volumes:
* -v mounts_root:/mounts
* -v config:/config
