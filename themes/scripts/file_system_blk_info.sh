#!/bin/bash 
# file_system_blk_info.sh script

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

echo "$n$Green # file_system_blk_info.sh script # $Reset$n"

echo "$n$Green # Command: lsblk = $Reset$n"
lsblk

echo "$n$Green # Command: blkid = $Reset$n"
sudo blkid

echo "$n$Green # Command: sudo lspci -nnk | grep -i ide -A2 = $Reset$n"
sudo lspci -nnk | grep -i ide -A2

echo "$n$Green # Command: lsscsi = $Reset$n"
lsscsi

echo "$n$Green # Command: lsdvd = $Reset$n"
lsdvd

#if [ -x /usr/sbin/dmidecode ]; then
	#echo "$n$LGreen # Command: sudo dmidecode --type connector | more = $Reset$n"
	#echo "$LBlue"; sudo dmidecode --type connector | more
#	echo
#else
	#echo "$n$LRed # No dmidecode installed - /usr/sbin/dmidecode $Reset$n"
#fi

echo "$n$Green$Blink # Done # $Reset$n"
