# docker-autofs
docker sidekick container for mounting external volumes vi sshfs (SFTP and SSH), nfs, and cifs

Inspired by stffabi/sshfs-client and docker-centos7-nfs-client-autofs but modifying to a different way to kill this bird using config directory.


# Volumes:
* `-v mounts_root:/mounts`
* `-v config:/config`


# /config/auto.mounts:
Mountpoints to be added to `/mounts`

Syntax: `<key> <mount_options> <target>`

Note: `&` used in the target represents the name of the key

## Example entries:
```
folder1    -type=nfs,rw     192.168.34.73:/exports/dir1
folderb    -fstype=cifs,credentials=/root/.smbcredentials,dir_mode=0775,file_mode=0664,noserverino  ://server/&
seedbox    -fstype=fuse,rw,max_read=65536,uid=1001,gid=1001  :sshfs\#user@serverfqdn\:/path/to/dir
proxmox    -fstype=nfs,ro  \
       /backups  -rw  10.0.32.209:/mnt/goliath/&/backups
```
