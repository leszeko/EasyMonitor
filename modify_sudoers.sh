#!/bin/bash
# modify_sudoers.sh for Easy Monitor. This script must be run with root privileges sudo or su -c "modify_sudoers.sh"

################## Variables for color terminal
Green=""$'\033[00;32m'"" Red=""$'\033[00;31m'"" White=""$'\033[00;37m'"" Yellow=""$'\033[01;33m'"" Cyan=""$'\033[00;36m'"" Blue=""$'\033[00;34m'"" Magenta=""$'\033[00;35m'""
GREEN=""$'\033[01;32m'"" RED=""$'\033[01;31m'"" WHITE=""$'\033[01;37m'"" YELLOW=""$'\033[01;33m'"" CYAN=""$'\033[01;36m'"" BLUE=""$'\033[01;34m'"" MAGENTA=""$'\033[01;35m'""
n=""$'\n'"" Blink=""$'\033[5m'"" Back=""$'\b'"" Reset=""$'\033[0;0m'""; if [[ $TERM != *xterm* ]]; then SMOOTHBLUE=$BLUE;Orange=$Yellow;ORANGE=$YELLOW;Cream=$Magenta;CREAM=$MAGENTA;else
SmoothBlue=""$'\033[00;38;5;111m'"";Cream=""$'\033[00;38;5;5344m'"";Orange=""$'\033[00;38;5;714m'""
SMOOTHBLUE=""$'\033[01;38;5;111m'"";CREAM=""$'\033[01;38;5;5344m'"";ORANGE=""$'\033[01;38;5;714m'"";fi
#################
if ! [ $(id -u) = 0 ]; then echo "$n$Orange This script must be run with root privileges.$Reset$n";exit 1;fi
#################
function r_ask() { read -p "$1 ([Y]es or [N]o): " -n 1 -r; case $(echo $REPLY | tr '[A-Z]' '[a-z]') in y|yes) echo "yes" ;; *) echo "no" ;; esac }
#################

echo "$MAGENTA"
echo "Now you are going to modify sudoers file to full work all features for Easy Monitor"
echo "Please note that this is probably not a good security practice, to give users in group users access for some commands"
echo "The sudoers file is very importland for system, broke down this file can damage access to system!!"
echo "So sometime in that case after you will have to armor in knowledge how to back on line... :) (boot from CD and repair)"
echo

