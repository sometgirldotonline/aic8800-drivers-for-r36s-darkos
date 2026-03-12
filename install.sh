#!/usr/bin/env bash
set -e

echo "Installing AIC8800 driver..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

KOS_DIR="$SCRIPT_DIR/kos"
BINS_DIR="$SCRIPT_DIR/bins"

# ---------------------------

# Install kernel modules

# ---------------------------

echo "Installing kernel modules..."

sudo mkdir -p /lib/modules/$(uname -r)/extra
sudo cp "$KOS_DIR"/*.ko /lib/modules/$(uname -r)/extra/

sudo depmod -a

# ---------------------------

# Install firmware

# ---------------------------

echo "Installing firmware..."

sudo mkdir -p /lib/firmware/aic8800DC
sudo cp "$BINS_DIR"/*.bin /lib/firmware/aic8800DC/

# ---------------------------

# Configure modules to load at boot

# ---------------------------

echo "Configuring module autoload..."

sudo bash -c 'cat > /etc/modules-load.d/aic8800.conf <<EOF
aic8800_fdrv
EOF'

# ---------------------------

# DONT Create udev rule for usb_modeswitch because it doesnt fucking work

# ---------------------------

#echo "Creating udev rule..."

#sudo bash -c 'cat > /etc/udev/rules.d/99-aic8800.rules <<EOF
#ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="a69c", ATTR{idProduct}=="5721", RUN+="/usr/sbin/usb_modeswitch -K -W -v a69c -p 5721"
#EOF'

# Reload udev rules

#sudo udevadm control --reload-rules
#sudo udevadm trigger

# ---------------------------

# DO make a shell script to run usbms manually 

# ---------------------------

cat > /roms/tools/0FixAICWifi.sh <<EOF
#!/bin/bash
sudo /usr/sbin/usb_modeswitch -K -W -v a69c -p 5721
EOF

chmod +x /roms/tools/0FixAICWifi.sh

# ---------------------------

# Load module immediately

# ---------------------------

echo "Loading driver..."

sudo modprobe -r aic8800_fdrv 2>/dev/null || true
sudo modprobe aic8800_fdrv

echo "Installation complete."

echo "Driver status:"
lsmod | grep aic || true

echo "Network interfaces:"
ip link | grep wlan || true

echo "Recent kernel messages:"
dmesg | tail -n 20
