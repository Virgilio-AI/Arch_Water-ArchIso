shopt -s extglob


MY_PATH=$(dirname "$0")            # relative
MY_PATH=$(cd "$MY_PATH" && pwd)    # absolutized and normalized
if [[ -z "$MY_PATH" ]] ; then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  exit 1  # fail
fi
echo "$MY_PATH"

archisoRoot=$MY_PATH


echo $archisoRoot

## clean folders and makepkg of github repos
echo "do you want to update the data base?(y,n)"
read temp
echo "do you want to update offline packages?(y,n)"
read update


# enable sudo
sudo echo "unlocker"



loadAUR()
{
	package=$1

 	rm -rfdv $archisoRoot/PKGBUILDS/$package
	cd $archisoRoot/PKGBUILDS
	paru -G $package
	cd $package
	makepkg
	# repo-add CustomRepo/CustomRepo.db.tar.gz $package/brave

	# get into the PKGBUILDS folder
	cd $archisoRoot/PKGBUILDS

	find $package -name $package*.pkg.tar.zst -exec repo-add CustomRepo/CustomRepo.db.tar.gz {} \;
	find $package -name $package*.pkg.tar.xz -exec repo-add CustomRepo/CustomRepo.db.tar.gz {} \;
	# paste the pkg inside of the repository
	cp -frv $package/* CustomRepo/
}

loadCustom()
{
	package=$1
	cd $archisoRoot/PKGBUILDS/$package
	rm -vrfd !("PKGBUILD")
	makepkg

	# get into the PKGBUILDS folder
	cd $archisoRoot/PKGBUILDS
	# repo-add CustomRepo/CustomRepo.db.tar.gz $package/brave
	find $package -name $package*.pkg.tar.zst -exec repo-add CustomRepo/CustomRepo.db.tar.gz {} \;
	find $package -name $package*.pkg.tar.xz -exec repo-add CustomRepo/CustomRepo.db.tar.gz {} \;
	# paste the pkg inside of the repository
	cp -frv $package/* CustomRepo/
}
repo_add()
{
	package=$1
	# repo-add CustomRepo/CustomRepo.db.tar.gz $package/brave
	find $archisoRoot/PKGBUILDS/$package -name $package*.pkg.tar.zst -exec repo-add $archisoRoot/airootfs/root/custom/CustomRepo.db.tar.gz {} \;
	find $archisoRoot/PKGBUILDS/$package -name $package*.pkg.tar.xz -exec repo-add $archisoRoot/airootfs/root/custom/CustomRepo.db.tar.gz {} \;
	# paste the pkg inside of the repository
	cp -frv $archisoRoot/PKGBUILDS/$package/* $archisoRoot/airootfs/root/custom/
}




if [ $temp == "y" ] || [ $temp == "" ];
then

	# cd into the PKGBUILDS
# 	cd $archisoRoot/PKGBUILDS
# 
# 
# #	# remove the files inside the custom repo
	rm -rfdv $archisoRoot/PKGBUILDS/CustomRepo/*
	rm -rfdv $archisoRoot/PKGBUILDS/CustomRepo
	mkdir $archisoRoot/PKGBUILDS/CustomRepo




	# make packages and add them to the database

	# AUR packages
	loadAUR brave-bin &&
	loadAUR libxft-bgra &&
	loadAUR paru &&
	loadAUR ttf-nerd-fonts-symbols &


	# personalized packages
	loadCustom dwm
	loadCustom dwmblocks
	loadCustom dmenu
	loadCustom st
	cd $archisoRoot/PKGBUILDS
fi

if [[ $update == "y" ]]
then

	sed "s|\(Server = file://\).\+|\1/root/custom|g" -i $archisoRoot/airootfs/etc/pacman.conf



	# borramos el repo principal del root
	# para llenarlo con paquetes nuevos
	echo "about to delete"
	mkdir $archisoRoot/airootfs/root/custom
	echo $archisoRoot/airootfs/root/custom/*
	read -n1
	rm -rfdv $archisoRoot/airootfs/root/custom/*


	# agregamos la base de datos existente
	# con todos los paquetes compilados
	cp -rvf $archisoRoot/PKGBUILDS/CustomRepo/* $archisoRoot/airootfs/root/custom/

# 	# borramos la base de datos
# 	echo "about to delete /root/custom/Custom*"
# 	read -n1
# 	rm -rfdv /root/custom/Custom*
# 
# 	echo "pause to see deleted files"
# 	read -n1

	
	# agregamos los paquetes de la lista de pacman
	mkdir -p $archisoRoot/airootfs/root/blankdb
	sudo pacman -Sywv --cachedir $archisoRoot/airootfs/root/custom --dbpath $archisoRoot/airootfs/root/blankdb $(cat $archisoRoot/packages.txt)

	# mkdir $archisoRoot/etc/blankdb
	# sudo pacman -Sywv --cachedir /root/custom --dbpath  $archisoRoot/etc/blankdb   $(cat $archisoRoot/packages.txt)

	echo "pause to check pacman installed packages"
	read -n1
	repo-add $archisoRoot/airootfs/root/custom/CustomRepo.db.tar.gz $archisoRoot/airootfs/root/custom/*.zst
	repo-add $archisoRoot/airootfs/root/custom/CustomRepo.db.tar.gz $archisoRoot/airootfs/root/custom/*.xz

	echo "pause for analysing repo add"
	read -n1







	repo_add brave-bin
	repo_add libxft-bgra
	repo_add paru

	# personalized packages
	repo_add dwm
	repo_add dwmblocks
	repo_add dmenu
	repo_add st



fi

cd $archisoRoot
sudo rm -rfdv $archisoRoot/out ; sudo rm -rfdv $archisoRoot/work

customRepo=$archisoRoot/PKGBUILDS/CustomRepo

sed "s|\(Server = file://\).\+|\1$(pwd)/PKGBUILDS/CustomRepo|g" -i $(pwd)/pacman.conf
sudo mkarchiso -v .
