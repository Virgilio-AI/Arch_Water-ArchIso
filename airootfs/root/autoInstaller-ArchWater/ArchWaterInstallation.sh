#!/bin/sh
# script to install ArchWater Linux on a newly arch linux
# for of luke smith larbs
# by virgilio Murillo Ochoa <virgiliomurilloochoa1@gmail.com>
# License: GNU GPLv3

### OPTIONS AND VARIABLES ###
### FUNCTIONS ###

installpkg(){ pacman --noconfirm --needed -S "$1" >/dev/null 2>&1 ;}

error() { echo "ERROR: $1" ; exit 1;}

adduserandpass() { \
	# Adds user `$name` with password $pass1.
	dialog --infobox "Adding user \"$name\"..." 4 50
	useradd -m -g wheel -s /bin/zsh "$name" >/dev/null 2>&1 ||
	usermod -a -G wheel "$name" && mkdir -p /home/"$name" && chown "$name":wheel /home/"$name"
	repodir="/home/$name/.local/src"; mkdir -p "$repodir"; chown -R "$name":wheel "$(dirname "$repodir")"
	echo "$name:$pass1" | chpasswd
	unset pass1 pass2 ;}
refreshkeys() { \
	dialog --infobox "Refreshing Arch Keyring..." 4 40
	pacman -Q artix-keyring >/dev/null 2>&1 && pacman --noconfirm -S artix-keyring artix-archlinux-support >/dev/null 2>&1
	pacman --noconfirm -S archlinux-keyring >/dev/null 2>&1
	}
newperms() { # Set special sudoers settings for install (or after).
	sed -i "/#LARBS/d" /etc/sudoers
	echo "$* #LARBS" >> /etc/sudoers ;}
maininstall() { # Installs all needed programs from main repo.
	dialog --title "ArchWater Installation" --infobox "Installing \`$1\` ($n of $total). $1 $2" 5 70
	installpkg "$1"
	}
putgitrepo() { # Downloads a gitrepo $1 and places the files in $2 only overwriting conflicts
	local user=$1
	repoPath=/home/$user/autoInstaller-ArchWater/dotFiles/
	echo "git repo: $repoPath"
	userHome=/home/$user/
	echo "user home: $userHome "

	sudo rsync -aAXv "$repoPath" "$userHome"
	}
finalize(){ \
	dialog --infobox "Preparing welcome message..." 4 50
	dialog --title "All done!" --msgbox "Congrats! Provided there were no hidden errors, the script completed successfully and all the programs and configuration files should be in place.\\n\\nTo run the new graphical environment, log out and log back in as your new user, then run the command \"startx\" to start the graphical environment (it will start automatically in tty1).\\n\\n.t Luke" 12 80
	}
changePermission()
{
	local user=$1
	sudo chmod -R u=rwx,g=rx,o=rx /home/$user
	sudo chown -R $user /home/$user
	sudo chgrp -R users /home/$user

	# for only for the main folder
	sudo chmod g=,o= /home/$user
	sudo chgrp wheel /home/$user

}
writeToFile()
{
	echo "picom &"
	echo "dunst &"
	echo "feh --bg-fill --randomize ~/images/background/* --bg-fill --randomize ~/images/background/* &"
	echo "dwmblocks &"
	echo "mpd &"
	echo "exec dwm"
}
waterLinuxConfig()
{
# copy the os release file
cp os-release /etc/os-release
# change the Arch LInux name in grub
sed -i "s/Arch Linux/Water Linux/" /boot/grub/grub.cfg
sed -i "s/Arch Linux/Water Linux/"  /boot/syslinux/syslinux.cfg
sed -i "s/# MENU BACKGROUND/MENU BACKGROUND/" /boot/syslinux/syslinux.cfg
}

install_python_packages()
{
	pythonPackages=$userHome/autoInstaller-ArchWater/pythonPackages
	cd pythonPackages


	pip install --no-index --find-links $pythonPackages/ -r requirements.txt
}


