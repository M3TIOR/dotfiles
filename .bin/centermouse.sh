#!/bin/sh -e
# puts the mouse in the center of the active window.
UID=`id -u`;


centermouse(){
  local x y w h;
  eval $(xwininfo -id $(xdotool getactivewindow) |
    sed -n -e "s/^ \+Absolute upper-left X: \+\([0-9]\+\).*/x=\1/p" \
           -e "s/^ \+Absolute upper-left Y: \+\([0-9]\+\).*/y=\1/p" \
           -e "s/^ \+Width: \+\([0-9]\+\).*/w=\1/p" \
           -e "s/^ \+Height: \+\([0-9]\+\).*/h=\1/p" );

  xdotool mousemove $((x + w/2)) $((y + h/2));
}

centermoused(){
	echo "Running daemon";
	while test -e /run/user/$UID/centermoused.pid; do centermouse; sleep $1; done;
	echo "Stopped";
}

centermouse_sh(){
	local OPTARG; OPTARG='';
	local OPTIND; OPTIND=0;

	local SLEEP_INTERVAL; SLEEP_INTERVAL=0.20; 
	local PIDFILE;
	PIDFILE=/run/user/$UID/centermoused.pid;
	while getopts ":kds:" arg $@; do
		case $arg in
			'k')
				echo "Killing old daemon @PID:$(cat $PIDFILE)";
				kill -2 `cat $PIDFILE`;
				rm -vf $PIDFILE;
				exit 0;
			;;
			's')
				# Ensure optarg is a number using matcher expression.
				if (! test -z "${OPTARG##*[!0-9.]*}"); then
					SLEEP_INTERVAL=$OPTARG;
				else
					echo "The argument '-s' must be a real number, you passed '$OPTARG'." >&2;
					exit 1;
				fi;
			;;
			'd')
				if (test -f $PIDFILE); then
					echo "The daemon's already running @PID:$(cat $PIDFILE)" >&2;
					exit 1;
				else
					echo $$ > $PIDFILE;
					trap "rm -vf $PIDFILE" HUP INT QUIT ABRT TERM KILL EXIT;
					#sleep 1;
					centermoused $SLEEP_INTERVAL;
				fi;
			;;
			[?])
				echo "Usage: $0 [-s SECONDS] [-kd]" >&2;
				exit 1;
			;;
		esac;
	done;
	
	centermouse;
}

centermouse_sh $@;
