shopt -s extglob &&

MY_PATH=$(dirname "$0")            # relative
MY_PATH=$(cd "$MY_PATH" && pwd)    # absolutized and normalized
if [[ -z "$MY_PATH" ]] ; then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  exit 1  # fail
fi

# 
# rm -rfdv $rootArchiso/PKGBUILDS/brave-bin &&
# mkdir $rootArchiso/PKGBUILDS/brave-bin &&
# rm -rfdv $rootArchiso/PKGBUILDS/libxft-bgra &&
# mkdir $rootArchiso/PKGBUILDS/libxft-bgra &&
# rm -rfdv $rootArchiso/PKGBUILDS/paru &&
# mkdir $rootArchiso/PKGBUILDS/paru &&
# rm -rfdv $rootArchiso/PKGBUILDS/vim-plug &&
# mkdir $rootArchiso/PKGBUILDS/vim-plug &&
# # repo-add all the packages
# rm -rfd $rootArchiso/PKGBUILDS/CustomRepo/*





# global functions
rootArchiso=$MY_PATH
PKGBUILDS=$rootArchiso/PKGBUILDS


personal_packages=("dwm" "dwmblocks" "dmenu" "st")
AUR_packages=("brave-bin" "libxft-bgra" "paru" "vim-plug" "ttf-nerd-fonts-symbols" "vim-plug")
folders=("$PKGBUILDS/CustomRepo/*" "$rootArchiso/out/*" "$rootArchiso/work/*")





rm_personal_packages()
{
	local -n packages=$1
	for ((i=0;i< ${#packages[@]} ;i+=1));
	do
		rm_personal_package ${packages[i]}
	done
}
rm_personal_package()
{
	package_name=$1
	echo $package_name
	cd $PKGBUILDS/$package_name
	echo "about to delete: $(pwd)"
	read -n1 &&
	rm -vrfd !("PKGBUILD")
}

rm_AUR_package()
{
	pkg_name=$1
	toDelete=$PKGBUILDS/$pkg_name
	echo "about to delete: $toDelete"
	read -n1 &&
	rm -rfdv $toDelete &&
	sudo mkdir $PKGBUILDS/$pkg_name
}
rm_AUR_packages()
{
	local -n packages=$1
	echo ${packages[@]}

	for ((i=0;i< ${#packages[@]} ;i+=1));
	do
		pkg=${packages[i]}
		rm_AUR_package $pkg
	done
}
rm_python_packages()
{
	toDelete=$rootArchiso/airootfs/root/autoInstaller-ArchWater/pythonPackages
	cd $toDelete
	echo "about to delete: $(pwd)"
	read -n1 &&
	rm -vrfd !("requirements.txt")
}



# =============
# === The main script
# =============


rm_personal_packages personal_packages
rm_AUR_packages AUR_packages
rm_python_packages

echo "about to delete ${folders[@]}" &&
	read -n1 && 
sudo rm -rfdv ${folders[@]}
