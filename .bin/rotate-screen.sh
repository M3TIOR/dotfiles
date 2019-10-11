#/bin/bash
#
# M3TIOR 2019
#


case $* in
	[Dd]*|normal)
		xrandr --output eDP-1 --rotate normal;
		xinput set-prop 13 "Coordinate Transformation Matrix" \
        		1 0 0 0 1 0 0 0 1;;
	[Uu]*|inverted)
		xrandr --output eDP-1 --rotate inverted;
        	xinput set-prop 13 "Coordinate Transformation Matrix" \
        		-1 0 1 0 -1 1 0 0 1;;
	[Rr]*|left)
		xrandr --output eDP-1 --rotate left;
        	xinput set-prop 13 "Coordinate Transformation Matrix" \
        		0 -1 1 1 0 0 0 0 1;;
	[Ll]*|right)
		xrandr --output eDP-1 --rotate right;
        	xinput set-prop 13 "Coordinate Transformation Matrix" \
        		0 1 0 -1 0 1 0 0 1;;
	*)
		echo "That's an Error Doc.";
		echo "Options are {normal,inverted,left,right}";;
esac;


