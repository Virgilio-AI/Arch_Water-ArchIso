#!/usr/bin/zsh
###############################
# Author: Virgilio Murillo Ochoa
# Date: 14/January/2022 - Friday
# personal github: Virgilio-AI
# linkedin: https://www.linkedin.com/in/virgilio-murillo-ochoa-b29b59203
# contact: virgiliomurilloochoa1@gmail.com
# #########################################

# functions
partitionUEFI(){
	diskPartition=$1
	(
	echo d # delete all the partitions
	echo   # default
	echo   # default
	echo d # delete all the partitions
	echo   # default
	echo   # default
	echo d # delete all the partitions
	echo   # default
	echo   # default
	echo d # delete all the partitions
	echo   # default
	echo   # default
	echo g # create the gpt partition
	echo n # create a new partition
	echo   # default number identifier
	echo   # default first sector
	echo +500M # so that it will be 500M
	echo t # change the type
	echo 1 # the number identifier in the partition like 
	echo n # create a swap partition
	echo   # enter default number identifier
	echo   # enter default starting section
	echo +600M # give it 600M
	echo t # change the type
	echo 2 # the identfier
	echo 19 # for the linux swap
	echo n # for a new partition
	echo   # leave all the defaults in this one
	echo   # leave all the defaults in this one
	echo   # leave all the defaults in this one
	echo w # writing the 
	) | sudo fdisk $diskPartition

	# format the EFI partition
	mkfs.fat -F32 ${diskPartition}1 &&
	# format the main partition
	mkfs.ext4 ${diskPartition}3 &&
	# mkswap in the swap partition
	mkswap ${diskPartition}2 &&

	# first mount the root partition
	mount ${diskPartition}3 /mnt &&
	# turn on swap
	swapon ${diskPartition}2 &&
	# create the /etc/fstab file
	genfstab -U -p /mnt >> /mnt/etc/fstab ; echo "the partitions were created" ; cat /mnt/etc/fstab
}
partition()
{

	diskPartition=$1
	(
	echo d # delete all the partitions
	echo   # default
	echo   # default
	echo d # delete all the partitions
	echo   # default
	echo   # default
	echo d # delete all the partitions
	echo   # default
	echo   # default
	echo d # delete all the partitions
	echo   # default
	echo   # default
	echo o # create a dos partition
	echo n # create the swap partition
	echo p # make it primary
	echo   # use the default value
	echo +4G # give it the 4 gigas 
	echo t # change the partition type
	echo 82 # use the 82 partition
	echo n # create the main partition
	echo p # make it primary
	echo   # the default
	echo   # give it the whole size
	echo w # save and quit
	) | sudo fdisk $diskPartition
	# format the partitions
	mkfs.ext4 ${diskPartition}2 >/dev/null 2>&1 &&
	# turn on the swap partition
	mkswap ${diskPartition}1 >/dev/null 2>&1 &&
	# turn on the swapon
	mount ${diskPartition}2 /mnt >/dev/null 2>&1 &&
	# generate the mount points
	genfstab -U /mnt >> /mnt/etc/fstab >/dev/null 2>&1 ; echo "the partitions were created" ; cat /mnt/etc/fstab
}
InternetConnection()
{
# first configure the network connection
# start the network manager daemon
systemctl start NetworkManager >/dev/null 2>&1
# use the wifi
nmtui;
# sync the time and date
timedatectl set-ntp true >/dev/null 2>&1;

# try remove the sync files for ensuring the installation is correct
rm -R /var/lib/pacman/sync/ >/dev/null 2>&1;
# try installing the packages again
pacman -Syy >/dev/null 2>&1;

# update the arch linux keyring( the installation medium might be very old)
pacman -S archlinux-keyring >/dev/null 2>&1 ;
}

# ==========================
# ========== the installation commands ======
# ==========================

InternetConnection


seePartitions=$(parted -l | grep "Disk /")
diskPartition=$(dialog --title "partitioning the disks" --inputbox "$seePartitions\nenter the partition in with you want to install the partition" 10 60 "/dev/sda" 3>&1 1>&2 2>&3)


dialog --title "Installation" --yesno "is this system UEFI? must new computers use UEFI" 17 70
if [[ $? == 1 ]]
then
	uefi="yes"
	partitionUEFI $diskPartition
else
	uefi="no"
	partition $diskPartition
fi

# install the packages in the list
pacstrap /mnt $(cat packages.txt)
# install paru
pacstrap /mnt paru
# copy the installation script into the home
cp InstallationChroot.zsh /mnt/home/
# copy the the archWater Linux Installation guide
cp ArchWaterInstallation.sh /mnt/home/
# run the script 
arch-chroot /mnt zsh /home/InstallationChroot.zsh $username $uefi $diskPartition
# finalization

dialog --title "Installation" --msgbox "the installation has ended\nshutdown and remove the usb" 10 60
