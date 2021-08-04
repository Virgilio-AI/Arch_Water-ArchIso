#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="archWaterLinux"
iso_label="ARCH_$(date +%Y%m)"
iso_publisher="Arch Linux <https://archlinux.org>"
iso_application="Arch Linux Live/Rescue CD"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"

  ["/root/.local/bin/gitAutoCommit.sh"]="0:0:777"
  ["/root/.local/bin/open_cfiles.sh"]="0:0:777"
  ["/root/.local/bin/open_nvim.sh"]="0:0:777"
  ["/root/.local/bin/open_pass"]="0:0:777"
  ["/root/.local/bin/st-nvim-wrapper"]="0:0:777"
  ["/root/.local/bin/sysbackup"]="0:0:777"
  ["/root/.local/bin/sysrestore"]="0:0:777"

  ["/root/.local/bin/statusbar"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-battery"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-clock"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-cpu"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-cpubars"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-disk"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-doppler"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-forecast"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-help-icon"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-internet"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-iplocate"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-kbselect"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-mailbox"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-memory"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-moonphase"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-mpdup"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-music"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-nettraf"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-news"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-packages"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-popupgrade"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-price"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-task"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-torrent"]="0:0:777"
  ["/root/.local/bin/statusbar/sb-volume"]="0:0:777"

  ["/root/.xinitrc"]="0:0:777"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/usr/local/bin/Installation_guide"]="0:0:755"
  ["/usr/local/bin/livecd-sound"]="0:0:755"

)
