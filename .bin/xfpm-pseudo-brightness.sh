#!/bin/bash

# M3TIOR 2019

icon=/usr/share/icons/elementary-xfce/notifications/48/xfpm-brightness-lcd.png;
mgr=xfpm-power-backlight-helper;

calc(){ python3 -c "print(round($1))"; };
max_power(){ $mgr --get-max-brightness; };
cur_power(){ $mgr --get-brightness; };
inc_power(){ calc "`max_power` / 20"; };

notify(){
        local power=$(calc "(`cur_power` / `max_power`) * 100");

	notify-send.sh \
			-R /tmp/pssbright.cache \
			-i $icon \
			-a "Brightness" \
			-h string:synchronous:my-progress "PROGRESS" \
			-h int:value:$power;
}

inc(){ pkexec $mgr --set-brightness $(calc "int(`cur_power` + `inc_power`)"); };
dec(){ pkexec $mgr --set-brightness $(calc "int(`cur_power` - `inc_power`)"); };
up(){ inc; notify; };
down(){ dec; notify; };

if [ "$1" == 'up' ]; then
	up;
elif [ "$1" == 'down' ]; then
	down;
fi;
