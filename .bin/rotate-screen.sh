#/bin/bash
#
# M3TIOR 2019
#

# These contain the XInput ID numbers for the target devices.
# This is mainly for readability
ID_MOUSE=$(xinput list --id-only 'Elan Touchpad');

# NOTE: wacom pen doesn't need to be rotated because the screen will always be
#   facing the way you want. It's not like the trackpad, where it moves with
#   the laptop when you turn it. (For my future stupidity)
ID_WACOM_PEN=$(xinput list --id-only 'WCOM50C1:00 2D1F:0012 Pen (0)');

xinput_orient_mouse_normal(){
	xinput set-prop $1 "Coordinate Transformation Matrix" \
		1 0 0 0 1 0 0 0 1;
}
xinput_orient_mouse_left(){
	xinput set-prop $1 "Coordinate Transformation Matrix" \
		0 -1 1 1 0 0 0 0 1;
}
xinput_orient_mouse_right(){
	xinput set-prop $1 "Coordinate Transformation Matrix" \
		0 1 0 -1 0 1 0 0 1;
}
xinput_orient_mouse_invert(){
	xinput set-prop $1 "Coordinate Transformation Matrix" \
		-1 0 1 0 -1 1 0 0 1;
}

case $* in
	[Dd]*|normal)
		xrandr --output eDP-1 --rotate normal;
		xinput_orient_mouse_normal $ID_MOUSE;
		xinput_orient_mouse_normal $ID_WACOM_PEN;
	;;
	[Uu]*|inverted)
		xrandr --output eDP-1 --rotate inverted;
		xinput_orient_mouse_invert $ID_MOUSE;
		xinput_orient_mouse_invert $ID_WACOM_PEN;
	;;
	[Rr]*|left)
		xrandr --output eDP-1 --rotate left;
		xinput_orient_mouse_left $ID_MOUSE;
		xinput_orient_mouse_left $ID_WACOM_PEN;
	;;
	[Ll]*|right)
		xrandr --output eDP-1 --rotate right;
		xinput_orient_mouse_right $ID_MOUSE;
		xinput_orient_mouse_right $ID_WACOM_PEN;
	;;
	*)
		echo "That's an Error Doc.";
		echo "Options are {normal,inverted,left,right}";;
esac;
