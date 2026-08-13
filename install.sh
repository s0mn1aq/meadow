#!/usr/bin/env bash
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "ошибка: требуется root"
  exit 1
fi

echo "установка meadow"
echo ""

lsblk -d -n -o NAME,SIZE,MODEL | grep -v "loop"
echo ""
read -rp "диск (например /dev/sda или /dev/nvme0n1): " DISK

if [ ! -b "$DISK" ]; then
  echo "ошибка: диск не найден"
  exit 1
fi

read -rp "уничтожение данных на $DISK. продолжить? (y/n): " CONFIRM
if [[ "$CONFIRM" != [yY] ]]; then
  echo "отмена"
  exit 0
fi

echo "разметка..."
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

echo "форматирование..."
mkfs.fat -F32 -n boot "$BOOT_PART"
mkfs.ext4 -F -L nixos "$ROOT_PART"

echo "монтирование..."
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

echo "загрузка репозитория..."
TMP_DIR=$(mktemp -d)
git clone https://github.com/s0mn1aq/meadow.git "$TMP_DIR"

mkdir -p /mnt/etc/nixos
cp -r "$TMP_DIR/meadow/"* /mnt/etc/nixos/
rm -rf "$TMP_DIR"

echo "генерация конфига..."
nixos-generate-config --root /mnt
mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/meadow/
rm -f /mnt/etc/nixos/configuration.nix

echo "установка системы..."
nixos-install --flake /mnt/etc/nixos#meadow

echo "готово"
read -rp "перезагрузка? (y/n): " REBOOT
if [[ "$REBOOT" == [yY] ]]; then
  reboot
fi
