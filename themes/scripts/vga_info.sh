#!/bin/bash
# vga_info.sh script

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
echo "$n$LGreen # vga_info.sh script # $Reset"

echo "$n$LGreen # Command: lspci -nnk | grep -i vga -A2 = $Reset$n"
COMMAND=`whereis -b lspci | awk '{print $2}'`; $COMMAND -nnk | grep -i vga -A2


COMMAND=`whereis -b lspci | awk '{print $2}'`
[[ $COMMAND ]] && { echo "$n$LGreen # Command: $COMMAND -vv| grep 'VGA ' -A14 = $Reset$n"; $COMMAND -vv | grep 'VGA ' -A14 ;} || { lspci -vv | grep 'VGA ' -A14 ;}



echo "$n$LGreen # Command: lshw -c video = $Reset$n"
COMMAND=`whereis -b lshw | awk '{print $2}'`
[[ $COMMAND ]] && { $COMMAND -c video ;} ||  { lshw -c video ;}

echo "$n$LGreen # Command: hwinfo --gfxcard = $Reset$n"
hwinfo --gfxcard

echo "$n$LGreen # Command: ls /sys/class/drm/card0/device/driver/module/drivers = $Reset$n"
ls /sys/class/drm/card0/device/driver/module/drivers


module=$(ls /sys/class/drm/card0/device/driver/module/drivers|sed -e 's/pci://')
echo "$n$LGreen # Command: modinfo $module = $Reset$n"
COMMAND=`whereis -b modinfo | awk '{print $2}'`
$COMMAND $module

echo "$n$LGreen # Command: dmesg | grep drm = $Reset$n"
dmesg | grep drm

echo "$n$LGreen # Command: glxinfo | grep 'OpenGL vendor string:' -A3 = $Reset$n"
glxinfo | grep 'OpenGL vendor string:' -A3

echo "$n$LGreen # Command: glxinfo | grep 'GLX version:' -A11 = $Reset$n"
glxinfo | grep 'GLX version:' -A11

echo "$n$LGreen # Command: egrep -i 'connected|card detect|primary dev|Setting driver|loadmodule' /var/log/Xorg.0.log = $Reset$n"
egrep -i 'connected|card detect|primary dev|Setting driver|loadmodule' /var/log/Xorg.0.log

echo "$n$LGreen # Command: nvidia-settings -q gpucoretemp -t = $Reset$n"
nvidia-settings -q gpucoretemp -t

echo "$n$LGreen # Command: nvidia-smi = $Reset$n"
nvidia-smi

echo "$n$LGreen # Command: nvclock -T = $Reset$n"
nvclock -T

echo "$n$LGreen # Command: sensors nouveau-* = $Reset$n"
sensors nouveau-*

echo "$n$LGreen # Command: xrandr -q = $Reset$n"
xrandr -q

echo "$n$LGreen$Blink # Done # $Reset"
