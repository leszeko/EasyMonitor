#!/bin/bash 
# file_system_hdd_test.sh script

#################
# Variables for color terminal requests
[[ -t 2 ]] && {
	alt=$(tput smcup||tput ti)	ealt=$(tput rmcup||tput te)	hide=$(tput civis||tput vi)	show=$(tput cnorm||tput ve)
	# Start alt display		# End alt display		# Hide cursor			# Show cursor
	save=$(tput sc)			load=$(tput rc)			stout=$(tput smso||tput so)	estout=$(tput rmso||tput se)
	# Save cursor			# Load cursor			# Start stand-out		# End stand-out
	under=$(tput smul||tput us)	eunder=$(tput rmul||tput ue)	italic=$(tput sitm||tput ZH)	eitalic=$(tput ritm||tput ZR)	
	# Start underline		# End underline			# Start italic	 		# End italic
	bold=$(tput bold||tput md)	blink=$(tput blink||tput mb)	reset=$(tput sgr0||tput me)	n=""$'\n'""
	# Start bold			# Start blinking		# Reset cursor 			# New line LF
[[ $TERM != *-m ]] && {
	red=$(tput setaf 1||tput AF 1)		green=$(tput setaf 2||tput AF 2)	yellow=$(tput setaf 3&&tput bold|| tput AF 3)
	orange=$(tput setaf 3||tput AF 3)	blue=$(tput setaf 4||tput AF 4)		magenta=$(tput setaf 5|| tput AF 5)
	cyan=$(tput setaf 6||tput AF 6);};	white=$(tput setaf 7||tput AF 7)	default=$(tput op)

	eed=$(tput ed||tput cd)		eel=$(tput el||tput ce)		ebl=$(tput el1||tput cb)	ewl=$eel$ebl
	# Erase to end of display	# Erase to end of line		# Erase to beginning of line	# Erase whole line
	draw=$(tput -S <<< 'enacs smacs acsc rmacs' || { \ tput eA; tput as; tput ac; tput ae; } )	back=""$'\b'""
	# Drawing characters;
	} 2>/dev/null ||:
#################

echo "$orange#-----------------------------------------------------------------------------#$reset$n"
echo " # file_system_hdd_test.sh script #$reset$n"

echo "$orange#-----------------------------------------------------------------------------#$reset$n"
echo "$n$green # Command: sudo /sbin/fdisk $1 -l =$reset$n"
sudo /sbin/fdisk $1 -l

echo "$yellow#-----------------------------------------------------------------------------#$reset$n"

if [ -x /usr/sbin/hddtemp ]; then
echo "$n$green # Command: sudo /usr/sbin/hddtemp $1 =$reset$n"; sudo /usr/sbin/hddtemp $1

else
echo "$n$red # The program ´hddtemp´ not found in the following path: /usr/sbin/hddtemp $reset$n"
echo "Try installing with: 'sudo apt-get install hddtemp' or 'sudo zypper install hddtemp'..."

MANAGER=0
if [ -x /usr/bin/zypper ]; then echo "$n$green # /usr/bin/zypper : $reset$n";	sudo zypper install hddtemp; MANAGER=1; fi # OpenSuse... zypper
if [ -x /sbin/apt-get ]; then echo "$n$green # /sbin/apt-get : $reset$n";	sudo /sbin/apt-get install hddtemp; MANAGER=1; fi #  Ubuntu, Debian, Deepin... apt-get
if [ -x /usr/sbin/urpmi ]; then echo "$n$green # /usr/bin/apt-get : $reset$n";	sudo /usr/sbin/urpmi install hddtemp; MANAGER=1; fi #  Ubuntu, Debian, Deepin... apt-get
if [ -x /usr/sbin/urpmi ]; then echo "$n$green # /usr/sbin/urpmi : $reset$n";	sudo /usr/sbin/urpmi hddtemp; MANAGER=1; fi # Mandriva... urpmi
if [ -x /usr/bin/pacman ]; then echo "$n$green # /usr/bin/pacman : $reset$n";	sudo /usr/bin/pacman -Syu --needed hddtemp; MANAGER=1; fi # Arch, Manjaro... pacman
if [ -x /usr/bin/yum ]; then echo "$n$green # /usr/bin/yum : $reset$n";		sudo /usr/bin/yum install hddtemp; MANAGER=1; fi # Fedora...
if [ -x /usr/bin/equo ]; then echo "$n$green # /usr/bin/equo : $reset$n";	sudo /usr/bin/equo install hddtemp; MANAGER=1; fi # Sabayon...
if [ -x /usr/sbin/slapt-get ]; then echo "$n$green # /usr/sbin/slapt-get : $reset$n"; su -c "slapt-get --install hddtemp"; MANAGER=1; fi # Vector...