#####################
echo -en "$RED"
if [[ "no" == $(r_ask "$GREEN Do you wish modify sudoers rigts, Please answer or Enter for skip$Red") || "no" == $(r_ask "$BLUE Are you$ORANGE *really*$Orange sure?$Red") ]]; then echo "$n$Orange Skipped modify sudoers rigts$Reset"
else echo "$Reset"
	echo -en "$MAGENTA"
	echo "The sudoers file(s) is inportand and before copy it in right place must have rigts 'sudo chmod 0440 xxx' and own by root 'sudo chown root.root xxx'"
	echo "After that check it out witch 'sudo visudo -c -f xxx'  and then copy to /etc/sudoers.d/xxx or as /etc/sudors"
	echo
	
	# copy and prepare /etc/sudoers in /tmp/sudoers
	
	echo -en "$RED"
	test -e /tmp/sudoers && sudo rm /tmp/sudoers
	cp -fax /etc/sudoers /tmp/sudoers
	chmod a+w /tmp/sudoers
	
	# working on copy in /tmp/sudoers
	
	cat /tmp/sudoers | grep  'includedir /etc/sudoers.d' > /dev/null
	if [ $? = 0 ]; then 
		echo -e "$GREEN"
		echo "line - '#includedir /etc/sudoers.d' already in /etc/sudoers file"
		echo "Please note that this line must be at end of /etc/sudoers file in other way it can does not work"
		echo "Now you are going to build an additional Sudoers file for EasyMonitor and put it in includedir /etc/etc/sudoers.d/ folder."
	else
		echo -en "$RED"
		echo "You are going to add yellow lines below to /etc/sudoers"
		echo "Back copy of this file will be saved as /etc/sudoers_EasyMonitor.back"
		echo -en "$Reset"
		echo -e "$YELLOW"
		echo "## Read drop-in files from /etc/sudoers.d (the # here does not mean a comment)"
		echo "#includedir /etc/sudoers.d"
		
		echo -e "$RED"
		while true; do
		read -p "Do you wish modify /etc/sudoers file by add yellow lines above. Please answer Y or N? " yn
		case $yn in
        	[Yy]* ) echo;echo "Yes";echo
		echo -e "$Reset"
			
			cp -vfax /etc/sudoers /etc/sudoers_EasyMonitor.back
			
			echo >> /tmp/sudoers
			echo "## Read drop-in files from /etc/sudoers.d (the # here does not mean a comment)" >> /tmp/sudoers
			echo "#includedir /etc/sudoers.d"  >> /tmp/sudoers
			echo >> /tmp/sudoers
			
			echo -e "$MAGENTA"
			echo "		Now the /etc/sudoers looks as below"
			echo -e "$Reset"
			cat /tmp/sudoers
			echo -e "$Green$Blink"
			echo "End file"
			echo -e "$Reset"
			
			chmod 0440 /tmp/sudoers
			chown root.root /tmp/sudoers
			
			echo -en "$MAGENTA"
			visudo -c -f /tmp/sudoers
			if [ $? = 0 ]; then
			cp -fax /tmp/sudoers /etc/sudoers
			fi
		break;;
		[Nn]* ) echo;echo "No"; break;;
		* ) echo "Please answer Y or N.";;
		esac
		done
		
		echo "$n$Green # Done #$Reset"
	fi
	
	# cleaning
	rm /tmp/sudoers
	
	
	#####################
	# Now build a Sudoers_Entries_for_Easy_Monitor
	
	echo -e "$GREEN"
	echo "Now build a Sudoers_Entries_for_Easy_Monitor.txt file yellow lines below"
	echo -e "$Red"
	
	echo "## Entries for Easy Monitor users" > ./Sudoers_Entries_for_Easy_Monitor.txt
	echo "## Check out all paths. The path strings must match exactly to lead command" >> ./Sudoers_Entries_for_Easy_Monitor.txt
	echo "## Your user have to belong to users group and users group must have rights to use sudo command" >> ./Sudoers_Entries_for_Easy_Monitor.txt
	
	COMMAND="hddtemp"
	PATH_COMMAND=$(whereis -b "$COMMAND" | awk '{print $2}')
	if [ -x "$PATH_COMMAND" ]; then
		echo "%users ALL=NOPASSWD:$PATH_COMMAND" >> ./Sudoers_Entries_for_Easy_Monitor.txt
	else	echo "Can't find $COMMAND"
	fi
	
	COMMAND="hdparm"
	PATH_COMMAND=$(whereis -b "$COMMAND" | awk '{print $2}')
	if [ -x "$PATH_COMMAND" ]; then
		echo "%users ALL=NOPASSWD:$PATH_COMMAND" >> ./Sudoers_Entries_for_Easy_Monitor.txt
	else	echo "Can't find $COMMAND"
	fi
	
	COMMAND="ethtool"
	PATH_COMMAND=$(whereis -b "$COMMAND" | awk '{print $2}')
	if [ -x "$PATH_COMMAND" ]; then
		echo "%users ALL=NOPASSWD:$PATH_COMMAND" >> ./Sudoers_Entries_for_Easy_Monitor.txt
	else	echo "Can't find $COMMAND"
	fi
	
	COMMAND="dmidecode"
	PATH_COMMAND=$(whereis -b "$COMMAND" | awk '{print $2}')
	if [ -x "$PATH_COMMAND" ]; then
		echo "%users ALL=NOPASSWD:$PATH_COMMAND" >> ./Sudoers_Entries_for_Easy_Monitor.txt
	else	echo "Can't find $COMMAND"
	fi
	
	COMMAND="scanimage"
	PATH_COMMAND=$(whereis -b "$COMMAND" | awk '{print $2}')
	if [ -x "$PATH_COMMAND" ]; then
		echo "%users ALL=NOPASSWD:$PATH_COMMAND" >> ./Sudoers_Entries_for_Easy_Monitor.txt
	else	echo "Can't find $COMMAND"
	fi
	
	echo "## End of Easy Monitor users entries" >> ./Sudoers_Entries_for_Easy_Monitor.txt
	#####################
	
	echo -e "$YELLOW"
	cat ./Sudoers_Entries_for_Easy_Monitor.txt
	
	echo -e "$MAGENTA"
	echo "Now you are going to copy above lines Sudoers_Entries_for_Easy_Monitor.txt to /etc/sudoers.d/EasyMonitor"
	echo -e "$Reset"
	
	echo -en "$RED"
	while true; do
	read -p "Do you wish add file '/etc/sudoers.d/EasyMonitor' to sudoers rigts. Please answer Y or N? " yn
	case $yn in
	[Yy]* ) echo;echo "Yes";echo
	echo -en "$Reset"
	
		#####################
		# copy and prepare to test by visudo  ./Sudoers_Entries_for_Easy_Monitor.txt in /tmp
		
		cp -fax ./Sudoers_Entries_for_Easy_Monitor.txt /tmp/Sudoers_Entries_for_Easy_Monitor.txt
		chmod 0440 /tmp/Sudoers_Entries_for_Easy_Monitor.txt
		chown root.root /tmp/Sudoers_Entries_for_Easy_Monitor.txt
		
		#####################
		# test visudo and copy to /etc/sudoers.d/EasyMonitor
		
		echo -en "$MAGENTA"
		visudo -c -f /tmp/Sudoers_Entries_for_Easy_Monitor.txt
		if [ $? = 0 ]; then
		mkdir -p  /etc/sudoers.d
		cp -vfax  /tmp/Sudoers_Entries_for_Easy_Monitor.txt /etc/sudoers.d/EasyMonitor
		fi
		#####################
		
		# cleaning
		rm /tmp/Sudoers_Entries_for_Easy_Monitor.txt
		
	break;;
	[Nn]* ) echo;echo "No"; break;;
	* ) echo "Please answer Y or N.";;
	esac
	done

fi


#####################
echo "$n$Green # Done #$Reset"
