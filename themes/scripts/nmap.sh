#!/bin/bash
# nmap.sh script -$network

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
echo "$n$LGreen # nmap.sh script - $1 # $Reset"

NETWORK=$1

if [ -x /usr/bin/nmap ] ;
then
echo;echo Wait for scan network $1;echo
nmap -sP $NETWORK
echo;echo Done;echo

else
kdialog --title "Error" --msgbox "You have to install nmap. Example : Ubuntu - 'sudo apt-get install nmap'"

# OpenSuse yast2
if [ -x /sbin/yast2 ] ;
then
kdesu -c '/sbin/yast2 --update nmap'
exit 0
fi

# Ubuntu apt-get
if [ -x /sbin/apt-get ] ;
then
sudo apt-get install nmap
fi

# Ubuntu apt-get
if [ -x /usr/bin/apt-get ] ;
then
sudo apt-get install nmap 
fi

# Mandriva urpmi
if [ -x /usr/sbin/urpmi ] ;
then
kdesu -c 'konsole --hold -e sudo urpmi nmap'
exit 0
fi

# Arch pacman
if [ -x /usr/bin/pacman ]; then
sudo pacman -Syu nmap
fi

# Fedora
if [ -x /usr/bin/yum ]; then
kdesu -c 'konsole --hold -e sudo yum install nmap'
exit 0
fi

echo;echo Done;echo
exit
fi
