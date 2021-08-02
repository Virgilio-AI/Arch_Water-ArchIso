# 
#  AutoCommit multiple repos
#

declare -a arr=( "$HOME/.local/src/cfiles" "$HOME/.local/src/dmenu" "$HOME/.local/src/dwm" "$HOME/.local/src/dwmblocks" "$HOME/.local/src/st" "$HOME/Documents/GitRepos/ArchIso_AW" "$HOME/Documents/GitRepos/GitAutoCommit" "$HOME")


for i in "${arr[@]}"
do
	cd "$i" ;
	git status | grep -q "deleted\|modified\|untracked files present"  ; 
	if [ $? -eq 0 ] # if it found the words
	then
		st -T "floating" -g "=150x50+250+100" -e sh -c "lazygit "
	fi
done

