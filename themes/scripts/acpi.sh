#!/bin/bash
# acpi.sh script

if [ -x /usr/bin/acpi ] ; then 
acpi -Vibatcs; echo "Battery 0"; cat /proc/acpi/battery/BAT0/info;echo "Battery 1"; cat /proc/acpi/battery/BAT1/info; echo Done

else kdialog --title "Error" --msgbox "You have to install acpi. Exaple: Ubuntu - 'sudo apt-get install acpi' or 'yast2 --update acpi' or ..."

# OpenSuse yast2
if [ -x /sbin/yast2 ] ;
then
kdesu -c '/sbin/yast2 --update acpi'
exit 0
fi

# Ubuntu apt-get
if [ -x /sbin/apt-get ] ;
then
sudo apt-get install acpi
exit 0
fi

# Ubuntu apt-get
if [ -x /usr/bin/apt-get ] ;
then
sudo apt-get install acpi
fi

# Mandriva urpmi
if [ -x /usr/sbin/urpmi ] ;
then
kdesu -c 'konsole --hold -e sudo urpmi acpi'
exit 0
fi

# Arch pacman
if [ -x /usr/bin/pacman ]; then
sudo pacman -Syu acpi
fi

fi




