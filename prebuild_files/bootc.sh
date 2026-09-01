#!/bin/ash

set -ouex pipefail

apk add abuild doas
echo "permit nopass root" >> /etc/doas.conf

abuild-keygen -a -i -n
cp -r /ctx/bootc /tmp/bootc
abuild -F -C /tmp/bootc -r -s /tmp/srcdest -P /tmp/repodest
apk add /tmp/repodest/tmp/$(abuild -A)/bootc-*.apk

. /root/.config/abuild/abuild.conf
rm /etc/apk/keys/$(basename $PACKAGER_PRIVKEY).pub
rm -r /root/.config
rm /etc/doas.conf
apk del abuild doas
