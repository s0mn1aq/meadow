# queen-of-the-meadows
Краткая и универсальная инструкция по установке NixOS на диск.

ВНИМАНИЕ: все данные на целевом диске будут удалены. Заменяйте <TARGET> и суффиксы разделов на свои (прим.: NVMe — p1/p2, SATA — 1/2).

1) Проверка диска
```bash
lsblk
# или
sudo fdisk -l
```

2) Разметка (пример, GPT, EFI + root)
```bash
sudo parted <TARGET> --script mklabel gpt
sudo parted <TARGET> --script mkpart ESP fat32 1MiB 1024MiB
sudo parted <TARGET> --script set 1 esp on
sudo parted <TARGET> --script mkpart primary ext4 1024MiB 100%
```

3) Форматирование
```bash
# Для NVMe: /dev/nvme0n1p1, /dev/nvme0n1p2
# Для SATA: /dev/sda1, /dev/sda2
sudo mkfs.fat -F32 -n boot <TARGET_PART1>
sudo mkfs.ext4 -L nixos <TARGET_PART2>
```

4) Монтирование
```bash
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
```

5) Генерация конфигурации и установка
```bash
sudo nixos-generate-config --root /mnt
sudo nixos-install
sudo reboot
```

Готово — система перезагрузится. При необходимости отредактируйте /mnt/etc/nixos/configuration.nix перед `nixos-install`.
