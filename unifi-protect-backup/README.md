# [Unifi Protect Backup](https://github.com/ep1cman/unifi-protect-backup) on Ubiquiti Unifi Dream Machine (Pro)

> Run Unifi Protect Backup on your Unifi Dream Machine (Pro).

## Prerequisities

- Working **`on_boot.d`** setup (check [unifi-utilities/unifios-utilities#on-boot-script](https://github.com/unifi-utilities/unifios-utilities/tree/main/on-boot-script) for instructions)

## Setup

1. First, lets create the folder structure we'll be working with.

    `$ mkdir -p /mnt/data/unifi-protect-backup /mnt/data/unifi-protect-backup/clips /mnt/data/unifi-protect-backup/database`

    This is where Unifi Protect Backup configuration file, clips and database will be stored.

2. **Optional:** Customize [`on_boot.d/85-unifi-protect-backup.sh`](on_boot.d/85-unifi-protect-backup.sh) to your setup and copy to `/mnt/data/on_boot.d/`.
    Most likely you'll need to mark the script as executable, this will do the trick:

    `$ chmod a+x /mnt/data/on_boot.d/85-unifi-protect-backup.sh`

3. In order to backup to cloud storage you need to provide a `rclone.conf` file.

    If you do not already have a `rclone.conf` file you can create one as follows:

    ```shell
    $ podman run -it --rm --net=host -v /mnt/data/unifi-protect-backup:/root/.config/rclone --entrypoint rclone ghcr.io/ep1cman/unifi-protect-backup config
    ```

4. Register the container with podman:

    ```shell
    $ podman run -d --net=host \
        --restart always \
        --name unifi-protect-backup \
        -e UFP_USERNAME='USERNAME' \
        -e UFP_PASSWORD='PASSWORD' \
        -e UFP_ADDRESS='UNIFI_PROTECT_IP' \
        -e UFP_SSL_VERIFY='false' \
        -e RCLONE_DESTINATION='my_remote:/unifi_protect_backup' \
        -v '/mnt/data/unifi-protect-backup/clips':'/data' \
        -v '/mnt/data/unifi-protect-backup/rclone.conf':'/config/rclone/rclone.conf' \
        -v '/mnt/data/unifi-protect-backup/database/':'/config/database/' \
        ghcr.io/ep1cman/unifi-protect-backup
    ```

5. Run boot script again and we are done!

    `$ sh /mnt/data/on_boot.d/85-unifi-protect-backup.sh`

## Commands

**Updates**
To update container image to its latest version, first delete the current container (`$ podman stop unifi-protect-backup && podman rm unifi-protect-backup`) and follow through setup steps 4. & 5.

**Logs**
If you want to know what mosquitto is doing, run `$ podman logs -f unifi-protect-backup` to follow the logs.

## Relevant Links

- [Unifi Protect Backup Repository](https://github.com/ep1cman/unifi-protect-backup)

## Credits

Huge thanks to @boostchicken for his incredible work on [unifios-utilities](https://github.com/unifi-utilities/unifios-utilities) and all contributors of this repo!
