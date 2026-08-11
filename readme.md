# инструкция по установке системы

### проверка диска

```bash
lsblk
```
### разметка диска

```bash
sudo parted <TARGET> --script mklabel gpt
sudo parted <TARGET> --script mkpart ESP fat32 1MiB 1024MiB
sudo parted <TARGET> --script set 1 esp on
sudo parted <TARGET> --script mkpart primary ext4 1024MiB 100%
```

### форматирование диска

```bash
# Для NVMe: /dev/nvme0n1p1, /dev/nvme0n1p2
# Для SATA: /dev/sda1, /dev/sda2
sudo mkfs.fat -F32 -n boot <TARGET_PART1>
sudo mkfs.ext4 -L nixos <TARGET_PART2>
```

### монтирование диска

```bash
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
```

### генерация конфигурации и установка

```bash
sudo nixos-generate-config --root /mnt
sudo nixos-install
sudo reboot
```
