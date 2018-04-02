#!/bin/bash 
# net_iwconfig.sh script

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
echo -e "$LGreen # net_iwconfig.sh script # $Reset"

interface=`/sbin/route -n  |grep 'UG' |awk '{print $8}'| head -n1`
echo "$n$LGreen # Command : sudo iwconfig $interface = $Reset$n"
sudo iwconfig $interface

	while true; do
	echo "$n$LRed"
	read -p " sudo iwconfig $interface Power Management:off rate fixed rate 11M txpower 20, Please answer Y or N? " yn
		case $yn in
		[Yy]* ) echo "Yes"
		
		echo "$n$LGreen # Command : sudo iwconfig $interface power off = $Reset$n"
		sudo iwconfig $interface power off
		
		echo "$n$LGreen # Command : sudo iwconfig $interface rate fixed = $Reset$n"
		sudo iwconfig $interface rate fixed
		
		echo "$n$LGreen # Command : sudo iwconfig $interface rate 11M = $Reset$n"
		sudo iwconfig $interface rate 11M
		
		echo "$n$LGreen # Command : sudo iwconfig $interface txpower 20 = $Reset$n"
		sudo iwconfig $interface txpower 20
		
		echo "$n$LGreen # Command : sudo iwconfig $interface = $Reset$n"
		sudo iwconfig $interface
		
		break;;
		
		[Nn]* ) echo "No"; break;;
        	* ) echo "Please answer Y or N.";;
		esac
	done

echo "$n$LGreen$Blink # Done # $Reset"
