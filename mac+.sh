#!/bin/sh
#
# Add a number to MAC address
#

if test -z "$2" -a -z "$1";then
	echo "$0 [interface] <num>"
fi

if ! test -z "$2";then
	hw="$1"
	num=$2
else
	hw="eth0"
	num=$1
fi

mac=`ifconfig eth0 | grep -o "\<HWaddr\>\s*[a-z0-9:]*" | awk '{print $2}'`

end=`echo $mac | awk -F ':' '{print $6}'`
end=$((0x$end))
end=`echo "obase=16;$(($end+$num))" | bc`

mac=${mac%:*}:$end

sudo ifconfig eth0 down
sudo ifconfig eth0 hw ether $mac
sudo ifconfig eth0 up
