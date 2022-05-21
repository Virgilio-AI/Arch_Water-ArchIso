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

	# dialog --title "Installation -- creating the partitions" --infobox "the disk will be partitioned and formated" 10 60
	echo " ===== the disk will be partitioned and formatted ====== " |& tee -a Log.txt
	echo " ===== you choosed the EUFI installer ====== " |& tee -a Log.txt
	echo "===== the disk partition is $diskPartition" |& tee -a Log.txt
	diskPartition=$1
	(

	) | sudo fdisk $diskPartition  |& tee -a Log.txt

	# format the EFI partition
	# dialog --title "Installation -- creating the partitions UEFI" --infobox "formating the EFI partition" 10 60
	echo "==========formatting the partitions UEFI" |& tee -a Log.txt
	mkfs.fat -F32 ${diskPartition}1  |& tee -a Log.txt
	# format the main partition
	# dialog --title "Installation -- creating the partitions UEFI" --infobox "formating the main partition with ext4" 10 60
	echo "==========formatting the main partition with ext4" |& tee -a Log.txt
	mkfs.ext4 ${diskPartition}3 |& tee -a Log.txt 
	# mkswap in the swap partition
	# dialog --title "Installation -- creating the partitions UEFI" --infobox "making the swap partition" 10 60
	echo "==========making the swap partition" |& tee -a Log.txt
	mkswap ${diskPartition}2  |& tee -a Log.txt 

	# first mount the root partition
	# dialog --title "Installation -- creating the partitions UEFI" --infobox "mounting the main partition" 10 60
	echo "==========mounting the main partition"  |& tee -a Log.txt
	mount ${diskPartition}3 /mnt  |& tee -a Log.txt 
	# turn on swap
	# dialog --title "Installation -- creating the partitions UEFI" --infobox "turning on the partition" 10 60
	echo "==========turning on the swap partition"  |& tee -a Log.txt
	swapon ${diskPartition}2  |& tee -a Log.txt 
	# create the /etc/fstab file
	# dialog --title "Installation -- creating the partitions UEFI" --infobox "creating the fstab file" 10 60
	catFsTabFile=$(cat /mnt/etc/fstab)  |& tee -a Log.txt
	# dialog --title "Installation -- creating the partitions UEFI" --infobox "the partitions have been created and formated correctly\n$(catFsTabFile)" 10 60
	echo "==========the partitions were created and formatted"
}
partition()
{
	# dialog --title "Installation -- creating the partitions" --infobox "the disk will be partitioned and formated" 10 60
	echo "===== the disk will be partitioned and formatted" |& tee -a Log.txt
	echo "===== non UEFI method" |& tee -a Log.txt
	diskPartition=$1
	echo "===== the disk partition is $diskPartition" |& tee -a Log.txt
	(
	echo d # delete all the partitions
	echo   # default
	echo   # default
	echo   # default
	echo d # delete all the partitions
	echo   # default
	echo   # default
	echo   # default
	echo d # delete all the partitions
	echo   # default
	echo   # default
	echo   # default
	echo d # delete all the partitions
	echo   # default
	echo   # default
	echo   # default
	echo o # create a dos partition
	echo n # create the swap partition
	echo p # make it primary
	echo   # use the default partition
	echo   # use the default first sector
	echo +4G # give it the 4 gigas 
	echo t # change the partition type
	echo 82 # use the 82 partition
	echo n # create the main partition
	echo p # make it primary
	echo   # the default
	echo   # give it the whole size
	echo   # give it the whole size
	echo w # save and quit
	) | sudo fdisk $diskPartition |& tee -a Log.txt 
	# format the partitions
	# dialog --title "Installation -- creating the partitions non UEFI" --infobox "formating the disk" 10 60
	echo "===== formatting the disk"  |& tee -a Log.txt
	mkfs.ext4 ${diskPartition}2  |& tee -a Log.txt 
	# turn on the swap partition
	# dialog --title "Installation -- creating the partitions non UEFI" --infobox "" 10 60
	echo "===== making the swap partition"  |& tee -a Log.txt
	mkswap ${diskPartition}1  |& tee -a Log.txt 
	# turn on the swapon
	# dialog --title "Installation -- creating the partitions non UEFI" --infobox "" 10 60
	echo "===== mounting the main partition"  |& tee -a Log.txt
	mount ${diskPartition}2 /mnt  |& tee -a Log.txt 
	
	# turn on the swap signature
	echo "==== turn on the swap parttion" |& tee -a Log.txt
	swapon ${diskPartition}1 |& tee -a Log.txt ;
}
InternetConnection()
{
# first configure the network connection
# start the network manager daemon
# dialog --title "Arch Water Installation" --infobox "starting the network manager" 10 60
systemctl start NetworkManager |& tee -a Log.txt 
# use the wifi
nmtui ;

# sync the time and date
# dialog --title "ArchWater Installation" --infobox "syncronizing time and date" 10 60
timedatectl set-ntp true  |& tee -a Log.txt 

# try remove the sync files for ensuring the installation is correct
# dialog --title "ArchWater Installation" --infobox "removal of the currently installed packages" 10 60
rm -R /var/lib/pacman/sync/ |& tee -a Log.txt 
# try installing the packages again
# dialog --title "ArchWater Installation" --infobox "sync the packages in pacman" 10 60
pacman -Syy |& tee -a Log.txt 

# update the arch linux keyring( the installation medium might be very old)
# dialog --title "ArchWater Installation" --infobox "downloading the new archlinux-keyrins to ensure installing packages" 10 60
pacman -S archlinux-keyring |& tee -a Log.txt
}
askforusername()
{
	# Prompts user for new username an password.
	username=$(dialog --inputbox "First, please enter a name for the user account." 10 60 3>&1 1>&2 2>&3 3>&1) || exit 1
	while ! echo "$name" | grep -q "^[a-z_][a-z0-9_-]*$"; do
		username=$(dialog --no-cancel --inputbox "Username not valid. Give a username beginning with a letter, with only lowercase letters, - or _." 10 60 3>&1 1>&2 2>&3 3>&1)
	done
}
# ==========================
# ========== the installation commands ======
# ==========================

