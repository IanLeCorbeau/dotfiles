#!/bin/sh

## deploy.sh by Ian LeCorbeau. Quickly install necessary packages and deploy dotfiles
## over a clean Debian netinstall. Essentially, creates a clone of my daily driver with
## dwm, st, dmenu et all.
## Do not run this script as root!

SRC_DIR=~/.local/src
DOT_DIR=dotfiles
GIT_SRC=https://github.com/I-LeCorbeau

install_pkgs() {
	echo
	printf '%s\n' "Installing packages" && sleep 1
	sudo apt install alsa-utils apt-utils build-essential calcurse dunst ffmpeg firefox-esr \
		git libx11-dev libxft-dev libxinerama-dev libnotify-bin lxpolkit man-db mpv \
		scrot sxiv sxhkd udisks2 ufw vim picom x11-xserver-utils xclip xdg-user-dirs \
		mutt newsboat xdg-utils xinit xserver-xorg-core xwallpaper zathura vifm youtube-dl -y
}

enable_firewall() {
	echo
	printf '%s\n' "Enabling firewall" && sleep 1
	sudo ufw enable
}

make_userdirs() {
	xdg-user-dirs-update
}

get_sl_tools() {
	echo
	printf '%s\n' "Getting custom Suckless tools repositories" && sleep 1
	mkdir -p "$SRC_DIR"
	cd "$SRC_DIR" || exit
	git clone "$GIT_SRC"/dwm.git
	git clone "$GIT_SRC"/dmenu.git
	git clone "$GIT_SRC"/st.git
}

install_dwm() {
	echo
	printf '%s\n' "Building and installing custom Suckless tools" && sleep 1
	cd "$SRC_DIR"/dwm || exit
	make
	sudo make clean install
}

install_dmenu() {
	cd "$SRC_DIR"/dmenu || exit
	make
	sudo make clean install
}

install_st() {
	cd "$SRC_DIR"/st || exit
	make
	sudo make clean install
}

get_dotfiles() {
	echo
	printf '%s\n' "Getting dotfiles" && sleep 1
	cd "$SRC_DIR" || exit
	git clone "$GIT_SRC"/dotfiles.git
}

deploy_dotfiles() {
	echo
	printf '%s\n' "Deploying dotfiles" && sleep 1
	for file in dunst mpv mutt newsboat picom sxhkd vifm ; do cp -r "$SRC_DIR"/"$DOT_DIR"/.config/"$file" ~/.config/ ; done
	for file in chwall-dmenu mpvload netcon poweroffreboot statusbar.sh usbmount usbunmount usbpoweroff ; do cp -r "$SRC_DIR"/"$DOT_DIR"/.local/bin ~/.local/ ; done
	mkdir -p ~/.local/share
	cp -r "$SRC_DIR"/"$DOT_DIR"/.local/share/fonts ~/.local/share/
	mkdir -p ~/Pictures	# In case xdg-user-dirs-update failed for some reason
	cp -r "$SRC_DIR"/"$DOT_DIR"/Pictures/Wallpapers ~/Pictures/
	touch ~/Pictures/defwall.jpg
	ln -sf ~/Pictures/Wallpapers/wallpaper0002.jpg ~/Pictures/defwall.jpg
	for file in .vimrc .xinitrc .Xresources ; do cp -r "$SRC_DIR"/"$DOT_DIR"/"$file" ~/ ; done
}

set_permissions() {
	printf '%s\n' "Setting permissions" && sleep 1
	cd ~/.local/bin || exit
	for file in chwall-dmenu mpvload netcon poweroffreboot statusbar.sh usbmount usbunmount usbpoweroff ; do chmod u+x "$file" ; done
}

finish() {
	printf '%s\n' "Installation done. Might want to reboot for good measure."
}

main() {
	install_pkgs
	enable_firewall
	make_userdirs
	get_sl_tools
	install_dwm
	install_dmenu
	install_st
	get_dotfiles
	deploy_dotfiles
	set_permissions
	finish
}

main
