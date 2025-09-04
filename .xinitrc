#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then







    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then







    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

WM="crowm"

#xsetroot -cursor_name left_ptr &
if [ "$(xrandr | awk '/HDMI-2/ { print $2 }')" = "disconnected" ]; then
	xrandr --output DP-1 --primary --mode 1920x1080 --set "Broadcast RGB" "Full" --output HDMI-2 --off
else
	xrandr --output DP-1 --primary --mode 1920x1080 --output HDMI-2 --mode 1360x768 --right-of DP-1
fi
setxkbmap ca
picom -b &
hsetroot -fill "$HOME"/Pictures/defwall.jpg
dunst &
#lxpolkit &
sxhkd &
exec /usr/bin/crowm
case "$WM" in
	crowm)	.local/bin/launch &
		exec /usr/bin/crowm
		;;
	raven)	.local/bin/statusbar.sh &
		exec /usr/bin/raven
		;;
esac
