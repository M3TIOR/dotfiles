#!/bin/sh

#------------------------------------ BASH POLYFILLS ----------------------------------
echo (){ printf "%s\n" "$@"; };
#######################################################################################

DEFAULT_IPROUTE="";
reset_default_iproute(){
	echo "Resetting IP routing tables to their original values...";
	ip rou delete default;
	# This is the old IP Route for my machine
	#sudo ip rou add default via 192.168.49.1 dev wlp1s0 proto dhcp metric 600;
	ip rou add $DEFAULT_IPROUTE;
	echo "DONE";
};

end_pppd(){
	kill -s 3 $SECURE_TETHER_PPPD;
};

cleanup(){
	end_pppd;
	wait $SECURE_TETHER_PPPD;
	reset_default_iproute;
};


# Connects to secure tether.
echo "Connecting to SecureTether via PPPoE...";
pppd user "Default" password 123 call securetether pty "nc 192.168.49.1 8823" &
SECURE_TETHER_PPPD="$!"; # capture PID for wait call
echo "DONE --- \`pppd\` started at PID #$SECURE_TETHER_PPPD";

# Attempts to await a connection before proceding with IP Route Configuration.
sleep 2;

# Captures possible PPP routes available.
#PPP_IPROUTE_META="";
#while read line; do
#	PPP_IPROUTE_META="PPP_IPROUTE_META:$LINE";
#done < <(printf `ip rou | grep -m1 -n "ppp"`);

# Captures old IP Route information.
DEFAULT_IPROUTE=`ip rou | grep -m1 "default"`;

if test -n `echo $DEFAULT_IPROUTE | grep "ppp"`; then
	trap 'cleanup' 1 2 3 6 9;
	# (manual fix for when pppd doesn't fix the default IP route table).
	echo "Adjusting IP routing tables appropriately...";
	ip rou delete default;
	ip rou add default via 192.168.234.1 dev ppp0;
	echo "DONE";
fi;

echo "Internet should now be available!";
wait $SECURE_TETHER_PPPD;
echo "Closing down...";

# For now we do this anyway since it's no harm, even if it is redundant.
reset_default_iproute;

printf "\nDONE\n";
