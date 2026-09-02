# alpine-bootc
Currently experimental, and requires the composefs backend.

Notes:
- `build_files/build.sh` specifies linux-stable by default. You might want lts or virt for a smaller image. VARIANT=stable can be changed to something else.
- The root filesystem is expected to be ext4.
- For testing purposes, before I reboot into the installed system, I mount the root partition to `/mnt` and remove the `*` from root's entry in `/mnt/state/deploy/(blah)/etc/shadow` so I can log in without a password.
