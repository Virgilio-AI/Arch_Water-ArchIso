shopt -s extglob
## clean folders and makepkg of github repos
echo "do you want to update the data base?(y,n)"
read temp

loadAUR()
{
	baseFolder=$(basename $(pwd) )
	package=$1
	if [ $baseFolder == "PKGBUILDS" ]
	then
		echo "correct"
	else
		cd ..
	fi

# 	echo "======= needed PKGBUILDS ========= "
# 	echo $(pwd)
# 	echo " ==== $package === "
# 	read -n1

 	rm -rfdv $package &&
	paru -G $package &&
	cd $package &&
	makepkg &&
	# repo-add CustomRepo/CustomRepo.db.tar.gz $package/brave

	# get into the PKGBUILDS folder
	cd ..

	find $package -name $package*.pkg.tar.zst -exec repo-add CustomRepo/CustomRepo.db.tar.gz {} \; &&
	# paste the pkg inside of the repository
	cp -frv $package/* CustomRepo/
}

loadCustom()
{
	baseFolder=$(basename $(pwd))
	package=$1

	if [[ $baseFolder == "$package" ]]
	then
		echo "correct"
	elif [[ $baseFolder == "PKGBUILDS" ]]
	then
		cd $package
	else
		cd ../$package
	fi


# 	echo "===== needed inside the $package === "
# 	echo $(pwd)
# 	echo " ==== $package === "
# 	read -n1


	rm -vrfd !("PKGBUILD") &&
	makepkg &&

	# get into the PKGBUILDS folder
	cd ..
	# repo-add CustomRepo/CustomRepo.db.tar.gz $package/brave
	find $package -name $package*.pkg.tar.zst -exec repo-add CustomRepo/CustomRepo.db.tar.gz {} \; &&
	# paste the pkg inside of the repository
	cp -frv $package/* CustomRepo/
}




if [ $temp == "y" ] || [ $temp == "" ];
then

	# cd into the PKGBUILDS
	cd PKGBUILDS &&

	# remove the files inside the custom repo
	rm -rfd CustomRepo/* &&
	rm CustomRepo &&
	mkdir CustomRepo

	# enable sudo
	sudo echo "unlocker"

	# make packages and add them to the database

	# AUR packages
	loadAUR brave-bin &&
	loadAUR libxft-bgra &&
	loadAUR paru &&

	# personalized packages
	loadCustom dwm
	loadCustom dwmblocks
	loadCustom dmenu
	loadCustom st
	cd ..
fi

sudo rm -rfdv out ; sudo rm -rfdv work &&
sudo mkarchiso -v .
