#!/bin/bash
# net_ifconfig.sh script

if [ -f /etc/sysconfig/network ]; then

echo;echo "cat /etc/sysconfig/network";echo
cat /etc/sysconfig/network
echo;echo Done;echo
fi

if [ -f /etc/udev/rules.d/*net.rules ]; then
echo
ls /etc/udev/rules.d/*net.rules
echo;echo cat /etc/udev/rules.d/*net.rules;echo
cat /etc/udev/rules.d/*net.rules
echo;echo Done;echo
fi

if [ -x /sbin/ifconfig ]; then
echo "/sbin/ifconfig";echo
/sbin/ifconfig
echo;echo Done;echo

else
kdialog --title "Error" --msgbox "You have to install net-tools. Example : Arch - 'sudo pacman -Syu net-tools'"

# OpenSuse yast2
if [ -x /sbin/yast2 ] ;
then
sudo /sbin/yast2 --update net-tools
fi

# Ubuntu apt-get
if [ -x /sbin/apt-get ] ;
then
sudo apt-get install net-tools
fi

# Ubuntu apt-get
if [ -x /usr/bin/apt-get ] ;
then
sudo apt-get install net-tools
fi

# Mandriva urpmi
if [ -x /usr/sbin/urpmi ] ;
then
sudo urpmi net-tools
fi

# Arch pacman
if [ -x /usr/bin/pacman ]; then
sudo pacman -Syu net-tools
fi

# Fedora
if [ -x /usr/bin/yum ]; then
sudo yum install net-tools
fi

echo package manager to install net-tools no found
fi

if [ -x /sbin/ip ]; then
echo "/sbin/ip route";echo
/sbin/ip route
echo;echo Done;echo

else
kdialog --title "Error" --msgbox "You have to install iproute2. Example : Arch - 'sudo pacman -Syu iproute2'"
# OpenSuse yast2
if [ -x /sbin/yast2 ] ;
then
sudo /sbin/yast2 --update iproute2
fi

# Ubuntu apt-get
if [ -x /sbin/apt-get ] ;
then
sudo apt-get install iproute2
fi

# Ubuntu apt-get
if [ -x /usr/bin/apt-get ] ;
then
sudo apt-get install iproute2
fi

# Mandriva urpmi
if [ -x /usr/sbin/urpmi ] ;
then
sudo urpmi iproute2
fi

# Arch pacman
if [ -x /usr/bin/pacman ]; then
sudo pacman -Syu iproute2
fi

# Fedora yum
if [ -x /usr/bin/yum ]; then
sudo yum install iproute2
fi

echo package manager to install iproute2 no found
fi

if [ -x /sbin/ethtool ]; then
echo "/sbin/ethtool";echo
/sbin/ethtool eth0
echo;echo Done;echo
exit
fi

if [ -x /usr/sbin/ethtool ]; then
echo "/usr/sbin/ethtool";echo
/usr/sbin/ethtool eth0
echo;echo Done;echo
else
kdialog --title "Error" --msgbox "You have to install ethtool wget. Example : Arch - 'sudo pacman -Syu ethtool wget'"

# OpenSuse yast2
if [ -x /sbin/yast2 ] ;
then
/sbin/yast2 --update ethtool
exit 0
fi

# Ubuntu apt-get
if [ -x /sbin/apt-get ] ;
then
sudo konsole --hold -e apt-get install ethtool
exit 0
fi

# Ubuntu apt-get
if [ -x /usr/bin/apt-get ] ;
then
konsole --hold -e sudo apt-get install ethtool
exit 0
fi

# Mandriva urpmi
if [ -x /usr/sbin/urpmi ] ;
then
kdesu -c 'konsole --hold -e sudo urpmi ethtool'
exit 0
fi

# Arch pacman
if [ -x /usr/bin/pacman ]; then
konsole -e sudo pacman -Syu ethtool
exit 0
fi

# Fedora
if [ -x /usr/bin/yum ]; then
kdesu -c 'konsole --hold -e sudo yum install ethtool wget'
exit 0
fi

echo "No ethtool"

fi





