#!/bin/bash
# network_info.sh script

################# Variables for color terminal
Color_terminal_variables() {
Green=""$'\033[00;32m'"" Red=""$'\033[00;31m'"" White=""$'\033[00;37m'"" Yellow=""$'\033[01;33m'"" Cyan=""$'\033[00;36m'"" Blue=""$'\033[01;34m'"" Magenta=""$'\033[00;35m'""
LGreen=""$'\033[01;32m'"" LRed=""$'\033[01;31m'"" LWhite=""$'\033[01;37m'"" LYellow=""$'\033[01;33m'"" LCyan=""$'\033[01;36m'"" LBlue=""$'\033[00;34m'"" LMagenta=""$'\033[01;35m'""
SmoothBlue=""$'\033[00;38;5;111m'"";Cream=""$'\033[0;38;5;225m'"";Orange=""$'\033[0;38;5;202m'""
LSmoothBlue=""$'\033[01;38;5;111m'"";LCream=""$'\033[1;38;5;225m'"";LOrange=""$'\033[1;38;5;202m'"";Blink=""$'\033[5m'""
if [[ $TERM != *xterm* ]]
then :
	Orange=$LRed LOrange=$LRed LRed=$Red SmoothBlue=$Cyan Blink=""
else :
	LRed=""$'\033[01;38;5;196m'""
fi
Nline=""$'\n'"" Reset=""$'\033[0;0m'"" EraseR=""$'\033[K'"" Back=""$'\b'"" Creturn=""$'\033[\r'"" Ctabh=""$'\033[\t'"" Ctabv=""$'\033[\v'"" SaveP=""$'\033[s'"" RestoreP=""$'\033[u'""
MoveU=""$'\033[1A'"" MoveD=""$'\033[1B'"" MoveR=""$'\033[1C'"" MoveL=""$'\033[1D'""
Linesup () { echo -n ""$'\033['$1'A'"" ;}; Linesdn () { echo ""$'\033['$1'B'"" ;}; Charsfd () { echo -n ""$'\033['$1'C'"" ;}; Charsbk ()  { echo -n ""$'\033['$1'D'"" ;}
}
Color_terminal_variables
#################
function r_ask () {
  read -p "$1 [y]es or [N]o$Blink ?:$Reset$Yellow "
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
      y|yes) echo -n "yes" ;;
      *)     echo -n "no" ;;
    esac
}

echo "$n$Orange#-----------------------------------------------------------------------------#$Reset"
echo "$n$Green # network_info.sh script # $Reset"
echo "$n$Orange#-----------------------------------------------------------------------------#$Reset"

echo "$n$Green # Command: sudo lspci -nnk | grep -i ethernet -A2 =  $Reset$n"
sudo lspci -nnk | grep -i ethernet -A2
echo "$n$Green$Blink # Done # $Reset"
echo "$n$Yellow#-----------------------------------------------------------------------------#$Reset$n"

echo "$Green # Command: sudo lshw -c network =  $Reset$n"
sudo lshw -c network
echo "$n$Green$Blink # Done # $Reset"
echo "$n$Yellow#-----------------------------------------------------------------------------#$Reset$n"

echo "$Green # Command: ls --color=auto /sys/class/net/*/device/net/*/device/driver/module/drivers/ =  $Reset$n"
ls --color=auto /sys/class/net/*/device/net/*/device/driver/module/drivers/
echo "$n$Green$Blink # Done # $Reset"
echo "$n$Yellow#-----------------------------------------------------------------------------#$Reset$n"

