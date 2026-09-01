#!/bin/ash

set -ouex pipefail

apk add abuild doas
echo "permit nopass root" >> /etc/doas.conf

abuild-keygen -a -i -n
cp -r /ctx/bootc /tmp/bootc
abuild -F -C /tmp/bootc -r -s /tmp/srcdest -P /tmp/repodest
apk add /tmp/repodest/tmp/$(abuild -A)/bootc-*.apk

rm /etc/doas.conf
apk del abuild doas
