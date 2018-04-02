#!/bin/bash
# update_easy_monitor.sh for Easy Monitor

################# Variables for color terminal
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi; . "$DIR/Color_terminal_variables.sh"
Color_terminal_variables
#################
Themes_Prefix="$HOME/.superkaramba/"
Easy_Monitor_Work_Dir="EasyMonitor"
Easy_Monitor_Backup="Easy_Monitor_$(date +%Y_%m_%d-%H_%M_%S)"
Easy_Monitor_Package="EasyMonitor.skz"
You_User_Name="$(whoami)"
function ping_gw ()
{
  COMMAND=$(command -v ping) && sudo $COMMAND -q -w 3 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null 2>&1 && return 0 || return 1
}

##################

echo $Green
echo "You you are going to download and update $Easy_Monitor_Package from https://sourceforge.net/projects/easy-monitor"
echo $Reset
ping_gw # && echo "Online" ||  echo "Offline"
if [ $? != 0 ]
then :
	 echo "$Cyan No internet connection,$Red exit !$Reset"
	 exit 1
fi

while true; do
read -p "Please answer Y or N? " yn
	case $yn in
	[Yy]* ) echo;echo "Yes";echo
	
	###################
	if [ -z $TMPDIR ]; then TMPDIR=/tmp; fi
	mkdir -p "$TMPDIR/EasyMonitor-$USER/"
	cd "$TMPDIR/EasyMonitor-$USER"
	rm -fr EasyMonitor_install
	mkdir -pv "$TMPDIR/EasyMonitor-$USER/EasyMonitor_install"
	cd ./EasyMonitor_install
	[[ ! $? ]] && exit 1
	wget -k -O Easy_Monitor.html https://sourceforge.net/projects/easy-monitor/files/?source=navbar
	[[ $? = 0 ]] || { echo "Error - connect to project page exit" ; exit 1 ;}
	Download_skz=$(cat Easy_Monitor.html | grep 'wget -O EasyMonitor')
	Download_skz=${Download_skz%%\<*}
	File_skz=${Download_skz##* }
	wget -O EasyMonitor.zip $File_skz
	File_skz=${Download_skz##*\/}
	cp -f EasyMonitor.zip "/$File_skz"
	unzip EasyMonitor.zip
	[[ $? = 0 ]] || { echo "Error - Broken zip archive exit"; exit 1 ;}
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
