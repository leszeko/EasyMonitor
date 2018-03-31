#!/bin/bash
# update_easy_monitor.sh for Easy Monitor

################# Variables for color terminal
Green=""$'\033[00;32m'"" Red=""$'\033[00;31m'"" White=""$'\033[00;37m'"" Yellow=""$'\033[01;33m'"" Cyan=""$'\033[00;36m'"" Blue=""$'\033[00;34m'"" Magenta=""$'\033[00;35m'""
GREEN=""$'\033[01;32m'"" RED=""$'\033[01;31m'"" WHITE=""$'\033[01;37m'"" YELLOW=""$'\033[01;33m'"" CYAN=""$'\033[01;36m'"" BLUE=""$'\033[01;34m'"" MAGENTA=""$'\033[01;35m'""
n=""$'\n'"" Blink=""$'\033[5m'"" Back=""$'\b'"" Reset=""$'\033[0;0m'""; if [[ $TERM != *xterm* ]]; then SMOOTHBLUE=$BLUE;Orange=$Yellow;ORANGE=$YELLOW;Cream=$Magenta;CREAM=$MAGENTA;else
SmoothBlue=""$'\033[00;38;5;111m'"";Cream=""$'\033[00;38;5;5344m'"";Orange=""$'\033[00;38;5;714m'""
SMOOTHBLUE=""$'\033[01;38;5;111m'"";CREAM=""$'\033[01;38;5;5344m'"";ORANGE=""$'\033[01;38;5;714m'"";fi
#################
Themes_Prefix="$HOME/.superkaramba/"
Easy_Monitor_Work_Dir="EasyMonitor"
Easy_Monitor_Backup="Easy_Monitor_Old"
Easy_Monitor_Package="EasyMonitor.skz"
You_User_Name="$(whoami)"

##################

echo $GREEN
echo "You you are going to download and update $Easy_Monitor_Package https://store.kde.org to "
echo "directory to full work all features and install additinal tools for it"
echo $Reset

while true; do
read -p "Please answer Y or N? " yn
	case $yn in
	[Yy]* ) echo;echo "Yes";echo
	
	###################
	if [ -z $TMPDIR ]; then TMPDIR=/tmp; fi
	mkdir -p "$TMPDIR/EasyMonito-$USER/"
	cd "$TMPDIR/EasyMonito-$USER"
	rm -fr EasyMonitor_install
	mkdir -pv "$TMPDIR/EasyMonito-$USER/EasyMonitor_install"
	cd ./EasyMonitor_install
	[[ ! $? ]] && exit 1
	wget -k -O Easy_Monitor.html https://store.kde.org/content/show.php?content=69401
	[[ $? = 0 ]] || { echo "Error - connect to project page exit" ; exit 1 ;}
	Download_skz=$(cat Easy_Monitor.html | grep 'wget -O EasyMonitor')
	Download_skz=${Download_skz%%\<*}
	File_skz=${Download_skz##* }
	wget -O EasyMonitor.zip $File_skz
	File_skz=${Download_skz##*\/}
	cp -f EasyMonitor.zip "/$File_skz"
	unzip EasyMonitor.zip
	[[ $? = 0 ]] || { echo "Error - Broken zip archive exit" ; cd ../ ; rm -fr EasyMonitor_install ; exit 1 ;}
	rm -f EasyMonitor.zip
	bash ./install_easy_monitor.sh
	cd ../
	rm -fr EasyMonitor_install
	echo -e "\n\033[5;32m Update done... \033[1;0m\n"
	###################
	
	break;;
	
	[Nn]* ) echo;echo "No"; break;;
	* ) echo "Please answer Y or N.";;
esac

done
