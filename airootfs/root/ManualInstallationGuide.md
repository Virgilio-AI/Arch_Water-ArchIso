# connecting to the internet
systemctl start NetworkManager
nmtui
timedatectl set-ntp true
pacman -S archlinux-keyring
pacman -Syy
rm -R /var/lib/pacman/sync/
pacman -Syy
ping www.google.com

# creating the disk partition
## for UEFI partition
fdisk -l
fdisk /dev/sda
m
d
Enter
Enter
g
n
Enter
Enter
+5G
t
1
1
n
Enter
Enter
+4G
t
2
L
19
n
Enter
Enter
Enter
p
w
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda3
mkswap /dev/sda2
mount /dev/sda3 /mnt
swapon /dev/sda2
genfstab -U -p /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

## for non UEFI partition
fdisk -l
fdisk /dev/sda
d
Enter
Enter
o
n
p
Enter
+4G
t
L
82
n
p
Enter
Enter
mkfs.ext4 /dev/sda2
mkswap /dev/sda1
swapon /dev/sda1
mount /dev/sda2 /mnt
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/fstab

# Install arch linux
pacstrap /mnt $(cat packages.txt)
arch-chroot /mnt
systemctl enable sshd
systemctl enable NetworkManager
mkinitcpi -p linux-lts
hwclock --sysclock

sed -i -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
passwd
useradd -m -g users -G wheel <username>
passwd rockhight
EDITOR=nvim visudo

# install grub

## UEFI
mkdir /boot/EFI
mount /dev/sda1 /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
mkdir /boot/grub/locale
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo

## non UEFI
grub-install --target=i386-pc --recheck /dev/sda
mkdir /boot/grub/locale
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
grub-mkconfig -o /boot/grub/grub.cfg

# Installing ArchWater
cd home/rockhight
git clone https://github.com/Virgilio-AI/ArchWater-AutoInstaller.git archAutoInstaller
exit
reboot
cd archAutoInstaller
sudo sh ArchWater-AutoInstaller.sh
