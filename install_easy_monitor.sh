#!/bin/bash
# install_easy_monitor.sh script for Easy Monitor
if [ ! -t 0 ]
then :
	# script is executed outside terminal
	# execute the script inside a terminal window
	# Gathering informations about terminal program
	if   command -v konsole >/dev/null 2>&1
	then :
		konsole --hold -e "/bin/bash \"$0\" \"$@\""
		return $?
	elif command -v terminology >/dev/null 2>&1
	then :
		terminology --hold -e "/bin/bash \"$0\" \"$@\""
		return $?
	elif command -v gnome-terminal >/dev/null 2>&1
	then :
		gnome-terminal -e "/bin/bash \"$0\" \"$@\""
		return $?
	elif command -v xfce4-terminal >/dev/null 2>&1
	then :
		xfce4-terminal --hold -e "/bin/bash \"$0\" \"$@\""
		return $?
	elif command -v xterm >/dev/null 2>&1
	then :
		xterm -hold -e "/bin/bash \"$0\" \"$@\""
		return $?
	else :
		echo "$Red Error: This script "$0" needs terminal, exit 2$Reset" >&2
		return 2
	fi
fi
comment=<<EOF
aterm          - AfterStep terminal with transparency support
gnome-terminal - default terminal for GNOME
guake          - A dropdown terminal for GNOME
konsole        - default terminal for KDE
Kuake          - a dropdown terminal for KDE
mrxvt          - Multi-tabbed rxvt clone
rxvt           - for the X Window System (and, in the form of a Cygwin port, 
                 for Windows) 
rxvt-unicode   - rxvt clone with unicode support
xfce4-terminal - default terminal for Xfce desktop 
                 environment with dropdown support
Terminator     - is a GPL terminal emulator. It is available on
                 Microsoft Windows, Mac OS X, Linux and other Unix X11 systems.
Terminology    - enhanced terminal supportive of multimedia 
                 and text manipulation for X11 and Linux framebuffer
tilda          - A drop down terminal
wterm          - It is a fork of rxvt, designed to be lightweight, but still
                 full of features
xterm          - default terminal for the X Window System
Yakuake        - (Yet Another Kuake), a dropdown terminal for KDE
EOF

workdir=$(dirname "$0")
cd "$workdir"
parameter="$1"
################# Variables for color terminal
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi; . "$DIR/Color_terminal_variables.sh"
Color_terminal_variables
#################

