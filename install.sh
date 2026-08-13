#!/usr/bin/env bash
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "error: root required"
  exit 1
fi

echo "meadow"
echo ""

lsblk -d -n -o NAME,SIZE,MODEL | grep -v "loop"
echo ""
read -rp "disk: " DISK </dev/tty

[[ "$DISK" != /dev/* ]] && DISK="/dev/$DISK"

if [ ! -b "$DISK" ]; then
  echo "error: disk not found"
  exit 1
fi

read -rp "wipe $DISK? (y/n): " CONFIRM </dev/tty
if [[ "$CONFIRM" != [yY] ]]; then
  echo "canceled"
  exit 0
fi

echo "partitioning"
wipefs -a "$DISK"
parted --script "$DISK" mklabel gpt
parted --script "$DISK" mkpart ESP fat32 1MiB 1024MiB
parted --script "$DISK" set 1 esp on
parted --script "$DISK" mkpart primary ext4 1024MiB 100%

if [[ "$DISK" =~ "nvme" ]] || [[ "$DISK" =~ "mmcblk" ]]; then
  BOOT_PART="${DISK}p1"
  ROOT_PART="${DISK}p2"
else
  BOOT_PART="${DISK}1"
  ROOT_PART="${DISK}2"
fi

partprobe "$DISK"
udevadm settle

echo "formatting"
wipefs -a "$BOOT_PART"
wipefs -a "$ROOT_PART"
mkfs.fat -F32 -n boot "$BOOT_PART"
mkfs.ext4 -F -L nixos "$ROOT_PART"

udevadm settle

echo "mounting"
mount "$ROOT_PART" /mnt
mkdir -p /mnt/boot
mount "$BOOT_PART" /mnt/boot

echo "cloning"
TMP_DIR=$(mktemp -d)
git clone https://github.com/s0mn1aq/meadow.git "$TMP_DIR"

mkdir -p /mnt/etc/nixos
cp -r "$TMP_DIR/meadow/." /mnt/etc/nixos/
rm -rf "$TMP_DIR"

echo "configuring"
nixos-generate-config --root /mnt
mkdir -p /mnt/etc/nixos/hosts/meadow
mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/meadow/
rm -f /mnt/etc/nixos/configuration.nix

echo "installing"
nixos-install --flake /mnt/etc/nixos#meadow

echo "done"
read -rp "reboot? (y/n): " REBOOT </dev/tty
if [[ "$REBOOT" == [yY] ]]; then
  reboot
fi
