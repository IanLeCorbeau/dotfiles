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

#xsetroot -cursor_name left_ptr &
xrandr --output DP-1 --primary --mode 1920x1080 --set "Broadcast RGB" "Full" --output HDMI-1 --off
picom -b &
xwallpaper --stretch ~/Pictures/defwall.jpg &
dunst &
lxpolkit &
sxhkd &
.local/bin/statusbar.sh &
exec /usr/local/bin/dwm
#exec bspwm
#exec /usr/bin/cwm
