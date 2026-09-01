#!/bin/ash

set -ouex pipefail

VARIANT=virt

apk add linux-$VARIANT openrc
echo '/usr/lib/bootc/initramfs-setup' > /etc/mkinitfs/features.d/bootc.files
cat << "EOF" > /etc/mkinitfs/features.d/bootc.modules
kernel/fs/efivarfs
kernel/fs/erofs
EOF
echo 'features="ata base bootc cdrom ext4 keymap kms mmc nvme raid scsi usb virtio"' > /etc/mkinitfs/mkinitfs.conf
sed -i /usr/share/mkinitfs/initramfs-init -e '/ebegin "Mounting root"/a\' -e 'modprobe -a efivarfs erofs ext4 overlay vfat; mount -t efivarfs efivarfs /sys/firmware/efi/efivars; mount -t tmpfs tmpfs /tmp'
sed -i /usr/share/mkinitfs/initramfs-init -e 's/"${KOPT_rootflags:-ro}"/"${KOPT_rootflags:-rw}"/'
sed -i /usr/share/mkinitfs/initramfs-init -e '/"${KOPT_root#ZFS=}" "$sysroot"/a\' -e '/usr/lib/bootc/initramfs-setup setup-root'
mkinitfs $(ls /lib/modules | tail -1)

mkdir -p /usr/lib/modules/$(ls /lib/modules | tail -1)
mv /boot/vmlinuz-$VARIANT /usr/lib/modules/$(ls /lib/modules | tail -1)/vmlinuz
mv /boot/initramfs-$VARIANT /usr/lib/modules/$(ls /lib/modules | tail -1)/initramfs.img
rm -rf /boot/*

apk add systemd-boot
cat << "EOF" > /usr/bin/bootctl
#!/bin/ash
case $1 in
install)
mkdir -p $3$5/EFI/Boot
case $(arch) in
x86_64) cp /usr/lib/systemd/boot/efi/systemd-bootx64.efi $3$5/EFI/Boot/BOOTX64.EFI ;;
*) echo "Currently unsupported CPU architecture." ; exit 1 ;;
esac
mkdir -p $3$5/loader
cat << "EOC" > $3$5/loader/loader.conf
timeout 3
console-mode max
EOC
;;
*) echo "Oobily goobily weezer beezers!!" ; exit 1 ;;
esac
EOF
chmod +x /usr/bin/bootctl
