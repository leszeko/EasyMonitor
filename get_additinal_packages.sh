#!/bin/bash
# get_additinal_packages.sh for Easy Monitor
################# Variables for color terminal
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi; . "$DIR/Color_terminal_variables.sh"
Color_terminal_variables
#################
function r_ask() { read -p "$1 ([Y]es or [N]o): " -n 1 -r; case $(echo $REPLY | tr '[A-Z]' '[a-z]') in y|yes) echo "yes" ;; *) echo "no" ;; esac }
#################
echo
echo "Now you are going to install additinal tools for it"
echo "First installing  superkaramba, xdg-utils, lm-sensors, nmpam, kde-systemsettings, hddtemp, hdparm, partitionmanager.."
echo
if [[ "no" == $(r_ask "$Green install additinal tools, Please answer or Enter for skip$Red") ]]; then echo "$Nline$Orange Skipped install additinal tools$Reset"
else echo "$Reset"
	echo "Give administrator password for install by zypper or apt-get, urpmi, pacman, yum, equo, slapt-get.."
	echo "or Enter for skip"
	echo
	MANAGER=0
	# OpenSuse zypper
	if [ -x /usr/bin/zypper ] && [ $MANAGER = 0 ]; then
	echo "$Nline$Green # /usr/bin/zypper : sudo /usr/bin/zypper install -R ...$Reset$Nline"
	sudo /usr/bin/zypper install -R xdg-utils superkaramba konsole kate kdialog zip lsb-release iproute2 wireless-tools net-tools ethtool acpi wget nmap sensors hddtemp hdparm partitionmanager konqueror kinfocenter dmidecode Mesa-demo-x mesa-demo-x sane-backends bc gcc make
	MANAGER=1
	fi
	
	# Ubuntu apt-get
	if [ -x /sbin/apt-get ] && [ $MANAGER = 0 ]; then
	echo "$Nline$Green # /sbin/apt-get : su -c apt-get install ...$Reset$Nline"
	su -c "apt-get update; apt-get install superkaramba xdg-utils acpi lm-sensors hddtemp hdparm nmap partitionmanager konsole kate kdialog konqueror kinfocenter ksysguard ethtool wget dmidecode bc gcc gawk"
	MANAGER=1
	fi
	
	# Ubuntu apt-get
	if [ -x /usr/bin/apt-get ] && [ $MANAGER = 0 ]; then
	echo "$Nline$Green # /usr/bin/apt-get : su -c apt-get install ...$Reset$Nline"
	su -c "apt-get update;for package in sudo superkaramba xdg-utils kde-utils-superkaramba plasma-scriptengine-superkaramba acpi lm-sensors hddtemp hdparm nmap partitionmanager konsole kdialog zip kate konqueror kinfocenter ksysguard ethtool wget dmidecode bc gcc gawk; do echo $'\033[00;31m'; echo \$package; echo $'\033[0;0m'; apt-get install -y \$package; done"
	# http://packages.linuxmint.com/pool/import/s/superkaramba/
	which superkaramba
	[ $? = 0 ] || {
	arch_type=$(uname -m)
	if [[ "${arch_type}" = *"64"* ]]
	then :
		arch_type="amd64.deb"
	else :
		arch_type="i386.deb"
	fi
	wget -O $HOME/plasma-scriptengine-superkaramba_4.14.2-0ubuntu1~ubuntu14.04~ppa1_${arch_type} http://packages.linuxmint.com/pool/import/s/superkaramba/plasma-scriptengine-superkaramba_4.14.2-0ubuntu1~ubuntu14.04~ppa1_${arch_type}
	sudo dpkg -i $HOME/plasma-scriptengine-superkaramba_4.14.2-0ubuntu1~ubuntu14.04~ppa1_${arch_type}
	sudo apt-get -f install
	sudo dpkg -i $HOME/plasma-scriptengine-superkaramba_4.14.2-0ubuntu1~ubuntu14.04~ppa1_${arch_type}
	}
	MANAGER=1
	fi
	
	# Mandriva urpmi
	if [ -x /usr/sbin/urpmi ] && [ $MANAGER = 0 ]; then
	echo "$Nline$Green # /usr/sbin/urpmi : su -c urpmi ...$Reset$Nline"
	su -c "urpmi --auto-select; for package in superkaramba xdg-utils kate kdialog acpi lm_sensors hddtemp hdparm nmap partitionmanager konsole vim netstat-nat kinfocenter ethtool lsb-release net-tools sane imagemagick kim wget dmidecode bc gcc make; do echo $'\033[00;31m'; echo \$package; echo $'\033[0;0m'; /usr/sbin/urpmi \$package; done"
	MANAGER=1
	fi
	
	# Arch pacman
	if [ -x /usr/bin/pacman ] && [ $MANAGER = 0 ]; then
	echo "$Nline$Green # /usr/bin/pacman : sudo pacman -Su --needed ...$Reset$Nline"
	sudo pacman -Syu; for package in kdeutils-superkaramba xdg-utils kate kdialog lsb-release net-tools wireless_tools nmap ethtool konsole netstat-nat acpi hddtemp hdparm lm_sensors sane imagemagick kim4 wget dmidecode bc gcc; do echo $'\033[00;31m'; echo $package; echo $'\033[0;0m'; sudo pacman -Su --needed $package; done
	which superkaramba
	[ $? = 0 ] || {
	wget -O $HOME/superkaramba-15.08.3-2-$(uname -m).pkg.tar.xz http://archive.archlinux.org/packages/k/kdeutils-superkaramba/kdeutils-superkaramba-15.08.3-2-$(uname -m).pkg.tar.xz
	[ $? = 0 ] && { sudo pacman -U $HOME/superkaramba* ;}
	}
	MANAGER=1
	fi
	
	# Fedora
	if [ -x /usr/bin/yum ] && [ $MANAGER = 0 ]; then
	echo "$Nline$Green # /usr/bin/yum : sudo yum install ...$Reset$Nline"
	for package in superkaramba kdeutils-superkaramba xdg-utils konsole kate kdialog redhat-lsb net-tools ethtool acpi wget nmap kde-partitionmanager lm_sensors hddtemp hdparm sane ImageMagick wget dmidecode bc gcc; do echo $'\033[00;31m'; echo $package; echo $'\033[0;0m';sudo yum install $package; done	
	MANAGER=1
	fi
	
	# Sabayon
	if [ -x /usr/bin/equo ] && [ $MANAGER = 0 ]; then
	echo "$Nline$Green # /usr/bin/equo : sudo equo install ...$Reset$Nline"
	# superkaramba-15.08.3-1.1.x86_64.rpm
	sudo equo up
	sudo equo install --ask superkaramba xdg-utils lsb-release mesa-progs konsole kate kdialog hddtemp hdparm acpi lm_sensors nmap partitionmanager netstat-nat ethtool net-tools sane-backends imagemagick wget dmidecode bc gcc
	MANAGER=1
	fi
	
	# Proteus usm
	if [ -x /usr/bin/usm ] && [ $MANAGER = 0 ]; then
	echo "$Nline$Green # /usr/bin/usm : /usr/bin/usm -g ...$Reset$Nline"
	su -c "usm -u all; for package in xxx superkaramba xdg-utils kate kdialog acpi lm_sensors hddtemp hdparm nmap iproute2 konsole vim netstat-nat ethtool net-tools sane imagemagick kim wget dmidecode bc gcc make liberation-fonts-ttf; do echo $'\033[00;31m'; echo \$package; echo $'\033[0;0m'; /usr/bin/usm -g \$package; done"
	MANAGER=1
	fi
