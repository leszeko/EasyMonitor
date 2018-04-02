#!/bin/bash
# old_version_remove.sh script for Easy Monitor

################# Variables for color terminal
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi; . "$DIR/Color_terminal_variables.sh"
Color_terminal_variables
#################

# Check enviroment
	Local_KDE_Prefix="No_Kde"
	Themes_Prefix="share/apps/superkaramba/themes/"
	Easy_Monitor_Backup="Easy_Monitor_$(date +%Y_%m_%d-%H_%M_%S)"
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
		echo -en "$Yellow"
		echo "remove versin < 0.9.8 $Local_KDE_Prefix$Themes_Prefix$Easy_Monitor_Work_Dir exist - move it to $Local_KDE_Prefix$Themes_Prefix$Easy_Monitor_Backup"
		echo -en "$Reset"
		echo
		
		mv -f "$Local_KDE_Prefix$Themes_Prefix$Easy_Monitor_Work_Dir" "$Local_KDE_Prefix$Themes_Prefix$Easy_Monitor_Backup"
		echo
	fi
fi