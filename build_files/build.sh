#!/bin/ash

set -ouex pipefail

FLAVOR=stable

cp -avf "/ctx/system_files"/. /
mkdir -p /var/home /var/roothome

apk add alpine-base
for s in cgroups varhome hostname networking; do rc-update add $s; done
echo 'features="$features bootc"' >> /etc/mkinitfs/mkinitfs.conf
sed -i /usr/share/mkinitfs/initramfs-init -e '/ebegin "Mounting root"/a\' -e 'modprobe -a efivarfs erofs ext4 overlay vfat; mount -t efivarfs efivarfs /sys/firmware/efi/efivars; mount -t tmpfs tmpfs /tmp'
sed -i /usr/share/mkinitfs/initramfs-init -e 's/"${KOPT_rootflags:-ro}"/"${KOPT_rootflags:-rw}"/'
sed -i /usr/share/mkinitfs/initramfs-init -e '/"${KOPT_root#ZFS=}" "$sysroot"/a\' -e '/usr/lib/bootc/initramfs-setup setup-root'

apk add linux-$FLAVOR linux-firmware-none
KERNEL=$(ls /lib/modules | tail -1)
mkdir -p /usr/lib/modules/$KERNEL
mv /boot/vmlinuz-$FLAVOR /usr/lib/modules/$KERNEL/vmlinuz
mv /boot/initramfs-$FLAVOR /usr/lib/modules/$KERNEL/initramfs.img
rm -rf /boot/*

apk add systemd-boot
