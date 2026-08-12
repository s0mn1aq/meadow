![Cover](cover.jpg)
<p align="center">
<img src="cover.jpg" alt="Cover" width="100%">
</p>

# установка системы

[если на устройстве до этого стояла другая операционная система проверяем наличие оставшегося в bios варианта ее запуска и при надобности стираем его]

```bash
efibootmgr 
sudo efibootmgr -b НомерВариантаЗапускаСистемы -B
```

<узнаем идентификаторы дисков и размечаем диск на котором будет стоять операционная система заменяя 'ЖелаемыйДиск' на его идентификатор>

```bash
lsblk
sudo parted ЖелаемыйДиск --script mklabel gpt
sudo parted ЖелаемыйДиск --script mkpart ESP fat32 1MiB 1024MiB
sudo parted ЖелаемыйДиск --script set 1 esp on
sudo parted ЖелаемыйДиск --script mkpart primary ext4 1024MiB 100%
```

<форматируем размеченный нами диск и подставляем идентификатор диска с номером его части вместо 'НомерЧастьЖелаемогоДиска', а так же монтируем его после>

```bash
sudo mkfs.fat -F32 -n boot 1ЧастьЖелаемогоДиска
sudo mkfs.ext4 -L nixos 2ЧастьЖелаемогоДиска
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
```

<генерируем файлы конфигурации и заускаем установку системы, после, перезагружая устройство>

```bash
sudo nixos-generate-config --root /mnt
sudo nixos-install
sudo reboot
```