dialog --title "Installation ArchWater" --msgbox "this is the script to automate the installation of arch Water Linux, first you will need to configure the internet using the tool nmtui. which is going to be called when you press okay. make sure you quit out of it when you finished the network configuration" 0 0


reset ;
InternetConnection

seePartitions=$(parted -l | grep "Disk /")
diskPartition=$(dialog --title "partitioning the disks" --inputbox "$seePartitions\nenter the partition in with you want to install the partition" 10 60 "/dev/sda" 3>&1 1>&2 2>&3)


dialog --title "Installation" --yesno "is this system UEFI? must new computers use UEFI" 17 70
if [[ $? == 0 ]]
then
	uefi="yes"
	reset ;
	partitionUEFI $diskPartition
else
	uefi="no"
	reset ;
	partition $diskPartition
fi
# username
echo "Enter the username for the Installation"
read username

# install the packages in the list
# dialog --title "Installation" --infobox "Installing the base packages base base-devel zsh linux-lts linux-firmware" 10 60
echo "===== Installing the base packages" |& tee -a Log.txt
pacstrap /mnt base base-devel neovim zsh linux-lts linux-firmware openssh networkmanager grub |& tee -a Log.txt 

if [[ $uefi -eq "yes" ]] 
then
	echo "========== creating the fstab file"  |& tee -a Log.txt
	genfstab -U -p /mnt >> /mnt/etc/fstab  |& tee -a Log.txt
	cat /mnt/etc/fstab  |& tee -a Log.txt
else
	echo "========== generating the fstab configuration" |& tee -a Log.txt
	genfstab -U /mnt >> /mnt/etc/fstab |& tee -a Log.txt ;
	cat /mnt/etc/fstab |& tee -a Log.txt
fi
# install paru
# copy the installation script into the home
# dialog --title "Installation" --infobox "copying the files that we will need in the chroot environment" 10 60
echo "===== copying the files that will need in our installation" |& tee -a Log.txt
cp -r autoInstaller-AW /mnt/home/ |& tee -a Log.txt
cp InstallationChroot.zsh /mnt/home/ |& tee -a Log.txt
# run the script 
# dialog --title "Installation" --infobox "Running the ArchWater Installation Script" 10 60
echo "===== running the arch water installation script" |& tee -a Log.txt
arch-chroot /mnt zsh /home/InstallationChroot.zsh $username $uefi $diskPartition
# finalization

# dialog --title "Installation" --infobox "the installation has ended\nshutdown and remove the usb" 10 60
echo "===== the installation has finished" |& tee -a Log.txt
