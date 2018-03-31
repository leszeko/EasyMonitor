#!/bin/bash
# compile_hdmon.sh script for Easy Monitor

################## Variables for color terminal
Green=""$'\033[00;32m'"" Red=""$'\033[00;31m'"" White=""$'\033[00;37m'"" Yellow=""$'\033[01;33m'"" Cyan=""$'\033[00;36m'"" Blue=""$'\033[00;34m'"" Magenta=""$'\033[00;35m'""
GREEN=""$'\033[01;32m'"" RED=""$'\033[01;31m'"" WHITE=""$'\033[01;37m'"" YELLOW=""$'\033[01;33m'"" CYAN=""$'\033[01;36m'"" BLUE=""$'\033[01;34m'"" MAGENTA=""$'\033[01;35m'""
n=""$'\n'"" Blink=""$'\033[5m'"" Back=""$'\b'"" Reset=""$'\033[0;0m'""; if [[ $TERM != *xterm* ]]; then SMOOTHBLUE=$BLUE;Orange=$Yellow;ORANGE=$YELLOW;Cream=$Magenta;CREAM=$MAGENTA;else
SmoothBlue=""$'\033[00;38;5;111m'"";Cream=""$'\033[00;38;5;5344m'"";Orange=""$'\033[00;38;5;714m'""
SMOOTHBLUE=""$'\033[01;38;5;111m'"";CREAM=""$'\033[01;38;5;5344m'"";ORANGE=""$'\033[01;38;5;714m'"";fi
#################
function r_ask() { read -p "$1 ([Y]es or [N]o): " -n 1 -r; case $(echo $REPLY | tr '[A-Z]' '[a-z]') in y|yes) echo "yes" ;; *) echo "no" ;; esac }
#################
echo
echo " Setup: hdmon"
echo
echo " hdmon is a command that displays I/O disks activity of drives. License: GPL "
echo " By iten (iten at free dot fr) 2004"
echo " Source @ http://kde-look.org/content/show.php/Disk+I%2BO++Activity+and+Temperatures?content=11814"
echo " ================================================================================================="
echo " Compile hdmon and install in /usr/bin :"
echo " You will need command make and gcc compiler"
echo " 1. cd ./hdmon"
echo " 2. cleaning just in case by remove file with the command: 'rm ./hdmon'"
echo " 3. compile the hdmon.c to binary with the following command: make"
echo " 4. copy hdmon to '/usr/bin/'  directory witch: 'sudo cp -fax ./hdmon /usr/bin/'"
echo " 5. cleaning by remove file with the command: 'rm ./hdmon'"
echo

if [[ "no" == $(r_ask "$GREEN compile the hdmon.c, Please answer or Enter for skip$Red") ]]; then echo "$n$Orange Skipped compile the hdmon.c$Reset"
else echo "$Reset"
	TEST=`which gcc`
	if [ $? = 0 ]; then # If success
	echo " gcc ok compile the hdmon.c"; echo
	else
	echo " You have to install gcc compiler"
		
		MANAGER=0
		
		# OpenSuse zypper
		if [ -x /usr/bin/zypper ]; then
		sudo /usr/bin/zypper install -R gcc make
		MANAGER=1
		fi
		
		# Ubuntu apt-get
		if [ -x /sbin/apt-get ]; then
		sudo apt-get install gcc make
		MANAGER=1
		fi
		
		# Ubuntu apt-get
		if [ -x /usr/bin/apt-get ]; then
		sudo apt-get install gcc make
		MANAGER=1
		fi
		
		# Mandriva urpmi
		if [ -x /usr/sbin/urpmi ]; then
		sudo urpmi gcc make
		MANAGER=1
		fi
		
		# Arch pacman
		if [ -x /usr/bin/pacman ]; then
		sudo pacman -Syu --needed gcc make
		MANAGER=1
		fi
		
		# Fedora
		if [ -x /usr/bin/yum ]; then
		sudo yum install gcc make
		MANAGER=1
		fi
		
		# Sabayon
		if [ -x /usr/bin/equo ]; then
		sudo equo install gcc make
		MANAGER=1
		fi
		
		if [ $MANAGER = 0 ]; then
		
		echo "$RED"
		echo " Can't find suitable software manager for download and install additinal packages. Try do it manually"
		echo " You need install:  gcc"
		echo "$Reset"
		fi
		
	fi
	
	cd ./hdmon
	if [ $? = 0 ]; then # If success
	rm ./hdmon --force
	make
	else
	break
	fi
	
	echo
	echo " Give administrator password for copy hdmon to /usr/bin/ folder"
	echo " or Enter for skip"
	echo
	
	sudo cp -faxv ./hdmon /usr/bin/
	rm -v ./hdmon --force
	cd ..
	
	echo "$n$Green # Done# #$Reset"
	
fi