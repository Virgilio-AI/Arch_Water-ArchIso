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
	local username=$1
	local uefi=$2
	local password=$3
	local rootPassword=$4
	# enable sshd
	systemctl enable sshd &&
	# enable the network manager
	systemctl enable NetworkManager &&
	# link the linux-lts
	mkinitcpio -p linux &&
	# sync system clock
	hwclock --systohc &&
	
	# uncomment the en_US.UTF-8 so that it has english for the distribution
	sed -i -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen &&
	
	# generate locales
	locale-gen
	# create a  password for the root user
	(
	echo $rootPassword
	echo $rootPassword
	) | passwd

	# read the user name and add it to the wheel and users groups
	useradd -m -g users -G wheel $username
	# add a password to the user
	(
	echo $password
	echo $password
	) | passwd $username
	# allow users in wheel group
	sed -i -e 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers

	echo "Water_Linux" > /etc/hostname

	# for mexico only right now
	timedatectl set-timezone America/Mexico_City

	echo " ========= The user password is : $password "
	echo " ========= The root password is : $rootPassword "


	(
		echo "$password"
	) | chsh -s /bin/zsh "$username" |& tee -a Log.txt


	(
		echo "$password"
	) | chsh -s /bin/zsh |& tee -a Log.txt

}

InstallGrubUEFI()
{
	diskPartition=$1
	# install grub
	grub-install $diskPartition
	# generate grubs config file
	grub-mkconfig -o /boot/grub/grub.cfg
}

InstallGrub()
{
	diskPartition=$1
	# install grub
	grub-install $diskPartition
	# generate grubs config file
	grub-mkconfig -o /boot/grub/grub.cfg
}

InstallArchWaterLinux()
{
	# select the home folder
	username=$1
	echo "=== copy the file into the home directory"
	mv /autoInstaller-AW /home/$username/autoInstaller-AW
	echo "=== cd into the home directory with the user"
	cd /home/$username/autoInstaller-AW
	echo "=== run the ArchWaterInstallation.sh"
	sh /home/$username/autoInstaller-AW/ArchWaterInstallation.sh $username $password $rootPassword
}



pathVar=$0
echo "===== pathVar" >> Log.txt
echo $pathVar >> Log.txt
username=$1
echo "===== username" >> Log.txt
echo $username >> Log.txt
read -n1
uefi=$2
echo "===== uefi" >> Log.txt
echo $uefi >> Log.txt
diskPartition=$3
echo "=== diskPartition" >> Log.txt
echo $diskPartition >> Log.txt

password=$4
echo "password $password"
read -n1


rootPassword=$5
echo "password $rootPassword"
read -n1



echo "===== Install arch linux " >> Log.txt
InstallArchLinux $username $uefi $password $rootPassword >> Log.txt

# use () instead of [[]] for some examples
# use () instead of [[]] for some examples
if [[ uefi = "yes" ]]
then
	echo "Install Grub UEFI method" >> Log.txt
	InstallGrubUEFI $diskPartition >> Log.txt
else
	echo "Install Grub NON UEFI method" >> Log.txt
	InstallGrub $diskPartition >> Log.txt
fi


InstallArchWaterLinux $username

echo "finished: shutdown the computer or reboot"
read -n1
exit
