#!/bin/sh

set -u
set -e

# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
fi

cat << EOF > ${TARGET_DIR}/etc/init.d/S99Audio
modprobe spi_bcm2835
modprobe snd_soc_bcm2835_i2s
modprobe snd_soc_pisound
modprobe snd-seq

start-stop-daemon -S -x /root/start-jack.sh -n jackd -b -p /tmp/jack.run
EOF

chmod +x ${TARGET_DIR}/etc/init.d/S99Audio
