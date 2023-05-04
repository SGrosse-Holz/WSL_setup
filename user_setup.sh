#!/bin/bash

# Instructions and script for setting up a new WSL install on a Windows machine
# Step 1: read this script, check what it does
# Step 2: run it (or the parts of it that you need)
# Step 3: set up WSL shortcuts with solarized color schemes (light/dark)
#  - from Windows, run `solarized-dark.reg`, which will set the term colors for
#    PowerShell .lnk's appropriately
#  - create a powershell shortcut, edit properties to Target = [...]/powershell.exe -Command "$env:BGCOLOR='dark'; $env:WSLENV='BGCOLOR'; wsl"
#  - copy that shortcut and switch main and popup colors to get solarized-light; also adjust above BGCOLOR='light'
# Step 4: do the manual fine tuning:
#  - check .bashrc (we just append to it instead of copying a whole file)
#  - fix colors of bash prompt:
#    locate the line below in ~/.bashrc and replace 01;32 and 01;34 with 32 and
#    34 respectively
# OLD: PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# NEW: PS1='${debian_chroot:+($debian_chroot)}\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[00m\]\$ '
# Step 5: Other things to do on a new Ubuntu:
#  - tell git who you are
#  	git config --global user.name "name"
#  	git config --global user.email "you@example.com"
#  - authenticate to GitHub
#  	sudo apt install gh
#  	gh auth login

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# dotfiles
cp    $SCRIPT_DIR/dircolors            ~/.dircolors            # ls coloring
cp    $SCRIPT_DIR/byobu_bashrc         ~/.byobu_bashrc         # byobu prompt coloring
cp -r $SCRIPT_DIR/zathura_config       ~/.config/zathura       # zathura in solarized colors
cp    $SCRIPT_DIR/zathura_from_windows ~/.zathura_from_windows # enable zathura --synctex-forward [...] calls from Windows
mkdir -p                               ~/.config/git           # 
cp    $SCRIPT_DIR/gitignore            ~/.config/git/ignore    # global gitignore

# Add a few modifications to .bashrc
cat $SCRIPT_DIR/bashrc_append >> ~/.bashrc

# ssh keys
read -p "Generate ssh keys? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
	ssh-keygen
	read -p "Copy these keys to this ssh server (leave blank to skip): "
	if [[ ! -z $REPLY ]]
	then
		ssh-copy-id $REPLY
	fi

fi

# vim
read -p "Set up vim? " -n 1
if [[ $REPLY =~ ^[Yy]$ ]]
then
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	cp $SCRIPT_DIR/vimrc_Linux_plugsonly ~/.vimrc
	vim +PlugInstall +qall
	cp $SCRIPT_DIR/vimrc_Linux ~/.vimrc
fi