if [ $MANAGER = 0 ]; then echo "$red Can't find suitable software manager for download and install additinal packages. Try do it manually$reset"; fi

if [ -x /usr/sbin/hddtemp ]; then echo "$n$green # Command: sudo /usr/sbin/hddtemp $1 =$reset$n"; sudo /usr/sbin/hddtemp $1; fi

fi

echo "$yellow#-----------------------------------------------------------------------------#$reset"
if [ -x /sbin/hdparm ]; then
echo "$n$green # Command: sudo /sbin/hdparm -tT $1 =$reset"
sudo /sbin/hdparm -tT $1

else
echo "$n$red # The program 'hdparm' not found in the following path: /sbin/hdparm $reset$n"
echo "Installing with: 'sudo apt-get install hdparm' or 'sudo zypper install hdparm'..."
MANAGER=0
PACKAGE=hdparm
if [ -x /usr/bin/zypper ];	then echo "$n$green # /usr/bin/zypper : $reset$n";	sudo zypper install $PACKAGE; MANAGER=1; fi
if [ -x /sbin/apt-get ];	then echo "$n$green # /sbin/apt-get : $reset$n";	sudo /sbin/apt-get install $PACKAGE; MANAGER=1; fi
if [ -x /usr/bin/apt-get ];	then echo "$n$green # /usr/bin/apt-get : $reset$n";	sudo /usr/bin/apt-get install $PACKAGE; MANAGER=1; fi
if [ -x /usr/sbin/urpmi ];	then echo "$n$green # /usr/sbin/urpmi : $reset$n";	sudo /usr/sbin/urpmi $PACKAGE; MANAGER=1; fi
if [ -x /usr/bin/pacman ];	then echo "$n$green # /usr/bin/pacman : $reset$n";	sudo /usr/bin/pacman -Syu --needed $PACKAGE; MANAGER=1; fi
if [ -x /usr/bin/yum ];		then echo "$n$green # /usr/bin/yum : $reset$n";		sudo /usr/bin/yum install $PACKAGE; MANAGER=1; fi
if [ -x /usr/bin/equo ];	then echo "$n$green # /usr/bin/equo : $reset$n";	sudo /usr/bin/equo install $PACKAGE; MANAGER=1; fi
if [ -x /usr/sbin/slapt-get ];	then echo "$n$green # /usr/sbin/slapt-get : $reset$n";	su -c "slapt-get --install $PACKAGE"; MANAGER=1; fi

if [ $MANAGER = 0 ]; then echo "$red Can't find suitable software manager for download and install additinal packages. Try do it manually$reset"; fi

if [ -x /sbin/hdparm ]; then echo "$n$green # Command: sudo /sbin/hdparm -tT $1 =$reset$n"; sudo /sbin/hdparm -tT $1; fi

fi

echo "$yellow#-----------------------------------------------------------------------------#$reset"
if [ -x /usr/bin/hdmon ]; then echo "$n$green hdmon is in /usr/bin/hdmon$reset$n"
else
cd $HOME/.superkaramba/EasyMonitor/; /bin/bash compile_install_hdmon.sh
fi

#if [ -x /sbin/e2fsck ] ;
#then sudo /sbin/e2fsck $1 -nf -C0
#else
#echo "$n$red # The program ´e2fsck´ not found in the following path: /sbin/e2fsck $reset$n"
#echo "Try installing with: 'sudo apt-get install e2fsprogs' or 'sudo zypper install e2fsprogs'..."
#fi

echo "$n$magenta$blink Done $reset$n"
