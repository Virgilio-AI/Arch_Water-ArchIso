shopt -s extglob
## clean folders and makepkg of github repos
echo "do you want to update the data base?(y,n)"
read temp
if [ $temp == "y" ] || [ $temp == "" ];
then
	
	cd PKGBUILDS/dwm/ &&
	rm -vrfd !("PKGBUILD") &&
	makepkg &&
	
	cd ../dwmblocks &&
	rm -vrfd !("PKGBUILD") &&
	makepkg &&
	
	cd ../cfiles &&
	rm -vrfd !("PKGBUILD") &&
	makepkg &&
	
	cd ../dmenu &&
	rm -vrfd !("PKGBUILD") &&
	makepkg &&
	
	cd ../st &&
	rm -vrfd !("PKGBUILD") &&
	makepkg &&
	
	# clean arch packages and makepkg
	cd .. &&
	rm -rfdv brave-bin &&
	paru -G brave-bin &&
	cd brave-bin &&
	makepkg &&
	
	cd .. &&
	rm -rfdv libxft-bgra &&
	paru -G libxft-bgra &&
	cd libxft-bgra &&
	makepkg &&
	
	
	cd .. &&
	rm -rfdv paru &&
	paru -G paru &&
	cd paru &&
	makepkg &&
	
	
	cd .. &&
	rm -rfdv vim-plug &&
	paru -G vim-plug &&
	cd vim-plug &&
	makepkg &&
	
	# repo-add all the packages
	cd .. &&
	rm -rfd CustomRepo/* &&
	
	# repo-add CustomRepo/CustomRepo.db.tar.gz brvae-bin/brave
	find brave-bin -name brave-bin*.pkg.tar.zst -exec repo-add CustomRepo/CustomRepo.db.tar.gz {} \; &&
	find cfiles -name cfiles*.pkg.tar.zst -exec repo-add CustomRepo/CustomRepo.db.tar.gz {} \; &&
	find dmenu -name dmenu*.pkg.tar.zst -exec repo-add CustomRepo/CustomRepo.db.tar.gz {} \; &&
	find dwm -name dwm*.pkg.tar.zst -exec repo-add CustomRepo/CustomRepo.db.tar.gz {} \; &&
	find dwmblocks -name dwmblocks*.pkg.tar.zst -exec repo-add CustomRepo/CustomRepo.db.tar.gz {} \; &&
	find paru -name paru*.pkg.tar.zst -exec repo-add CustomRepo/CustomRepo.db.tar.gz {} \; &&
	find st -name st*.pkg.tar.zst -exec repo-add CustomRepo/CustomRepo.db.tar.gz {} \; &&
	find vim-plug -name vim-plug*.pkg.tar.zst -exec repo-add CustomRepo/CustomRepo.db.tar.gz {} \; &&
	find libxft-bgra -name libxft-bgra*.pkg.tar.zst -exec repo-add CustomRepo/CustomRepo.db.tar.gz {} \; &&
	
	
	# paste the pkg inside of the repository
	cp -frv brave-bin/* CustomRepo/ &&
	cp -frv cfiles/* CustomRepo/ &&
	cp -frv dmenu/* CustomRepo/ &&
	cp -frv dwm/* CustomRepo/ &&
	cp -frv dwmblocks/* CustomRepo/ &&
	cp -frv paru/* CustomRepo/ &&
	cp -frv st/* CustomRepo/ &&
	cp -frv vim-plug/* CustomRepo/ &&
	cp -frv libxft-bgra/* CustomRepo/ &&
	cd ..
fi

sudo rm -rfdv out ; sudo rm -rfdv work &&
sudo mkarchiso -v .
