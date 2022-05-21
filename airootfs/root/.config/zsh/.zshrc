#lias Lines configured by zsh-newuser-install
HISTFILE=$XDG_HOME_CONFIG/zsh/.histfile
HISTSIZE=1000
SAVEHIST=10000
setopt autocd beep extendedglob nomatch notify

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select {
if [[ ${KEYMAP} == vicmd ]] ||
	[[ $1 = 'block' ]]; then
	echo -ne '\e[1 q'
elif [[ ${KEYMAP} == main ]] ||
	[[ ${KEYMAP} == viins ]] ||
	[[ ${KEYMAP} = '' ]] ||
	[[ $1 = 'beam' ]]; then
	echo -ne '\e[5 q'
fi
}
zle -N zle-keymap-select
zle-line-init() {
zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/rockhight/.config/.zshrc'

autoload -Uz compinit
# End of lines added by compinstall
#

compinit -d /$XDG_HOME_CONFIG/zsh/.zcompdump
#path variables
alias ls='ls -a --color=auto'
alias umount='umount -v'
alias mount='mount -v'
alias grep='grep --color'
#alias pacman="sudo pacman"





####################################3 prompt 


parse_git_branch() {
    git_status="$(git status 2> /dev/null)"
    pattern="On branch ([^[:space:]]*)"
    if [[ ! ${git_status} =~ "(working (tree|directory) clean)" ]]; then
        state="*"
    fi
    if [[ ${git_status} =~ ${pattern} ]]; then
      branch=${match[1]}
      branch_cut=${branch:0:35}
      if (( ${#branch} > ${#branch_cut} )); then
          echo "(${branch_cut})…${state}"
      else
          echo "(${branch})${state}"
      fi
    fi
}

setopt PROMPT_SUBST
set -o GLOB_SUBST

# neofetch --gtk-shorthand off --gtk2 off --gtk3 off --color_blocks off
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
## change sudo default editor
SUDO_EDITOR=/usr/bin/nvim
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR
export MANPAGER='nvim +Man!'


precmd() { print "" }
PROMPT='%S%F{green}%n%s%f%B%~%F{yellow} $(parse_git_branch)%f %F{red}$%f%b'



[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

