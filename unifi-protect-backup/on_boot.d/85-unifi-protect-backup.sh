#!/bin/sh
CONTAINER=unifi-protect-backup

if podman container exists "$CONTAINER"; then
  podman start "$CONTAINER"
else
  podman run -d --net=host \
    --restart always \
    --name "$CONTAINER" \
    -e UFP_USERNAME='USERNAME' \
    -e UFP_PASSWORD='PASSWORD' \
    -e UFP_ADDRESS='UNIFI_PROTECT_IP' \
    -e UFP_SSL_VERIFY='false' \
    -e RCLONE_DESTINATION='my_remote:/unifi_protect_backup' \
    -v '/mnt/data/unifi-protect-backup/clips':'/data' \
    -v '/mnt/data/unifi-protect-backup/rclone.conf':'/config/rclone/rclone.conf' \
    -v '/mnt/data/unifi-protect-backup/database/':'/config/database/' \
    ghcr.io/ep1cman/unifi-protect-backup
fi