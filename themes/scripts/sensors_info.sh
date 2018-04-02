#!/bin/bash 
# sensors_info script

echo;echo " sensors_info script - sensors-detect";echo

if [ -x /usr/bin/sensors ]; then
sudo sensors-detect

else kdialog --title "Error" --msgbox "You have to install lm_sensors. Exaple: Ubuntu: - 'sudo apt-get install lm-sensors' or OpenSuse - 'yast2 --update sensors'"

# OpenSuse yast2
if [ -x /sbin/yast2 ] ;
then
kdesu -c '/sbin/yast2 --update sensors'
exit 0
fi

# Ubuntu apt-get
if [ -x /sbin/apt-get ] ;
then
sudo apt-get install lm-sensors
fi

# Ubuntu apt-get
if [ -x /usr/bin/apt-get ] ;
then
sudo apt-get install lm-sensors
fi

# Mandriva urpmi
if [ -x /usr/sbin/urpmi ] ;
then
kdesu -c 'konsole --hold -e sudo urpmi lm_sensors'
exit 0
fi

# Arch pacman
if [ -x /usr/bin/pacman ]; then
sudo pacman -Syu lm_sensors
fi

# Fedora
if [ -x /usr/bin/yum ]; then
kdesu -c 'konsole --hold -e sudo yum install lm_sensors'
exit 0
fi

fi

echo;echo Done;echo
