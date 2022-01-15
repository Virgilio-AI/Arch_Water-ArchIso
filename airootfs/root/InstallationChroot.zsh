#!/usr/bin/zsh
###############################
# Author: Virgilio Murillo Ochoa
# Date: 14/January/2022 - Friday
# personal github: Virgilio-AI
# linkedin: https://www.linkedin.com/in/virgilio-murillo-ochoa-b29b59203
# contact: virgiliomurilloochoa1@gmail.com
# #########################################
InstallArchLinux()
{
	username=$1
	uefi=$2
	# enable sshd
	systemctl enable sshd &&
	# enable the network manager
	systemctl enable NetworkManager &&
	# link the linux-lts
	mkinitcpio -p linux-lts &&
	# sync system clock
	hwclock --systoc &&
	
	# uncomment the en_US.UTF-8 so that it has english for the distribution
	sed -i -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen &&
	
	# generate locales
	locale-gen &&
	# create a  password for the root user
	echo "enter the password for root user:" &&
	passwd &&
	# read the user name and add it to the wheel and users groups
	useradd -m -g users -G wheel $username &&
	# add a password to the user
	echo "enter the password for the user" &&
	passwd $username &&
	# allow users in wheel group
	sed -i -e 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
}

InstallGrubUEFI()
{
	diskPartition=$1

	# create the directory
	mkdir /boot/EFI
	# mount the EFI partition
	mount ${diskPartition}1 /boot/EFI
	# install grub
	grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
	# create the locale directory
	mkdir /boot/grub/locale
	# copy the locale file to locate directory
	cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
	# generate grub config file
	cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
}
InstallGrub()
{
	diskPartition=$1
	# install grub
	grub-install --target=i386-pc --recheck /dev/sda
	# create the directory
	mkdir /boot/grub/locale
	# copy the locale file to locale directory
	cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
	# generate grubs config file
	grub-mkconfig -o /boot/grub/grub.cfg
}

InstallArchWaterLinux()
{
	# select the home folder
	username=$1
	cp ArchWaterInstallation.sh /home/ArchWaterInstallation.sh
	cd home/$username
	sh ArchWaterInstallation.sh
}
username=$1
uefi=$2
diskPartition=$3

# use () instead of [[]] for some examples
# use () instead of [[]] for some examples
if [[ uefi -eq "yes" ]]
then
	InstallGrubUEFI $diskPartition
else
	InstallGrub $diskPartition
fi

InstallArchWaterLinux $username
exit
echo "finished: shutdown the computer"