echo "$Green # Command: ls --color=auto /etc/*net* /etc/*Net* -CRlh = $Reset$n"
ls --color=auto /etc/*net* /etc/*Net* -CRlh
echo "$n$Green$Blink # Done # $Reset"
echo "$n$Yellow#-----------------------------------------------------------------------------#$Reset$n"

if [ -f /etc/sysconfig/network ]; then
	echo "$Green # Command: cat /etc/sysconfig/network = $Reset$n"
	cat /etc/sysconfig/network
	
else
	echo "$Red file /etc/sysconfig/network does not exist$Reset"
fi
echo "$n$Green$Blink # Done # $Reset"
echo "$n$Yellow#-----------------------------------------------------------------------------#$Reset$n"

if [ -f /etc/udev/rules.d/*net.rules ]; then
	echo "$Green # Command: ls --color=auto /etc/udev/rules.d/*net.rules$Reset$n"
	ls --color=auto /etc/udev/rules.d/*net.rules
	echo "$n$Green # Command: cat /etc/udev/rules.d/*net.rules$Reset$n"
	cat /etc/udev/rules.d/*net.rules
else
	echo "$LMagenta file /etc/udev/rules.d/*net.rules does not exist$Reset"
fi
echo "$n$Green$Blink # Done # $Reset"
echo "$n$Yellow#-----------------------------------------------------------------------------#$Reset$n"

if [ -f /etc/hostname ]; then
	echo "$Green # Command: cat /etc/hostname$Reset$n"
	cat /etc/hostname
else
	echo "$LMagenta file /etc/hostname does not exist$Reset"
fi
echo "$n$Green$Blink # Done # $Reset"
echo "$n$Yellow#-----------------------------------------------------------------------------#$Reset$n"

if [ -f /etc/hosts ]; then
echo "$Green # Command: cat /etc/hosts$Reset$n"
cat /etc/hosts
else
echo "$LMagenta file /etc/hosts does not exist$Reset"
fi
echo "$n$Green$Blink # Done # $Reset"
echo "$n$Yellow#-----------------------------------------------------------------------------#$Reset$n"

if [ -f /etc/resolv.conf ]; then
echo "$Green # Command: cat /etc/resolv.conf$Reset$n"
cat /etc/resolv.conf
else
echo "$LMagenta file /etc/resolv.conf does not exist$Reset"
fi
echo "$n$Green$Blink # Done # $Reset"
echo "$n$Yellow#-----------------------------------------------------------------------------#$Reset$n"

COMMAND=`whereis -b route |awk '{print $2}'`
if [ -x "$COMMAND" ]; then
echo "$Green # Command: $COMMAND$Reset$n"
$COMMAND -n
else
COMMAND=route
PACKAGE=net-tools
MANAGER=0
echo "$n$Red # Command: $COMMAND not found $Reset$n"
echo "Installing package with: 'sudo apt-get install $PACKAGE' or 'sudo zypper install $PACKAGE'..."
if [ -x /usr/bin/zypper ];	then echo "$n$Green # /usr/bin/zypper : $Reset$n";	sudo zypper install $PACKAGE; MANAGER=1; fi
if [ -x /sbin/apt-get ];	then echo "$n$Green # /sbin/apt-get : $Reset$n";	sudo /sbin/apt-get install $PACKAGE; MANAGER=1; fi
if [ -x /usr/bin/apt-get ];	then echo "$n$Green # /usr/bin/apt-get : $Reset$n";	sudo /usr/bin/apt-get install $PACKAGE; MANAGER=1; fi
if [ -x /usr/sbin/urpmi ];	then echo "$n$Green # /usr/sbin/urpmi : $Reset$n";	sudo /usr/sbin/urpmi $PACKAGE; MANAGER=1; fi
if [ -x /usr/bin/pacman ];	then echo "$n$Green # /usr/bin/pacman : $Reset$n";	sudo /usr/bin/pacman -Syu --needed $PACKAGE; MANAGER=1; fi
if [ -x /usr/bin/yum ];		then echo "$n$Green # /usr/bin/yum : $Reset$n";		sudo /usr/bin/yum install $PACKAGE; MANAGER=1; fi
if [ -x /usr/bin/equo ];	then echo "$n$Green # /usr/bin/equo : $Reset$n";	sudo /usr/bin/equo install $PACKAGE; MANAGER=1; fi
if [ -x /usr/sbin/slapt-get ];	then echo "$n$Green # /usr/sbin/slapt-get : $Reset$n";	su -c "slapt-get --install $PACKAGE"; MANAGER=1; fi

if [ $MANAGER = 0 ]; then echo "$Red Can't find suitable software manager for download and install additinal packages. Try do it manually$Reset"; fi
COMMAND=`whereis -b route | awk '{print $2}'`
if [ -x "$COMMAND" ]; then echo "$Green # Command: $COMMAND$Reset$n"; $COMMAND -n ; fi
fi
echo "$n$Green$Blink # Done # $Reset"
echo "$n$Yellow#-----------------------------------------------------------------------------#$Reset$n"

COMMAND=`whereis -b ip |awk '{print $2}'`
if [ -x "$COMMAND" ]; then
echo "$Green # Command: $COMMAND route$Reset$n"
$COMMAND route
else
COMMAND=ip
PACKAGE=iproute2
MANAGER=0
echo "$n$Red # Command: $COMMAND not found $Reset$n"
echo "Installing package with: 'sudo apt-get install $PACKAGE' or 'sudo zypper install $PACKAGE'..."
if [ -x /usr/bin/zypper ];	then echo "$n$Green # /usr/bin/zypper : $Reset$n";	sudo zypper install $PACKAGE; MANAGER=1; fi
if [ -x /sbin/apt-get ];	then echo "$n$Green # /sbin/apt-get : $Reset$n";	sudo /sbin/apt-get install $PACKAGE; MANAGER=1; fi
if [ -x /usr/bin/apt-get ];	then echo "$n$Green # /usr/bin/apt-get : $Reset$n";	sudo /usr/bin/apt-get install $PACKAGE; MANAGER=1; fi
if [ -x /usr/sbin/urpmi ];	then echo "$n$Green # /usr/sbin/urpmi : $Reset$n";	sudo /usr/sbin/urpmi $PACKAGE; MANAGER=1; fi
if [ -x /usr/bin/pacman ];	then echo "$n$Green # /usr/bin/pacman : $Reset$n";	sudo /usr/bin/pacman -Syu --needed $PACKAGE; MANAGER=1; fi
if [ -x /usr/bin/yum ];		then echo "$n$Green # /usr/bin/yum : $Reset$n";		sudo /usr/bin/yum install $PACKAGE; MANAGER=1; fi
if [ -x /usr/bin/equo ];	then echo "$n$Green # /usr/bin/equo : $Reset$n";	sudo /usr/bin/equo install $PACKAGE; MANAGER=1; fi
if [ -x /usr/sbin/slapt-get ];	then echo "$n$Green # /usr/sbin/slapt-get : $Reset$n";	su -c "slapt-get --install $PACKAGE"; MANAGER=1; fi

if [ $MANAGER = 0 ]; then echo "$Red Can't find suitable software manager for download and install additinal packages. Try do it manually$Reset"; fi
COMMAND=`whereis -b ip | awk '{print $2}'`
if [ -x "$COMMAND" ]; then echo "$Green # Command: $COMMAND route$Reset$n"; $COMMAND route; fi

fi
echo "$n$Green$Blink # Done # $Reset"
echo "$n$Yellow#-----------------------------------------------------------------------------#$Reset$n"

COMMAND=`whereis -b ifconfig | awk '{print $2}'`
if [ -x "$COMMAND" ]; then echo "$Green # Command: $COMMAND$Reset$n"; $COMMAND
else
PACKAGE=net-tools
echo "You have to install $PACKAGE. Example : Arch - 'sudo pacman -Syu $PACKAGE'"
fi
echo "$n$Green$Blink # Done # $Reset"
echo "$n$Yellow#-----------------------------------------------------------------------------#$Reset$n"

COMMAND=`whereis -b iwconfig | awk '{print $2}'`
if [ -x "$COMMAND" ]; then echo "$Green # Command: $COMMAND$Reset$n"; $COMMAND
else
COMMAND=iwconfig
PACKAGE=wireless-tools
# pacman wireless_tools
MANAGER=0
echo "$n$Red # Command: $COMMAND not found $Reset$n"
echo "Installing package with: 'sudo apt-get install $PACKAGE' or 'sudo zypper install $PACKAGE'..."
if [ -x /usr/bin/zypper ];	then echo "$n$Green # /usr/bin/zypper : $Reset$n";	sudo zypper install $PACKAGE; MANAGER=1; fi
if [ -x /sbin/apt-get ];	then echo "$n$Green # /sbin/apt-get : $Reset$n";	sudo /sbin/apt-get install $PACKAGE; MANAGER=1; fi
if [ -x /usr/bin/apt-get ];	then echo "$n$Green # /usr/bin/apt-get : $Reset$n";	sudo /usr/bin/apt-get install $PACKAGE; MANAGER=1; fi
if [ -x /usr/sbin/urpmi ];	then echo "$n$Green # /usr/sbin/urpmi : $Reset$n";	sudo /usr/sbin/urpmi $PACKAGE; MANAGER=1; fi
if [ -x /usr/bin/pacman ];	then echo "$n$Green # /usr/bin/pacman : $Reset$n";	sudo /usr/bin/pacman -Syu --needed wireless_tools; MANAGER=1; fi
if [ -x /usr/bin/yum ];		then echo "$n$Green # /usr/bin/yum : $Reset$n";		sudo /usr/bin/yum install $PACKAGE; MANAGER=1; fi
if [ -x /usr/bin/equo ];	then echo "$n$Green # /usr/bin/equo : $Reset$n";	sudo /usr/bin/equo install $PACKAGE; MANAGER=1; fi
if [ -x /usr/sbin/slapt-get ];	then echo "$n$Green # /usr/sbin/slapt-get : $Reset$n";	su -c "slapt-get --install $PACKAGE"; MANAGER=1; fi
if [ $MANAGER = 0 ]; then echo "$Red Can't find suitable software manager for download and install additinal packages. Try do it manually$Reset"; fi
COMMAND=`whereis -b iwconfig | awk '{print $2}'`
if [ -x "$COMMAND" ]; then echo "$Green # Command: $COMMAND$Reset$n"; $COMMAND; fi
fi
echo "$n$Green$Blink # Done # $Reset"
echo "$n$Yellow#-----------------------------------------------------------------------------#$Reset$n"

echo "$Green # Command: function - ping_gw; [ \$? -eq 0 ] && echo "Online" ||  echo "Offline"; fi $Reset$n"
function ping_gw () {
COMMAND=$(command -v ping) && sudo $COMMAND -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null 2>&1 && return 0 || return 1
}

ping_gw
conection=$?
[ $conection -eq 0 ] && echo "Online" ||  echo "Offline"

echo "$n$Green$Blink # Done # $Reset"
echo "$n$Yellow#-----------------------------------------------------------------------------#$Reset$n"

if [ $conection -eq 0 ]
then :
	COMMAND=`whereis -b wget | awk '{print $2}'`
	if [ -x "$COMMAND" ]; then
	echo "$Green # Command: $COMMAND Public IP$Reset$n"
	echo "$COMMAND --timeout=10 -O - http://checkip.dyndns.org/index.html | cut -d ' ' -f 6 | cut -d '<' -f 1"
	public_ip=$($COMMAND --timeout=10 -O - http://checkip.dyndns.org/index.html | cut -d ' ' -f 6 | cut -d '<' -f 1)
	echo "Public IP: $public_ip"
	else
	PACKAGE="wget"
	echo "You have to install $PACKAGE. Example : Arch - 'sudo pacman -Syu $PACKAGE'"
	fi
else :
	echo "$Orange No conection to internet skipped check public IP$Reset$n"
fi

echo "$n$Green$Blink # Done # $Reset"
echo "$n$Yellow#-----------------------------------------------------------------------------#$Reset$n"

COMMAND=`whereis -b ip | awk '{print $2}'`
if [ -x "$COMMAND" ]; then
echo "$Green # Command: echo "interface is: \$dev \$ip \$gateway \$public_ip" $Reset$n"

read -r dev gateway <<-EOF
		$(awk '$2 == 00000000 { ip = strtonum(sprintf("0x%s", $3));
			printf ("%s\t%d.%d.%d.%d", $1,
			rshift(and(ip,0x000000ff),00), rshift(and(ip,0x0000ff00),08),
			rshift(and(ip,0x00ff0000),16), rshift(and(ip,0xff000000),24)) }' < /proc/net/route)
	EOF
	ip=$($COMMAND addr show dev "$dev" | awk '($1 == "inet") { print $2 }')
	
	echo "interface is: $dev $ip $gateway $public_ip"
else
PACKAGE="iproute2"
echo "You have to install $PACKAGE. Example : Arch - 'sudo pacman -Syu $PACKAGE'"
fi
echo "$n$Green$Blink # Done # $Reset"
echo "$n$Yellow#-----------------------------------------------------------------------------#$Reset$n"

echo "$Green # Command: cat /proc/net/dev $Reset$n"
cat /proc/net/dev
echo "$n$Green$Blink # Done # $Reset"
echo "$n$Yellow#-----------------------------------------------------------------------------#$Reset$n"

COMMAND=`whereis -b ifplugstatus | awk '{print $2}'`
if [ -x "$COMMAND" ]; then
	echo "$Green # Command: $COMMAND -a | grep -v ^\"lo:\" | grep \": link beat detected\"$Reset$n" 
	$COMMAND -a | grep -v ^"lo:" | grep ": link beat detected" && echo "$Orange you have connection$Reset" || echo "$Orange you have no connection$Reset"
else
	PACKAGE=ifplugd
	echo "You have to install $PACKAGE. Example : Arch - 'sudo pacman -Syu $PACKAGE'"
fi
echo "$n$Green$Blink # Done # $Reset"
echo "$n$Yellow#-----------------------------------------------------------------------------#$Reset$n"

echo "$Green # Command: if nm-online; then echo Network is up by NetworkManager; fi $Reset$n"
if nm-online; then echo Network is up by NetworkManager; fi
echo "$n$Green$Blink # Done # $Reset"
echo "$n$Yellow#-----------------------------------------------------------------------------#$Reset$n"

COMMAND=`whereis -b iwlist | awk '{print $2}'`
if [ -x "$COMMAND" ]; then
if [[ "yes" == $(r_ask "$Green Command: „sudo $COMMAND scanning”,$Orange Please answer$LRed") ]]; then
echo "$Green # Command: $COMMAND scanning$Reset$n"
$COMMAND scanning
fi
else
PACKAGE=wireless-tools
echo "You have to install $PACKAGE. Example : Arch - 'sudo pacman -Syu $PACKAGE'"
fi
echo "$n$Green$Blink # Done # $Reset"
echo "$n$Yellow#-----------------------------------------------------------------------------#$Reset$n"

COMMAND=`whereis -b iw | awk '{print $2}'`
if [ -x "$COMMAND" ]; then
if [[ "yes" == $(r_ask "$Green Command: „sudo $COMMAND $dev scan”,$Orange Please answer$LRed") ]]; then
echo "$Green # Command: sudo $COMMAND $dev scan $Reset$n"
sudo "$COMMAND" "$dev" scan
fi
else
COMMAND="iw"
PACKAGE="iw"
MANAGER=0
echo "$n$Red # Command: $COMMAND not found $Reset$n"
echo "Installing package with: 'sudo apt-get install $PACKAGE' or 'sudo zypper install $PACKAGE'..."
if [ -x /usr/bin/zypper ];	then echo "$n$Green # /usr/bin/zypper : $Reset$n";	sudo zypper install $PACKAGE; MANAGER=1; fi
if [ -x /sbin/apt-get ];	then echo "$n$Green # /sbin/apt-get : $Reset$n";	sudo /sbin/apt-get install $PACKAGE; MANAGER=1; fi
if [ -x /usr/bin/apt-get ];	then echo "$n$Green # /usr/bin/apt-get : $Reset$n";	sudo /usr/bin/apt-get install $PACKAGE; MANAGER=1; fi
if [ -x /usr/sbin/urpmi ];	then echo "$n$Green # /usr/sbin/urpmi : $Reset$n";	sudo /usr/sbin/urpmi $PACKAGE; MANAGER=1; fi
if [ -x /usr/bin/pacman ];	then echo "$n$Green # /usr/bin/pacman : $Reset$n";	sudo /usr/bin/pacman -Syu --needed wireless_tools; MANAGER=1; fi
if [ -x /usr/bin/yum ];		then echo "$n$Green # /usr/bin/yum : $Reset$n";		sudo /usr/bin/yum install $PACKAGE; MANAGER=1; fi
if [ -x /usr/bin/equo ];	then echo "$n$Green # /usr/bin/equo : $Reset$n";	sudo /usr/bin/equo install $PACKAGE; MANAGER=1; fi
if [ -x /usr/sbin/slapt-get ];	then echo "$n$Green # /usr/sbin/slapt-get : $Reset$n";	su -c "slapt-get --install $PACKAGE"; MANAGER=1; fi
if [ $MANAGER = 0 ]; then echo "$Red Can't find suitable software manager for download and install additinal packages. Try do it manually$Reset"; fi
COMMAND=`whereis -b $COMMAND | awk '{print $2}'`
if [ -x "$COMMAND" ]; then echo "$Green # Command: $COMMAND $dev scan$Reset$n"; $COMMAND $dev scan; fi
fi
echo "$n$Green$Blink # Done # $Reset"
echo "$n$Yellow#-----------------------------------------------------------------------------#$Reset$n"

if [[ "yes" == $(r_ask "$Green find your new wifi interface for theme,$Orange Please answer$LRed") ]]; then
	 # Replace "wlan0" devive name to active device name
	cd "$HOME/.superkaramba/EasyMonitor/themes/" || { echo "$LRed$Blink Error: cd $HOME/.superkaramba/EasyMonitor/themes/ exit 1$Reset"; exit 1 ;}
	interface_themes="EM_Big_Areo_0.theme EM_Big_Areo_1.theme EM_Big_Areo_2.theme EM_Big_Tech_1.theme EM_Net_WlanX_Interface.theme"
	COMMAND=$(whereis -b ip |awk '{print $2}')
	if [ -x "$COMMAND" ]; then
		interface=$($COMMAND route | head -n1 | awk '{print $5}')
	else
		COMMAND=$(whereis -b route | awk '{print $2}')
		if [ -x "$COMMAND" ]; then
			interface=$($COMMAND -n | grep 'UG' | awk '{print $8}'| head -n1)
		fi
	fi
		
	if [[ -z $interface ]]; then interface="wlan0"; fi
	check=$(grep "$interface" /proc/net/dev)
	if ! [ -n "$check" ]; then interface="wlan0"; fi

	# identify matching string
	device=$(sed -n "s|sensor=network device=*[ \t]*|&|p" $interface_themes)
	device="${device##*device=}"
	device="${device%% *}"
	#
	echo "$n$Yellow old interface is: $Orange"$device"$Reset"
	echo "$Yellow new interface is: $Orange"$interface"$n$Yellow replace in: $Cyan$interface_themes $Reset"
	sed -i -e "s|sensor=network device=$device|sensor=network device=$interface|" $interface_themes
	
	
fi
echo "$n$Green$Blink # Done # $Reset"
echo "$n$Yellow#-----------------------------------------------------------------------------#$Reset$n"
echo "$Green The end...$Reset$n"	
cd $HOME
/bin/bash