echo
echo "$Green You are going to install EasyMonitor and some additinal tools for it $Reset"
echo

	while true; do
	read -p "$Orange Please answer, $Green{Y}es  $Red{N}o$SmoothBlue or {u}npack $LRed$Blink?:$Reset$Yellow $Movebk" -n 1 -r REPLY
	REPLY=$(tr '[A-Z]' '[a-z]' <<<"$REPLY")
	if [[ "$REPLY" = "u" ]]
	then :
		parameter="unpack"
		REPLY="y"
	fi
	
	case $REPLY in
	
	[uy]* ) echo;echo " Yes";echo
	
	###################
	# Check parent directory name
	
	if ! [[ "$(basename $(pwd))" = "EasyMonitor_install" ]]
	then
		echo
		echo "You have to install from directory named $LRed$Blink "EasyMonitor_install" copy files... $Reset"
		echo
		mkdir -p "../EasyMonitor_install" && cp -fr "$(pwd)/"* "../EasyMonitor_install" && cd "../EasyMonitor_install" || exit 1
		
	fi

	#####################
	
	you_user_login="$(whoami)"
	
	echo "$Magenta Your user have to be allowed to use sudo command, for exaple belong to: sudo, users, wheel - groups."
	echo " In some new instalations you need also to give a password for root -$Yellow passwd root$Magenta or -$Yellow sudo su; passwd$Reset"
	echo "$Nline$Green Your user login name is $Magenta $you_user_login $Green And belong to group:$Cyan $(groups $you_user_login)$Reset"
	echo "$Nline$LRed Give root paswoord if you need:$Green add $Magenta$you_user_login$Green to$Cyan sudo, users, wheel$Green group$LRed or Enter for skip.$Reset"
		
		#####################
		# Add user to sudo users
		
		if ! [[ "$parameter" = "unpack" ]]
		then :
			if [ $(id -u) = 0 ]
			then
				echo "$Nline$Orange You are root now skipp...$Reset$Nline"
			else
				su -c "/bin/bash add_user_to_groups.sh $you_user_login"
				if [ $? != 0 ];then echo "$Nline$Orange Skipped add user to sudo users group$Reset$Nline";fi
			fi
			###################
			# Get and install additinal packages and tools for it
			/bin/bash "../EasyMonitor_install/get_additinal_packages.sh"
			echo
			
			###################
			# Compile hdmon and install in /usr/bin :
			/bin/bash "../EasyMonitor_install/compile_install_hdmon.sh"
			echo
			
			###################
			# Modyfy sudoers file to full work all features"
			echo "$LMagenta Now you are going to modify sudoers file to full work all features for Easy Monitor$Nline$LRed Give root paswoord if you need or Enter for skip.$Nline$Reset"
			su -c "/bin/bash "../EasyMonitor_install/modify_sudoers.sh""
			if [ $? != 0 ];then echo "$Nline$Orange Skipped modyfy sudoers file$Reset$Nline";fi
			echo
		fi
	##################
	# Check enviroment
	# remove versin < 0.9.8
	/bin/bash "../EasyMonitor_install/old_version_remove.sh"
	
	Themes_Prefix="$HOME/.superkaramba/"
	Easy_Monitor_Work_Dir="EasyMonitor"
	Easy_Monitor_Backup="Easy_Monitor_$(date +%Y_%m_%d-%H_%M_%S)"
	Easy_Monitor_Package="EasyMonitor.skz"
	##################
	
	echo "$Nline$Green"You are going to copy EasyMonitor to "$Themes_Prefix$Easy_Monitor_Work_Dir" directory to full work all features"$Reset$Nline"
		
		###################
		# Backup old installation if exist
		if [ -d "$Themes_Prefix$Easy_Monitor_Work_Dir" ]; then
		  echo "$Yellow$Easy_Monitor_Work_Dir exist - move it to $Themes_Prefix$Easy_Monitor_Backup$Reset"
		  echo
		  old_pwd=$(pwd)
		  cd $Themes_Prefix
		  if [ $? = 0 ]; then
			rm -fr "$Easy_Monitor_Backup" > /dev/null 2>&1
			mv "$Easy_Monitor_Work_Dir" "$Easy_Monitor_Backup"
			echo
		  else
			echo "$LRed$Blink Error: cd $Themes_Prefix exit 1$Reset"; exit 1
		  fi
		  cd  "$old_pwd"
		fi
		###################
		# Copy Easy Monitor to SuperKaramba themes directory
		mkdir -p "$Themes_Prefix$Easy_Monitor_Work_Dir" || { echo "$LRed$Blink Error: mkdir -p $Themes_Prefix$Easy_Monitor_Work_Dir exit 1$Reset"; exit 1 ;}
		cp -fr "../EasyMonitor_install"/* "$Themes_Prefix$Easy_Monitor_Work_Dir"/
		
		# Replace "wlan0" devive name to active device name
		COMMAND=$(whereis -b ip |awk '{print $2}')
		if [ -x "$COMMAND" ]; then
			interface=$($COMMAND route | head -n1 | awk '{print $5}')
		else
			COMMAND=$(whereis -b route | awk '{print $2}')
			if [ -x "$COMMAND" ]; then
			interface=$($COMMAND -n | grep 'UG' | awk '{print $8}'| head -n1)
			fi
		fi
		
		if [[ -z $interface ]]; then interface="wlan0"; fi
		check=$(grep "$interface" /proc/net/dev)
		if ! [ -n "$check" ]; then interface="wlan0"; fi
		
		interface_themes="EM_Big_Areo_0.theme EM_Big_Areo_1.theme EM_Big_Areo_2.theme EM_Big_Tech_1.theme EM_Net_WlanX_Interface.theme"
		cd "$Themes_Prefix$Easy_Monitor_Work_Dir/themes"
		# identify matching string
		device=$(sed -n "s|sensor=network device=*[ \t]*|&|p" $interface_themes)
		device="${device##*device=}"
		device="${device%% *}"
		#
		echo "$Nline$Yellow old interface is: $Orange"$device"$Reset"
		echo "$Yellow new interface is: $Orange"$interface"$Nline$Yellow replace in: $Cyan$interface_themes $Reset"
		sed -i -e "s|sensor=network device=$device|sensor=network device=$interface|" $interface_themes
		###################
		# Init themes
		if ! [[ "$parameter" = "unpack" ]]
		then :
			/bin/bash "$Themes_Prefix$Easy_Monitor_Work_Dir"/run_themes.sh > /dev/null 2>&1
		fi
	break;;
	
	[Nn]* ) echo;echo " No"; break;;
	* ) echo;echo " Please answer Y or N.";;
	esac
	done

echo "$Nline$Green$Blink The end...$Reset$Nline"
sleep 10
exit