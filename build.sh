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



## clean folders and makepkg of github repos
echo "do you want to update the data base?(y,n)"
read temp
echo "do you want to update offline packages?(y,n)"
read update


# enable sudo
sudo echo "enabled sudo privileges"



loadAUR()
{
	package=$1
	echo rm -rfdv $archisoRoot/PKGBUILDS/$package
	rm -rfdv $archisoRoot/PKGBUILDS/$package
	cd $archisoRoot/PKGBUILDS
	paru -G $package
	cd $package
	makepkg -s
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
	echo $(pwd)
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

gitClone()
{
	local -n lrepos=$1
	echo $lrepos
	mkdir $archisoRoot/airootfs/root/autoInstaller-ArchWater/repos
	cd $archisoRoot/airootfs/root/autoInstaller-ArchWater/repos
	for (( i=0; i<= ${#repos[@]} ; i+=1 ))
	do
		git clone ${repos[i]}
	done
}




if [ $temp == "y" ] || [ $temp == "" ];
then

	# cd into the PKGBUILDS
# 	cd $archisoRoot/PKGBUILDS
# 
# 
# #	# remove the files inside the custom repo
	echo rm -rfdv $archisoRoot/PKGBUILDS/CustomRepo/*
	echo rm -rfdv $archisoRoot/PKGBUILDS/CustomRepo

	rm -rfdv $archisoRoot/PKGBUILDS/CustomRepo/*
	rm -rfdv $archisoRoot/PKGBUILDS/CustomRepo
	mkdir $archisoRoot/PKGBUILDS/CustomRepo




	# make packages and add them to the database

	# AUR packages
	loadAUR brave-bin &&
	loadAUR libxft-bgra &&
	loadAUR paru-bin &&
	loadAUR ttf-nerd-fonts-symbols &
	loadAUR vim-plug &


	# personalized packages
	echo "y" | loadCustom dwm
	echo "y" | loadCustom dwmblocks
	echo "y" | loadCustom dmenu
	echo "y" | loadCustom st
	cd $archisoRoot/PKGBUILDS
fi

if [[ $update == "y" ]]
then

	sed "s|\(Server = file://\).\+|\1/root/custom|g" -i $archisoRoot/airootfs/etc/pacman.conf



	# borramos el repo principal del root
	# para llenarlo con paquetes nuevos
	echo "about to delete"
	mkdir $archisoRoot/airootfs/root/custom
	rm -rfdv $archisoRoot/airootfs/root/custom/*


	# agregamos la base de datos existente
	# con todos los paquetes compilados
	cp -rvf $archisoRoot/PKGBUILDS/CustomRepo/* $archisoRoot/airootfs/root/custom/


	# agregamos los paquetes de la lista de pacman
	mkdir -p $archisoRoot/airootfs/root/blankdb
	sudo pacman -Sywv --cachedir $archisoRoot/airootfs/root/custom --dbpath $archisoRoot/airootfs/root/blankdb $(cat $archisoRoot/packages.txt)

	repo-add $archisoRoot/airootfs/root/custom/CustomRepo.db.tar.gz $archisoRoot/airootfs/root/custom/*.zst
	repo-add $archisoRoot/airootfs/root/custom/CustomRepo.db.tar.gz $archisoRoot/airootfs/root/custom/*.xz


	repo_add brave-bin
	repo_add libxft-bgra
	repo_add paru-bin
	repo_add ttf-nerd-fonts-symbols
	repo_add vim-plug

	# personalized packages
	repo_add dwm
	repo_add dwmblocks
	repo_add dmenu
	repo_add st


	repos=("https://github.com/Virgilio-AI/Arch_Water-dmenu.git" "https://github.com/Virgilio-AI/Arch_water-dwm-window_manager.git" "https://github.com/Virgilio-AI/Arch_Water-dwmblocks-status_monitor.git" "https://github.com/Virgilio-AI/Arch_Water-st_terminal.git")

	# gitClone repos

	toDelete=$archisoRoot/airootfs/root/dotFiles
	echo "about to delete $toDelete"
	rm -rfd $toDelete
	cd $archisoRoot/airootfs/root/autoInstaller-ArchWater
	git clone https://github.com/Virgilio-AI/dotFiles-AW.git dotFiles
fi

cd $archisoRoot

echo sudo rm -rfdv $archisoRoot/out
echo sudo rm -rfdv $archisoRoot/work

sudo rm -rfdv $archisoRoot/out ; sudo rm -rfdv $archisoRoot/work

customRepo=$archisoRoot/PKGBUILDS/CustomRepo

sed "s|\(Server = file://\).\+|\1$(pwd)/PKGBUILDS/CustomRepo|g" -i $(pwd)/pacman.conf


sudo mkarchiso -v .