### THE ACTUAL SCRIPT ###

### This is how everything happens in an intuitive format and order.

username=$1
password=$2
rootPassword=$3
uefi=$4
diskPartition=$5


### The rest of the script requires no user input.

# Refresh Arch keyrings.
# refreshkeys || error "Error automatically refreshing Arch keyring. Consider doing so manually."



dialog --title "ArchWater Installation" --infobox "Synchronizing system time to ensure successful and secure installation of software..." 4 70
ntpdate 0.us.pool.ntp.org >/dev/null 2>&1


[ -f /etc/sudoers.pacnew ] && cp /etc/sudoers.pacnew /etc/sudoers # Just in case



# Make pacman and paru colorful and adds eye candy on the progress bar because why not.
grep -q "^Color" /etc/pacman.conf || sed -i "s/^#Color$/Color/" /etc/pacman.conf
grep -q "ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

# Use all cores for compilation.
sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf

# Install the dotfiles in the user's home directory
putgitrepo $username
rm -f "/home/$name/README.md" "/home/$name/LICENSE" "/home/$name/FUNDING.yml"
# make git ignore deleted LICENSE & README.md files
git update-index --assume-unchanged "/home/$name/README.md" "/home/$name/LICENSE" "/home/$name/FUNDING.yml"


# Make zsh the default shell for the user.
chsh -s /bin/zsh "$name" >/dev/null 2>&1
sudo -u "$name" mkdir -p "/home/$name/.cache/zsh/"

# # dbus UUID must be generated for Artix runit.
# dbus-uuidgen > /var/lib/dbus/machine-id
# 
# # Use system notifications for Brave on Artix
# echo "export \$(dbus-launch)" > /etc/profile.d/dbus.sh

# Tap to click
[ ! -f /etc/X11/xorg.conf.d/40-libinput.conf ] && printf 'Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
	# Enable left mouse button by tapping
	Option "Tapping" "on"
EndSection' > /etc/X11/xorg.conf.d/40-libinput.conf

# Fix fluidsynth/pulseaudio issue.
grep -q "OTHER_OPTS='-a pulseaudio -m alsa_seq -r 48000'" /etc/conf.d/fluidsynth ||
	echo "OTHER_OPTS='-a pulseaudio -m alsa_seq -r 48000'" >> /etc/conf.d/fluidsynth

# Start/restart PulseAudio.
killall pulseaudio; sudo -u "$name" pulseaudio --start

# This line, overwriting the `newperms` command above will allow the user to run
# serveral important commands, `shutdown`, `reboot`, updating, etc. without a password.
dialog --title "display manager" --yesno "do you want to have the display manager start on startup?\nthe default option is yes.\nthis will modify /etc/profile file, so if you want to preserve previous configurations of you want to conifgure this file yoursel select no" 14 70





# create the xinitrc file
mkdir -p /home/$username/.config/X11
cp /etc/X11/xinit/xinitrc /home/$username/.config/X11/xinitrc
head -n -5 /home/$username/.config/X11/xinitrc > temp.txt
cp temp.txt /home/$username/.config/X11/xinitrc

writeToFile >> /home/$username/.config/X11/xinitrc




if [[ $? == 0 ]]
then
	cd /home/$username/autoInstaller-ArchWater
	cp profile /etc/profile |& tee -a Log.txt
fi


# change the arch liunx config to water linux
waterLinuxConfig

dialog --title "zsh configuration" --yesno "do you want to overwrite the zsh configuration?" 17 70

if [[ $? == 0 ]]
then
	cd /home/$username/autoInstaller-ArchWater
	mkdir -p /home/$username/.config/zsh
	rsync -aAXv --delete zdotdir/ /home/$username/.config/zsh/ |& tee -a Log.txt
	rsync -aAXv --delete etcZdotdir/ /etc/zsh/ |& tee -a Log.txt
fi

changePermission $username

# Last message! Install complete!
finalize
clear