comment=cat<<-EOF
	# Solus
	if [ -x /usr/bin/eopkg ] && [ $MANAGER = 0 ]; then
	echo "$Nline$Green # /usr/bin/eopkg upgrade : sudo eopkg upgrade... $Reset$Nline"
	sudo eopkg upgrade
	for package in kconfig superkaramba xdg-utils kde-utils-superkaramba plasma-scriptengine-superkaramba acpi lm-sensors hddtemp hdparm nmap partitionmanager konsole kdialog kate konqueror kinfocenter ksysguard ethtool wget dmidecode bc gcc gawk; do echo $'\033[00;31m'; echo $package; echo $'\033[0;0m'; sudo eopkg install $package; done
	MANAGER=1
	fi
EOF
	
	# Slakware /usr/sbin/netpkg
	if [ -x /usr/sbin/netpkg ] && [ $MANAGER = 0 ]; then
	echo "$Nline$Green # /usr/sbin/netpkg : su -c /usr/sbin/netpkg...$Reset$Nline"
	su -c "for package in superkaramba xdg-utils kate kdialog acpi lm_sensors hddtemp hdparm nmap  konsole vim netstat-nat ethtool net-tools sane imagemagick kim wget dmidecode bc gcc make iproute2 liberation-fonts-ttf python sudo; do echo $'\033[00;31m'; echo \$package; echo $'\033[0;0m'; /usr/sbin/netpkg \$package; done"
	MANAGER=1
	fi
	
	# Slakware slackpkg
	if [ -x /usr/sbin/slackpkg ] && [ $MANAGER = 0 ]; then
	echo "$Nline$Green # /usr/sbin/slackpkg : su -c slackpkg install ...$Reset$Nline"
	su -c "slackpkg update; for package in superkaramba xdg-utils kate kdialog acpi lm_sensors hddtemp hdparm nmap konsole vim netstat-nat ethtool net-tools sane imagemagick kim wget dmidecode bc gcc make iproute2 liberation-fonts-ttf python sudo; do echo $'\033[00;31m'; echo \$package; echo $'\033[0;0m'; slackpkg install \$package; done"
	MANAGER=1
	fi
	
	# Vector
	if [ -x /usr/sbin/slapt-get ] && [ $MANAGER = 0 ]; then
	echo "$Nline$Green # /usr/sbin/slapt-get : su -c slapt-get --install ...$Reset$Nline"
	su -c "slapt-get -u; for package in superkaramba xdg-utils sudo konsole kate kdialog hdparm lm_sensors nmap ethtool net-tools sane acpid imagemagick wget dmidecode bc gcc iproute2 liberation-fonts-ttf; do echo $'\033[00;31m'; echo \$package; echo $'\033[0;0m';slapt-get --install \$package; done"
	MANAGER=1
	fi
	
	# VOID /usr/bin/xbps-install
	if [ -x /usr/bin/xbps-install ] && [ $MANAGER = 0 ]; then
	echo "$Nline$Green # /usr/bin/xbps-install : su -c /usr/bin/xbps-install...$Reset$Nline"
	su -c "xbps-install -S superkaramba; for package in xdg-utils kate kdialog acpi lm_sensors hddtemp hdparm nmap konsole vim netstat-nat ethtool net-tools sane imagemagick kim wget dmidecode bc gcc make iproute2 liberation-fonts-ttf python sudo glxinfo qimageblitz; do echo $'\033[00;31m'; echo \$package; echo $'\033[0;0m'; /usr/bin/xbps-install \$package; done"
	MANAGER=1
	fi
	
	
	if [ $MANAGER = 0 ]; then echo "$LRed"
	echo "Can't find suitable software manager for download and install additinal packages. Try do it manually"
	echo "You need install: superkaramba xdg-utils konsole kate lsb-release iproute2 net-tools ethtool acpi wget nmap sensors hddtemp hdparm partitionmanager konqueror kinfocenter dmidecode mesa-demo sane bc gcc"
	echo "$Reset"
	fi
	
	echo "$Nline$Green # Done #$Reset$Nline"
	
	which superkaramba
	[ $? = 0 ] || {
	echo "$Nline$Red Can't find superkaramba package. Try install it manualy ! $Reset"
	echo "$Nline$Green Superkaramba is considered to be \"legacy\" and some new distros don't provide it in standard repos"
	echo " So you have to look for it on your own.$Nline"
	
	echo " Example:"
	echo " xdg-open 'https://software.opensuse.org/package/superkaramba'"
	echo " xdg-open 'https://www.rpmfind.net/linux/rpm2html/search.php?query=superkaramba&submit=Search+...'"
	echo " xdg-open 'http://rpm.pbone.net/index.php3/stat/2/simple/2'"
	echo " xdg-open 'http://archive.archlinux.org/packages/k/kdeutils-superkaramba/'"
	echo " xdg-open 'http://packages.linuxmint.com/search.php?release=any&section=any&keyword=superkaramba'"	
	echo " xdg-open 'https://www.google.com/search?q=kdeutils-superkaramba-15.08.3-1-*.pkg.tar.xz'"
	echo "$Nline For example: superkaramba-15.08.3-1.1.x86_64.rpm package works on Sabayon"
	echo " After downloading a package that seems to be match for your system"
	echo " you can try simply unpack package and even copy files/folders"
	echo " from unpack archive as them belong into your file system as root"
	echo " missing libs can be in different tree - lib - lib64"
	echo " then run superkaramba from konsole and look for missing dependencies.."
	echo "$Reset"
	exit 1
	}
	
	
fi
###################
echo
echo "Now configure Lm sensors - Linux hardware monitoring @ http://lm-sensors.org/"
echo

if [[ "no" == $(r_ask "$Green configure Lm sensors, Please answer or Enter for skip$Red") ]]; then echo "$Nline$Orange Skipped configure Lm sensors$Reset"
else echo "$Reset"
	if [ -x /usr/sbin/sensors-detect ]; then
	sudo /usr/sbin/sensors-detect
	sudo modprobe coretemp
	fi
	
	if [ -x /sbin/sensors-detect ]; then
	sudo /sbin/sensors-detect
	sudo modprobe coretemp
	fi
	echo;echo "Done"
	echo "$Nline$Green # Done #$Reset"
	
fi
