#!/bin/bash

## debstrap.sh by Ian LeCorbeau: a simple debootstrapping script that will
## install a custom, minimal Debian system.

# Using a few variables for convenience
DEVICE=$1
BOOTMODE=$2
SWAPSPACE=1
ROOTSPACE=8
HOMESPACE=

## 'set -e' should really only be enabled for debugging purposes. Though it might seem
## useful to have the script exit when there's an error, the reality is that some errors
## are normal and expected (such as debconf errors) and the last thing you want is for the
## script to fail 3/4 of the way through because of something inconsequential.
#set -e

usage() {
	printf '%s\n' "You must provide the name of the device on which the system is to be installed (eg: sda) and the boot mode (bios or efi)"
	exit
}

print_dev() {
	sed -i "s/DEVICE/$DEVICE/g" debstrap_in_chroot.sh
	sed -i "s/BOOTMODE=/BOOTMODE=$BOOTMODE/g" debstrap_in_chroot.sh
}

get_deps() {
	printf '%s\n' "Getting installer dependencies" &&
	apt update && apt install debootstrap arch-install-scripts curl -y
}

makepart() {
	echo
	printf "The system will be installed on /dev/$DEVICE in $BOOTMODE mode. Proceed? (Y/n): "
	read -r answer
	if [ "$answer" = n ]; then
		printf '%s\n' "Exiting script. Start again"
		exit
	else
		echo
		printf '%s\n' "Partitioning /dev/$DEVICE."
		sfdisk --delete /dev/"$DEVICE"
		partprobe /dev/"$DEVICE"
		if [ "$BOOTMODE" = "bios" ]; then
			(echo o) | fdisk /dev/"$DEVICE"
			(echo n; echo p; echo 1; echo ; echo +"$SWAPSPACE"G; echo w) | fdisk /dev/"$DEVICE"
			sfdisk --part-type /dev/"$DEVICE" 1 82
			(echo n; echo p; echo 2; echo ; echo +"$ROOTSPACE"G; echo w) | fdisk /dev/"$DEVICE"
			if [ -z "$HOMESPACE" ]; then
				(echo n; echo p; echo 3; echo ; echo ; echo w) | fdisk /dev/"$DEVICE"
			else
				(echo n; echo p; echo 3; echo ; echo +"$HOMESPACE"G; echo w) | fdisk /dev/"$DEVICE"
			fi

			partprobe /dev/"$DEVICE" && sleep 1
			printf '%s\n' "Creating Partitions" && sleep 1
			mkswap /dev/"$DEVICE"1
			swapon /dev/"$DEVICE"1
			mkfs.ext4 /dev/"$DEVICE"2
			mkfs.ext4 /dev/"$DEVICE"3

			printf '%s\n' "Mounting Partitions" && sleep 1
			mount /dev/"$DEVICE"2 /mnt
			mkdir -p /mnt/home
			mount /dev/"$DEVICE"3 /mnt/home	
		else
			echo
			printf '%s\n' "Partitioning /dev/$DEVICE."
			sfdisk --delete /dev/"$DEVICE" && sleep 1
			partprobe /dev/"$DEVICE" && sleep 1
			(echo g) | fdisk /dev/"$DEVICE"
			(echo n; echo p; echo 1; echo 2048; echo +600M; echo w) | fdisk /dev/"$DEVICE"
			sfdisk --part-type /dev/"$DEVICE" 1 EF
			(echo n; echo p; echo 2; echo ; echo +"$SWAPSPACE"G; echo w) | fdisk /dev/"$DEVICE"
			sfdisk --part-type /dev/"$DEVICE" 2 82
			(echo n; echo p; echo 3; echo ; echo +"$ROOTSPACE"G; echo w) | fdisk /dev/"$DEVICE"
			if [ -z "$HOMESPACE" ]; then
				(echo n; echo p; echo 4; echo ; echo ; echo w) | fdisk /dev/"$DEVICE"
			else
				(echo n; echo p; echo 4; echo ; echo +"$HOMESPACE"G; echo w) | fdisk /dev/"$DEVICE"
			fi
	
			partprobe /dev/"$DEVICE" && sleep 1
			printf '%s\n' "Creating Partitions" && sleep 1
			mkfs.fat -F 32 /dev/"$DEVICE"1
			mkswap /dev/"$DEVICE"2
			swapon /dev/"$DEVICE"2
			mkfs.ext4 /dev/"$DEVICE"3
			mkfs.ext4 /dev/"$DEVICE"4
	
			printf '%s\n' "Mounting Partitions" && sleep 1
			mount /dev/"$DEVICE"3 /mnt
			mkdir -p /mnt/home
			mkdir -p /mnt/boot
			mount /dev/"$DEVICE"4 /mnt/home
	
		fi
	fi
}

bootstrap() {
	echo
	printf '%s\n' "Deboostraping base system" && sleep 1
	/usr/sbin/debootstrap --variant=minbase bullseye /mnt http://deb.debian.org/debian/
}

gen_fstab() {
	echo
	printf '%s\n' "Generating fstab..." && sleep 1
	genfstab -U /mnt >> /mnt/etc/fstab
}

apt_src_list() {
	echo
	printf '%s\n' "Generating apt sources.list" && sleep 1
	printf '%s\n' "deb http://deb.debian.org/debian/ bullseye main contrib non-free
deb-src http://deb.debian.org/debian/ bullseye main contrib non-free

deb http://security.debian.org/debian-security bullseye-security main contrib non-free
deb-src http://security.debian.org/debian-security bullseye-security main contrib non-free

deb http://deb.debian.org/debian/ bullseye-updates main contrib non-free
deb-src http://deb.debian.org/debian/ bullseye-updates main contrib non-free" > /mnt/etc/apt/sources.list
}

get_files() {
	printf '%s\n' "Fetching custom .profile and .bash_aliases" && sleep 1
	curl -O https://raw.githubusercontent.com/I-LeCorbeau/debian-live-build/main/config/includes.chroot_after_packages/etc/skel/.bash_aliases
	mv .bash_aliases /mnt/etc/skel/.bash_aliases
	curl -O https://raw.githubusercontent.com/I-LeCorbeau/debian-live-build/main/config/includes.chroot_after_packages/etc/skel/.profile
	mv .profile /mnt/etc/skel/.profile
}

cpfiles() {
	cp /etc/adjtime /mnt/etc/adjtime
	cp debstrap_in_chroot.sh /mnt/debstrap_in_chroot.sh
	chmod +x /mnt/debstrap_in_chroot.sh
}

get_in_chroot() {
	arch-chroot /mnt ./debstrap_in_chroot.sh
}

main(){
	print_dev
	get_deps
	makepart
	bootstrap
	gen_fstab
	apt_src_list
	get_files
	cpfiles
	get_in_chroot
}

if [ -z "$1" ]; then
	usage
else
	main
fi
