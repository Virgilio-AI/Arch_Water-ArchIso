functionst()
{
	echo +4G # give it the 4 gigas 
	echo y
	echo t # change the partition type
	echo 82 # use the 82 partition
	echo n # create the main partition
	echo p # make it primary
	echo
	echo
	echo y
}

partitionDisk()
{
	# dialog --title "Installation -- creating the partitions" --infobox "the disk will be partitioned and formated" 10 60
	echo "===== the disk will be partitioned and formatted" |& tee -a Log.txt
	echo "===== non UEFI method" |& tee -a Log.txt
	diskPartition='/dev/sda'
	echo "===== the disk partition is $diskPartition" |& tee -a Log.txt
	(
	echo d # ======= delete all the partitions
	echo
	echo
	echo d # delete all the partitions
	echo
	echo
	echo d # delete all the partitions
	echo
	echo
	echo d # delete all the partitions
	echo
	echo
	echo o # ======= create a dos partition table
	echo n # create the swap partition
	echo p # make it primary
	echo   # default partition number
	echo   # default first sector
	echo +4G # give it the 4 gigas 
	echo y
	echo t # change the partition type
	echo 82 # use the 82 partition

	echo n # create the main partition
	echo p # make it primary
	echo
	echo
	echo
	echo y
	echo p # print the main partition
	echo w # save and quit
	) | sudo fdisk $diskPartition |& tee -a Log.txt 
}
partitionDisk

