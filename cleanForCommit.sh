
shopt -s extglob &&

# clean work and out directories
sudo rm -rfd out ; sudo rm -rfd work ;

## clean folders and makepkg of github repos

cd PKGBUILDS/dwm/ &&
rm -vrfd !("PKGBUILD") &&

cd ../dwmblocks &&
rm -vrfd !("PKGBUILD") &&

cd ../cfiles &&
rm -vrfd !("PKGBUILD") &&

cd ../dmenu &&
rm -vrfd !("PKGBUILD") &&

cd ../st &&
rm -vrfd !("PKGBUILD") &&

# clean arch packages and makepkg
cd .. &&
rm -rfdv brave-bin &&
mkdir brave-bin &&
rm -rfdv libxft-bgra &&
mkdir libxft-bgra &&
rm -rfdv paru &&
mkdir paru &&
rm -rfdv vim-plug &&
mkdir vim-plug &&
# repo-add all the packages
rm -rfd CustomRepo/* 
