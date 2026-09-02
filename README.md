# alpine-bootc
Currently experimental, and requires the composefs backend.

```sh
podman run --rm --privileged --pid=host --ipc=host -v /var/lib/containers:/var/lib/containers -v /dev:/dev --security-opt label=type:unconfined_t ghcr.io/sed4906/alpine-bootc:edge bootc install to-disk --wipe --composefs-backend --allow-missing-verity /dev/<disk>
```

Notes:
- `build_files/build.sh` specifies linux-virt by default. You might want lts or stable. VARIANT=virt can be changed to something else.
- For testing purposes, before I reboot into the installed system, I mount the root partition to `/mnt` and remove the `*` from root's entry in `/mnt/state/deploy/(blah)/etc/shadow` so I can log in without a password.
