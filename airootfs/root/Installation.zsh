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
	echo " ===== the disk will be partitioned and formatted ====== "
	echo " ===== you choosed the EUFI installer ====== "
	echo "===== the disk partition is $diskPartition"
	diskPartition=$1
	echo "===== the disk partition is $diskPartition"

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
	echo g # create a dos partition
	echo n # create the efi partition
	echo   # use the default partition number
	echo   # use the default first sector
	echo +500M # give it the 4 gigas
	echo y # delete the default format
	echo t # change the partition type
	echo 1 # for using the efi system partition
	echo n # create the main partition
	echo p # make it primary
	echo   # the default
	echo   # give it the whole size
	echo   # give it the whole size
	echo y # delete the default format
	echo w # save and quit
	) | sudo fdisk $diskPartition

	# format the EFI partition
	# dialog --title "Installation -- creating the partitions UEFI" --infobox "formating the EFI partition" 10 60
	echo "==========formatting the partitions UEFI"
	mkfs.fat -F32 ${diskPartition}1
	# mkswap in the swap partition
	# dialog --title "Installation -- creating the partitions UEFI" --infobox "making the swap partition" 10 60
	echo "==========making the swap partition"
	mkfs.ext4 ${diskPartition}2

	# first mount the root partition
	# dialog --title "Installation -- creating the partitions UEFI" --infobox "mounting the main partition" 10 60
	echo "==========mounting the main partition"
	mount ${diskPartition}2 /mnt

	# mount the efi partition
	mkdir -p /mnt/boot/efi
	mount ${diskPartition}1 /mnt/boot/efi
}
partition()
{
	# dialog --title "Installation -- creating the partitions" --infobox "the disk will be partitioned and formated" 10 60
	echo "===== the disk will be partitioned and formatted" 
	echo "===== non UEFI method" 
	diskPartition=$1
	echo "===== the disk partition is $diskPartition" 
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
	echo +500M # give it the 4 gigas
	echo y # delete the default format
	echo t # change the partition type
	echo 82 # use the 82 partition
	echo n # create the main partition
	echo p # make it primary
	echo   # the default
	echo   # give it the whole size
	echo   # give it the whole size
	echo y # delete the default format
	echo w # save and quit
	) | sudo fdisk $diskPartition 

	# format the root partition
	echo "===== formatting the disk"  
	echo "y" | mkfs.ext4 ${diskPartition}2  

	# format the boot partition
	echo "y" | mkfs.ext4 ${diskPartition}1

	echo "===== mounting the main partition"  
	mount ${diskPartition}2 /mnt  

	mkdir /mnt/boot
	echo " ===== mounting the boot partition"
	mount ${diskPartition}1 /mnt/boot 
}


InternetConnection()
{
# first configure the network connection
# start the network manager daemon
# dialog --title "Arch Water Installation" --infobox "starting the network manager" 10 60
systemctl start NetworkManager
# use the wifi
nmtui ;

# sync the time and date
# dialog --title "ArchWater Installation" --infobox "syncronizing time and date" 10 60
timedatectl set-ntp true

# try remove the sync files for ensuring the installation is correct
# dialog --title "ArchWater Installation" --infobox "removal of the currently installed packages" 10 60
rm -R /var/lib/pacman/sync/
# try installing the packages again
# dialog --title "ArchWater Installation" --infobox "sync the packages in pacman" 10 60
pacman -Sy

# update the arch linux keyring( the installation medium might be very old)
# dialog --title "ArchWater Installation" --infobox "downloading the new archlinux-keyrins to ensure installing packages" 10 60
}






# ==========================
# ========== the installation commands ======
# ==========================
chmod 777 -R ~/.local/bin/dwmUtilities

dialog --title "Installation ArchWater" --msgbox "this is the script to automate the installation of arch Water Linux, first you will need to configure the internet using the tool nmtui. which is going to be called when you press okay. make sure you quit out of it when you finished the network configuration" 0 0


reset ;
InternetConnection |& tee -a Log.txt

seePartitions=$(lsblk)
echo "$seePartitions" > partitionTmpFile.txt
sed -Ei ':a;N;$!ba;s/\r{0,1}\n/\\n/g' partitionTmpFile.txt
seePartitions=$(cat partitionTmpFile.txt)

diskPartition=$(dialog --title "partitioning the disks" --inputbox "$seePartitions\nenter the partition in with you want to install the partition" 30 80 "/dev/sda" 3>&1 1>&2 2>&3)


# check if the installation is efi or uefi

efiFolder="/sys/firmware/efi"
if [ -d "$efiFolder" ]; then
	uefi="yes"
	reset ;
	partitionUEFI $diskPartition |& tee -a Log.txt
else
	uefi="no"
	reset ;
	partition $diskPartition |& tee -a Log.txt 
fi



while [ $rootPassword != $rootConfirm ]
do
echo "Enter the password for the root user"
read rootPassword
echo "confirm the password"
read rootConfirm
done


# username
echo "Enter the username for the Installation"
read username



while [ $passconfirm != $password ]
do
echo "Enter the password for the user"
read password
echo "confirm password"
read passconfirm
done


dialog --title "Installation" --yesno "do you want to have the lightweight installation?" 17 70
if [[ $? == 0 ]]
then
	tmpPrev=$(pwd)
	cd ~/autoInstaller-ArchWater/dotFiles
	git checkout -f  lightWeight
	cd $tmpPrev
fi



# install the packages in the list
# dialog --title "Installation" --infobox "Installing the base packages base base-devel zsh linux-lts linux-firmware" 10 60
echo "===== Installing the base packages" |& tee -a Log.txt
pacstrap /mnt $(cat packages.x86_64) |& tee -a Log.txt 

if [[ $uefi -eq "yes" ]]
then
	echo "========== creating the fstab file"  |& tee -a Log.txt
	genfstab -U /mnt >> /mnt/etc/fstab  |& tee -a Log.txt
	cat /mnt/etc/fstab  |& tee -a Log.txt
else
	echo "========== generating the fstab configuration" |& tee -a Log.txt
	genfstab -U /mnt >> /mnt/etc/fstab |& tee -a Log.txt ;
	cat /mnt/etc/fstab |& tee -a Log.txt
fi

InstallationPlace=/mnt/
# install paru
# copy the installation script into the home
# dialog --title "Installation" --infobox "copying the files that we will need in the chroot environment" 10 60
echo "===== copying the files that will need in our installation" |& tee -a Log.txt
cp -r autoInstaller-ArchWater/ $InstallationPlace |& tee -a Log.txt
cp InstallationChroot.zsh $InstallationPlace |& tee -a Log.txt
cp -r dotFiles $InstallationPlace |& tee -a Log.txt
# run the script 
# dialog --title "Installation" --infobox "Running the ArchWater Installation Script" 10 60
echo "===== running the arch water installation script" |& tee -a Log.txt
arch-chroot /mnt zsh InstallationChroot.zsh $username $uefi $diskPartition $password $rootPassword
# finalization

# dialog --title "Installation" --infobox "the installation has ended\nshutdown and remove the usb" 10 60
echo "===== the installation has finished" |& tee -a Log.txt
