#!/bin/bash
# old_version_remove.sh script for Easy Monitor

################## Variables for color terminal
Green=""$'\033[00;32m'"" Red=""$'\033[00;31m'"" White=""$'\033[00;37m'"" Yellow=""$'\033[01;33m'"" Cyan=""$'\033[00;36m'"" Blue=""$'\033[00;34m'"" Magenta=""$'\033[00;35m'""
GREEN=""$'\033[01;32m'"" RED=""$'\033[01;31m'"" WHITE=""$'\033[01;37m'"" YELLOW=""$'\033[01;33m'"" CYAN=""$'\033[01;36m'"" BLUE=""$'\033[01;34m'"" MAGENTA=""$'\033[01;35m'""
n=""$'\n'"" Blink=""$'\033[5m'"" Back=""$'\b'"" Reset=""$'\033[0;0m'""; if [[ $TERM != *xterm* ]]; then SMOOTHBLUE=$BLUE;Orange=$Yellow;ORANGE=$YELLOW;Cream=$Magenta;CREAM=$MAGENTA;else
SmoothBlue=""$'\033[00;38;5;111m'"";Cream=""$'\033[00;38;5;5344m'"";Orange=""$'\033[00;38;5;714m'""
SMOOTHBLUE=""$'\033[01;38;5;111m'"";CREAM=""$'\033[01;38;5;5344m'"";ORANGE=""$'\033[01;38;5;714m'"";fi
#################

# Check enviroment
	Local_KDE_Prefix="No_Kde"
	Themes_Prefix="share/apps/superkaramba/themes/"
	Easy_Monitor_Backup="Easy_Monitor_Old"
	Easy_Monitor_Work_Dir="No_Work_Dir"
	
##################
# Kde = 4
if [ -x "$(which kde4-config)" ]; then
		Local_KDE_Prefix=$(kde4-config --localprefix)
		Easy_Monitor_Work_Dir="EasyMonitor"
		
	##################
	# Kde = 3
elif [ -x "$(which kde-config)" ]; then
		Local_KDE_Prefix=$(kde-config --localprefix)
		Easy_Monitor_Work_Dir="69401-EasyMonitor/EasyMonitor"
		
fi
	# If kde ok
if ! [ "$Local_KDE_Prefix" = "No_Kde" ]; then
	###################
	# Backup old installation if exist
	if [ -d "$Local_KDE_Prefix$Themes_Prefix$Easy_Monitor_Work_Dir" ]; then
		echo -en "$YELLOW"
		echo "remove versin < 0.9.8 $Local_KDE_Prefix$Themes_Prefix$Easy_Monitor_Work_Dir exist - move it to $Local_KDE_Prefix$Themes_Prefix$Easy_Monitor_Backup"
		echo -en "$Reset"
		echo
		
		mv -f "$Local_KDE_Prefix$Themes_Prefix$Easy_Monitor_Work_Dir" "$Local_KDE_Prefix$Themes_Prefix$Easy_Monitor_Backup"
		echo
	fi
fi