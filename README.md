# queen-of-the-meadows
1.Partition the Disk: GPT layout with EFI and Root partitions.Bash
# Check your target drive name first using 'lsblk'
# Replace /dev/nvme0n1 with your actual drive name if needed
sudo parted /dev/nvme0n1 -- script -- mklabel gpt
sudo parted /dev/nvme0n1 -- script -- mkpart ESP fat32 1MiB 1024MiB
sudo parted /dev/nvme0n1 -- script -- set 1 esp on
sudo parted /dev/nvme0n1 -- script -- mkpart primary ext4 1024MiB 100%
2.Format the Partitions: Create FAT32 boot and ext4 root filesystems.Bash
# For NVMe drives (partition suffixes: p1, p2)
sudo mkfs.fat -F32 -n boot /dev/nvme0n1p1
sudo mkfs.ext4 -L nixos /dev/nvme0n1p2
# Note: For SATA SSDs (e.g., /dev/sda), use /dev/sda1 and /dev/sda2
3.Mount Partitions: Mount filesystems under /mnt.Bash
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
4.Generate Configuration: Create hardware and default system configs.Bash
sudo nixos-generate-config --root /mnt
5.Install and Reboot: Build system, set root password, and restart.Bash
sudo nixos-install
sudo reboot
