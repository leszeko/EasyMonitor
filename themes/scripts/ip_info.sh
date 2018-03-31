#!/bin/bash
# ip_info.sh script
# interface=$(ip route | head -n1 | awk '{print $5}')
read -r dev gateway <<-EOF
		$(awk '$2 == 00000000 { ip = strtonum(sprintf("0x%s", $3));
			printf ("%s\t%d.%d.%d.%d", $1,
			rshift(and(ip,0x000000ff),00), rshift(and(ip,0x0000ff00),08),
			rshift(and(ip,0x00ff0000),16), rshift(and(ip,0xff000000),24)) }' < /proc/net/route)
	EOF
if [[ "$dev" ]]
then ip=$($(whereis -b ip|awk '{print $2}') addr show dev "$dev" | awk '($1 == "inet") { print $2 }')
else echo "no connection"
fi
	
case $1 in
"") echo $dev $ip $gateway;;
"ip") echo $ip;;
"dev") echo $dev;;
"gateway") echo $gateway;;
esac
