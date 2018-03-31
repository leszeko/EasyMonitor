#!/bin/bash
# new_arch_install.sh script
# Test Install Arch Linux into a partition script for Easy Monitor - Test beta,
# by Leszek Ostachowski (2016) GPL V2 inspiration "vps2arch" script by Timothy Redaelli <tredaelli@archlinux.info>

# https://wiki.archlinux.org/index.php/Beginners
# https://wiki.archlinux.org/index.php/Installation_guide
# https://wiki.archlinux.org/index.php/Install_from_existing_Linux

Begin () {

prepare_check_environment
get_parameters
get_data_for_user
ask_for_install
make_file_system_type
download_bootstrap
mount_destination
extract_bootstrap
mount_new_root
configure_bootstrap
init_pacman
install_base_packages
install_desktop_environment
install_network
install_additional_packages
additional_firmware_packages
create_initial_ramdisk
configure_bootloader
add_to_grub
make_backup_of_pckages
ask_passwd
end_message
umount_new_root

}

##################
get_parameters () {

# Parameters to change

post_fix=_`date +%F`

host_name="Arch$post_fix"

user_login="archi"
# name of your user account

cpu_type="x86_64"
# i686 ; x86_64

country_setup="Polski"
# ="Polski" for Polish
# ="Русский" Rosyjski
# ="USA" English
#
#
#

arch_backup="/arch_backup"
# if you install from Arch you can use (root) - "/" and turn off backup=no

backup="yes"
# if "yes" - Saving a pacman download packages for future installations
# need place in $arch_backup - root filesystem ( about 1,5GB and depend on your choice of packages)

file_system_type="ext4"
# to format paririon for Arch
# https://wiki.archlinux.org/index.php/File_systems

# You can finish hier, but if you want - Packages selection
##################

boot_loader="grub_2"	     # install boot loader Grub 2 into a install parirtin
install_grub_mbr="ask"	     # ask for install in MBR
# ask ; install_grub_mbr="/dev/sda";install_grub_mbr="/dev/sdb"
# wget -O "Dark_Colors_Grub2_theme.tar.gz" "https://dl.opendesktop.org/api/files/download/id/1486292320/Dark_Colors_Grub2_theme.tar.gz"
grub_theme_package_url="https://dl.opendesktop.org/api/files/download/id/1486292320/Dark_Colors_Grub2_theme.tar.gz"
grub_theme_package="Dark_Colors_Grub2_theme.tar.gz"
grub_theme_name="Dark_Colors"
# https://wiki.archlinux.org/index.php/GRUB

#
# it is possible to install Grub on partition - Example: "dev/sda1"

# To install Grub in MBR on ( /dev/sda ; /dev/sdb...)
# sudo grub-install --recheck <device>

# Install Grub into parition ( /dev/sda1 ; /dev/sdb3...)
# grub-install --recheck --force <device>

# You can prepare USB stick with fdisk - / delete partition / and make new one / and do not forget to set the boot flag for it

# and boot from another boot loader
# Example for old Grub :
# to find root dev type in konsole :

# file_to_find="/boot/vmlinuz-linux" # file should be unique L)
# su -c "grub_root_dev=\$(echo \"find $file_to_find\"|grub|grep '(hd'| head -1)\"\";echo \"\$grub_root_dev\""

#--------------------#
# title Arch
#    rootnoverify (hd0,0)
#    chainloader +1
#--------------------#
# Example for new Grub :
#--------------------#
# menuentry "Arch boot loader on root = search --file /$xxx_file_to_find --class arch {
#  search --file --no-floppy --set=root /$xxx_file_to_find
#  chainloader +1
# }
#--------------------#
# Device naming has changed between GRUB Legacy and GRUB. Partitions are numbered from 1 instead of 0 while drives are still numbered from 0,
# and prefixed with partition-table type. For example, /dev/sda1 would be referred to as (hd0,msdos1) (for MBR) or (hd0,gpt1) (for GPT).
# ( Old Grub start count disks from 0, partitions from 0)
# ( New Grub start count disks from 0, partitions from 1)

base_packages="base base-devel intel-ucode os-prober grub-bios lsscsi freetype2 ttf-dejavu ttf-liberation git mkinitcpio-nfs-utils ntfs-3g fuseiso lzop \
dialog dhclient wpa_supplicant ifplugd wpa_actiond crda ppp efibootmgr mtools mc sudo wget "

x_window_system="xorg-server xorg-server-utils mesa mesa-libgl"
# https://wiki.archlinux.org/index.php/xorg

desktop_environment="kde"
# ="kde" - install packages from - kde_base="..."

kde_base="kdebase-runtime phonon-qt5-vlc plasma-meta networkmanager-qt dbus oxygen-icons breeze-gtk oxygen-gtk2"
# https://wiki.archlinux.org/index.php/KDE
# for all plasma - plasma-meta
# for all packages - kde-meta-kdebase
# phonon-qt5-gstreamer gstreamer0.10-plugins
# phonon-qt5-vlc

login_manager="sddm"
login_service="sddm.service"
# https://wiki.archlinux.org/index.php/display_manager

additional_packages="gwenview konsole kate dolphin dolphin-plugins kdialog kompare \
kde-gtk-config kdegraphics-thumbnailers kdesdk-thumbnailers raw-thumbnailer ffmpegthumbs kim4 \
baka-mplayer chromium firefox qimageblitz discover ark p7zip zip unzip unrar \
qmmp arch-firefox-search gnome-disk-utility dmidecode lsb-release mesa-demos espeak kdenetwork-kget \
krita digikam kipi-plugins hugin avidemux-qt handbrake"

extra_packages="yaourt openbox openbox-themes obconf obmenu lxappearance nitrogen"
# https://wiki.archlinux.org/index.php/yaourt
# https://wiki.archlinux.org/index.php/Unofficial_user_repositories # archlinuxfr ( package-query yaourt...)
# https://wiki.archlinux.org/index.php/Openbox
# https://wiki.archlinux.org/index.php/Openbox_(Polski)

network="networkmanager"
network_service="NetworkManager.service"
# systemctl start <name>.service
# https://wiki.archlinux.org/index.php/Netctl
# https://wiki.archlinux.org/index.php/systemd-networkd
# https://wiki.archlinux.org/index.php/NetworkManager
# Configure in konsole - wifi-menu -o or nmtui
# /etc/netctl/wireless-wpa
# plasma-nm
# nm-applet

additional_systemctl_start_services=""
# Start additional services - To configure aftrt first boot "systemd-firstboot.service"
# https://wiki.archlinux.org/index.php/Systemd

#firmware_nvidia_cards=""
firmware_nvidia_cards="nvidia-304xx nvidia-304xx-libgl nvidia-340xx nvidia-340xx-libgl nvidia nvidia-libgl"
#firmware_nvidia_cards="nvidia-340xx nvidia-340xx-libgl"
# ( download only, read below notes) To configure after istalation type command in konsole - su -c "pacman -Su nvidia<xx> nvidia<xx>-libgl"

# firmware_nvidia_cards="nvidia-304xx-lts nvidia-304xx-libgl nvidia-304xx-lts nvidia-304xx-libgl  nvidia-lts nvidia-libgl mesa-demos"
# ( for lts kernel download only ) To configure after istalation type command in konsole - su -c "pacman -Su nvidia<xx>-lts nvidia<xx>-libgl"

# For GeForce 400 series cards and newer [NVCx and newer], install the nvidia or nvidia package along with nvidia-libgl.
# Type command in konsole - su -c "pacman -Su nvidia nvidia-libgl"

# For GeForce 8000/9000, ION and 100-300 series cards [NV5x, NV8x, NV9x and NVAx] from around 2006-2010, install the nvidia-340xx or nvidia-340xx-lts package along with nvidia-340xx-libgl.
# su -c "pacman -Su nvidia-340xx nvidia-340xx-libgl"

# For GeForce 6000/7000 series cards [NV4x and NV6x] from around 2004-2006, install the nvidia-304xx or nvidia-304xx-lts package along with nvidia-304xx-libgl.
# su -c "pacman -Su nvidia-304xx nvidia-304xx-libgl"

# If you are on 64-bit and also need 32-bit OpenGL support, you must also install the equivalent lib32 package from the multilib repository (e.g. lib32-nvidia-libgl, lib32-nvidia-340xx-libgl or lib32-nvidia-304xx-libgl).
# https://wiki.archlinux.org/index.php/NVIDIA

linux_sound_architecture="alsa-utils alsa-plugins"
# Firmware for Advanced Linux Sound Architecture provides kernel driven sound card drivers. It replaces the original Open Sound System (OSS).
# speaker-test -c 2  $Nlineamixer scontrols  $Nline# Getting S/PDIF output  $Nlineamixer -c 0 cset name='IEC958 Playback Switch' on
# Advanced Linux Sound Architecture # https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture

: ${mirrors:="
 https://archlinux.surlyjake.com/archlinux/iso/latest/
 http://mirror.f4st.host/archlinux/iso/latest/
 http://mirror.rackspace.com/archlinux/iso/latest/"}
# https://wiki.archlinux.org/index.php/Mirrors

additional_repositories=$(cat <<-EOF

[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/\$arch

EOF
)
# https://wiki.archlinux.org/index.php/Unofficial_user_repositories
# Tip: To get a list of all servers listed in this page:
# curl 'https://wiki.archlinux.org/index.php/Unofficial_user_repositories' | grep 'Server = ' | sed "s/\$arch/$(uname -m)/g" | cut -f 3 -d' '

editor=kate
new_root_dir="/mnt/new_arch"
# End of parameters
##################

# Advanced Parameters to change
# Locale specific definitions
##################
if [[ $country_setup = "Polski" ]]; then

set_locale="LANG=pl_PL.UTF-8"

locale_gen="pl_PL.UTF-8 UTF-8"
# /etc/locale.gen
# && locale-gen
# https://wiki.archlinux.org/index.php/Locale

localtime="Europe/Warsaw"
# https://wiki.archlinux.org/index.php/Time
# /etc/localtime # ln -s /usr/share/zoneinfo/Zone/

desktop_environment_language="hunspell-pl kde-l10n-pl firefox-i18n-pl libreoffice-fresh-pl"
# libreoffice-l10n-pl iceweasel-l10n-pl

set_x11_keymap="pl"
# https://wiki.archlinux.org/index.php/Keyboard_configuration_in_Xorg

country="'Poland'"
# Country for reflector to retrieve the latest mirror list from the mirror status
# https://www.archlinux.org/mirrors/status/
# Examples
# For the below examples, a country-sorted list can be retrieved with curl:
# curl -o /etc/pacman.d/mirrorlist https://www.archlinux.org/mirrorlist/all/

# /etc/vconsole.conf
vconsole_conf=$(cat <<-EOF
# CONSOLEFONT for mkinitcpio
# or - sed -i 's/CONSOLEFONT/FONT/' /lib/initcpio/install/consolefont
# https://wiki.archlinux.org/index.php/Fonts
# localectl list-keymaps
# localectl set-keymap pl2
# localectl set-x11-keymap pl
# /etc/X11/xorg.conf.d/00-keyboard.conf # Option "XkbLayout" "pl"
# Temporary configuration loadkeys keymap
# setxkbmap -layout pl
# setfont Lat2-Terminus16 -m 8859-2
# https://wiki.archlinux.org/index.php/Keyboard_configuration_in_console
# https://wiki.archlinux.org/index.php/Keyboard_configuration_in_Xorg
# FONT=lat2-16

FONT="Lat2-Terminus16"
FONT_MAP="8859-2_to_uni"
KEYMAP="pl2"
HARDWARECLOCK="UTC"
TIMEZONE="Europe/Warsaw"
USECOLOR="yes"
CONSOLEFONT=Lat2-Terminus16

EOF
)

# /etc/locale.conf
locale_conf=$(cat <<-EOF
# To set the default global system locale for all users, type the following command as root:
# localectl set-locale LANG=pl_PL.UTF-8 or localectl set-locale LANG=en_US.UTF-8
# Launch application with different locale from terminal. Example:
# env LANG=LANG=pl_PL.UTF-8 abiword &
# Launch application with different locale from desktop. Example:
# cp /usr/share/applications/abiword.desktop ~/.local/share/applications/
# Edit the Exec command: kate ~/.local/share/applications/abiword.desktop
# Exec=env LANG=LANG=pl_PL.UTF-8 abiword %U
# LANGUAGE= This allows users to specify a list of locales that will be used in that order.

LANG=pl_PL.UTF-8
LANGUAGE=pl_PL:en_GB:en
LC_CTYPE="pl_PL.UTF-8"
LC_NUMERIC="pl_PL.UTF-8"
LC_TIME="pl_PL.UTF-8"
LC_COLLATE="pl_PL.UTF-8"
LC_MONETARY="pl_PL.UTF-8"
LC_MESSAGES="pl_PL.UTF-8"
LC_PAPER="pl_PL.UTF-8"
LC_NAME="pl_PL.UTF-8"
LC_ADDRESS="pl_PL.UTF-8"
LC_TELEPHONE="pl_PL.UTF-8"
LC_MEASUREMENT="pl_PL.UTF-8"
LC_IDENTIFICATION="pl_PL.UTF-8"
LC_ALL=

EOF
)
fi
##################
if [[ $country_setup = "Русский" ]]; then

locale_gen="ru_RU.UTF-8 UTF-8"

localtime="Europe/Moscow"

set_x11_keymap="ru"

desktop_environment_language="kde-l10n-ru firefox-i18n-ru"

country="'Russia'"

vconsole_conf=$(cat <<-EOF
KEYMAP=ru
CONSOLEFONT=cyr-sun16
FONT=cyr-sun16
CONSOLEMAP=""
USECOLOR="yes"
LOCALE="ru_RU.UTF-8"
HARDWARECLOCK="UTC"
TIMEZONE="Europe/Moscow"
EOF
)

locale_conf=$(cat <<-EOF
LOCALE=ru_RU.UTF-8
LC_MESSAGES="ru_RU.UTF-8"
EOF
)
fi
##################
if [[ $country_setup = "USA" ]]; then

set_x11_keymap="us"

vconsole_conf=$(cat <<-EOF
EOF
)

locale_conf=$(cat <<-EOF
LANG=
LANGUAGE=
LC_CTYPE="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_PAPER="en_US.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASUREMENT="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
LC_ALL="en_US.UTF-8"
EOF
)

locale_gen=""

localtime=""

desktop_environment_language=""

country="'United States'"
fi
##################
# You can create your own locale definitions based on above

##################
sudoers_file=$(cat <<-EOF
## sudoers file.
##
## This file MUST be edited with the 'visudo' command as root.
## Failure to use 'visudo' may result in syntax or file permission errors
## that prevent sudo from running.
##
## See the sudoers man page for the details on how to write a sudoers file.
##

##
## Host alias specification
##
## Groups of machines. These may include host names (optionally with wildcards),
## IP addresses, network numbers or netgroups.
# Host_Alias    WEBSERVERS = www1, www2, www3

##
## User alias specification
##
## Groups of users.  These may consist of user names, uids, Unix groups,
## or netgroups.
# User_Alias    ADMINS = millert, dowdy, mikef

##
## Cmnd alias specification
##
## Groups of commands.  Often used to group related commands together.
# Cmnd_Alias    PROCESSES = /usr/bin/nice, /bin/kill, /usr/bin/renice, \\\

#                           /usr/bin/pkill, /usr/bin/top
# Cmnd_Alias    REBOOT = /sbin/halt, /sbin/reboot, /sbin/poweroff

##
## Defaults specification
##                                                                                                                                                                                
## You may wish to keep some of the following environment variables                                                                                                               
## when running commands via sudo.                                                                                                                                                
##                                                                                                                                                                                
## Locale settings
# Defaults env_keep += "LANG LANGUAGE LINGUAS LC_* _XKB_CHARSET"
##
## Run X applications through sudo; HOME is used to find the
## .Xauthority file.  Note that other programs use HOME to find   
## configuration files and this may lead to privilege escalation!
# Defaults env_keep += "HOME"
##
## X11 resource path settings
# Defaults env_keep += "XAPPLRESDIR XFILESEARCHPATH XUSERFILESEARCHPATH"
##
## Desktop path settings
# Defaults env_keep += "QTDIR KDEDIR"
##
## Allow sudo-run commands to inherit the callers' ConsoleKit session
# Defaults env_keep += "XDG_SESSION_COOKIE"
##
## Uncomment to enable special input methods.  Care should be taken as
## this may allow users to subvert the command being run via sudo.
# Defaults env_keep += "XMODIFIERS GTK_IM_MODULE QT_IM_MODULE QT_IM_SWITCHER"
##
## Uncomment to use a hard-coded PATH instead of the user's to find commands
# Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
##
## Uncomment to send mail if the user does not enter the correct password.
# Defaults mail_badpass
##
## Uncomment to enable logging of a command's output, except for
## sudoreplay and reboot.  Use sudoreplay to play back logged sessions.
# Defaults log_output
# Defaults!/usr/bin/sudoreplay !log_output
# Defaults!/usr/local/bin/sudoreplay !log_output
# Defaults!REBOOT !log_output

##
## Runas alias specification
##

##
## User privilege specification
##
root ALL=(ALL) ALL

## Uncomment to allow members of group wheel to execute any command
%wheel ALL=(ALL) ALL

## Same thing without a password
# %wheel ALL=(ALL) NOPASSWD: ALL

## Uncomment to allow members of group sudo to execute any command
%sudo   ALL=(ALL) ALL

## Uncomment to allow any user to run sudo if they know the password
## of the user they are running the command as (root by default).
# Defaults targetpw  # Ask for the password of the target user
# ALL ALL=(ALL) ALL  # WARNING: only use this together with 'Defaults targetpw'

## Read drop-in files from /etc/sudoers.d
## (the '#' here does not indicate a comment)
#includedir /etc/sudoers.d

EOF
)

# End of advanced parameters to change
##################
}


function r_ask() { read -p "$1 [y]es or [N]o$Blink ?:$Reset$Yellow " -n 1 ; case $(echo $REPLY | tr '[A-Z]' '[a-z]') in y|yes) echo "yes" ;; *) echo "no" ;; esac }

prepare_check_environment () {

	if [ ! -t 0 ]; then # script is executed outside the terminal
	# execute the script inside a terminal window
	konsole --hold -e "/bin/bash \"$0\" $*"
	exit $?
	fi

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

	echo "$Nline$Green Install Arch Linux into partition from another distribution,..$Orange Test beta script$Reset"
	echo "$Green # by Leszek Ostachowski® (©2017) @GPL V2$Reset$Nline"
	
	if ! [ $(id -u) = 0 ]; then echo "$Nline$Orange This install Arch Linux script - $Cyan$(basename "$0")$Orange must be run with root privileges.$Reset$Nline"
	su -c "/bin/bash \"$0\" $*"
	exit $?
	fi
	
	workdir=$(dirname "$0") # usable if you set execute flag on script and run it from icon
	cd "$workdir"
	
	# Gathering informations about dowload program
	if command -v wgett >/dev/null 2>&1
	then :
		_get_command() { wget --tries=4 --timeout=35 -c "$@" ; }
		_chk_command() { env LANG=C wget --spider "$@" 2>&1 | grep Length | awk '{print $2}' ;}
	elif command -v curl >/dev/null 2>&1
	then :
		_get_command() { curl -f --speed-time 1 -L -O -C - -# "$@" ; }
		_chk_command() { env LANG=C curl -sI "$@" | grep Content-Length | cut -d ' ' -f 2 ;}
	else :
		echo "$Red Eroor: This script needs curl or wget, exit$Reset$Nline" >&2
		exit 2
	fi

	if [ -z $TMPDIR ]; then TMPDIR="/tmp"; fi
	cd "$TMPDIR"
	

	
	
	
	
}

ask_select () {

	#...# add Quit nad Enter to menu
	local x= loop_time_out= again= rest= select_list=("${options[@]}" "{N}one" "{E}nter")
	
	for (( x=$(( ${#select_list[@]}+6 )); x>0; x--))
	do
	 echo "$EraseR"
	done
	Linesup $(( ${#select_list[@]}+6 ))
	
	echo "$ask_info"
	
	# Time out loop
	# loop_time_out=$time_out
	
	while true
	do
	
	# loop_time_out=$[$loop_time_out-1]
	
	echo "$Reset$SaveP$EraseR"
	echo "$EraseR$Magenta Select and Press:$Green $(( ${#select_list[@]} ))) ${select_list[$@-1]} akcept,$Yellow $(( ${#select_list[@]}-1))) ${select_list[$@-2]} $Reset"
	echo "$EraseR"
	# Print menu loop
	for (( x=$(( ${#options[@]} )); x>0; x--))
	do
	
	if [ "$[default]" = "$x" ]; then  echo -n "$Green"; echo -n ""$'\E[6n'""; read -sdR -t 000.1 CURPOS; CURPOS=${CURPOS#*[}; Charsbk 9; fi
	echo " $x) ${select_list[$x-1]}$Reset$EraseR"
	
	done
	
	# Read key and print time out
	# IFS= Separator
	IFS= read -p "$EraseR$Nline$EraseR$Orange Preselected:$Green ${select_list[$default-1]},$Orange Select$Magenta [1-$(( ${#options[@]} ))]$Orange and {E}nter for confirm$Blink ?: " -s -N 1 -t 1 key; echo -n "$Reset"
	# \x1b is the start of an escape sequence
	if [ "$key" == $'\x1b' ]; then
	# Get the rest of the escape sequence ( 2 next - 3 max characters total)
	IFS= read -r -N 1 -t 000.1 -s rest; key+="$rest"
	IFS= read -r -N 1 -t 000.1 -s rest; key+="$rest"
	fi
	
	# echo -n "$EraseR$Nline$EraseR Starting in $loop_time_out seconds... "; echo -n "${CURPOS}"
	
	# Debug
	# echo -n "$EraseR$Nline$EraseR$Nline"
	# echo "/Key=/$EraseR\"$key\"/$EraseR"
	# echo -n "$EraseR$Nline$EraseR$"
	# echo -n "/${#key}/HEX= $EraseR"; echo "$key" | hexdump -v -e '"\\\x" 1/1 "%02x" " "'
	# echo -n "$EraseR$Nline$EraseR$"
	
	# case nuber keys
	case "$key" in [1-$((${#options[@]}))] ) default=$key; loop_time_out=$time_out ;; esac
	
	# case arrow keys
	if [ "$key" == $'\x1b[A' ]; then let "default += 1"; loop_time_out=$time_out; if [ $default -gt $(( ${#options[@]} )) ]; then default=1; fi; fi # Up
	if [ "$key" == $'\x1b[C' ]; then let "default += 1"; loop_time_out=$time_out; if [ $default -gt $(( ${#select_list[@]}-1 )) ]; then default=1; fi; fi # Right
	
	if [ "$key" == $'\x1b[B' ]; then let "default -= 1"; loop_time_out=$time_out; if [ $default -le 0 ]; then default=$(( ${#options[@]} )); fi; fi # Down
	if [ "$key" == $'\x1b[D' ]; then let "default -= 1"; loop_time_out=$time_out; if [ $default -le 0 ]; then default=$(( ${#select_list[@]}-1 )); fi; fi # Left
	
	# case chars keys
	case $(echo $key | tr '[A-Z]' '[a-z]') in [${keys[@]}] ) for (( x=0; x<${#keys}; x++)) do if [ "${keys:x:1}" = "$(echo $key | tr '[A-Z]' '[a-z]')" ]; then default=$[$x+1]; fi; done; loop_time_out=$time_out ;; esac
	
	# case Esc, Quit, Enter, time out
	if  [ "$key" == $'\x1b' ]; then read -s -N 1 -t 1 key; fi # twice Esc
	if  [ "$key" == $'\x1b' ] || [ "$key" = "$(( ${#select_list[@]}-1 ))" ] || [ "$key" = $'Quit' ] || [ "$key" = $'n' ] || [ "$key" = $'N' ]; then default=$(( ${#select_list[@]}-1 )); break
	elif [ "$key" == $'\x0a' ] || [ "$key" = "$(( ${#select_list[@]} ))" ] || [ "$key" = $'Enter' ] || [ "$key" = $'e' ] || [ "$key" = $'E' ]; then break
	# elif [ $loop_time_out = 0 ] ; then break
	fi
	echo -n "$RestoreP"
	done
	
	# calculate result
	Selected="${select_list[default-1]}"
	# echo "$Nline Akcepted: $Selected"
	# echo " Pos: $default"

}

chroot_exec() {
	
	# Execute command "$*" in chroot in $new_root_dir" enviroment
	
	chroot "$new_root_dir" /bin/bash -c "$*"
}

ask_for_install () {
	
	
	fdisk -l
	
	echo  "$LCyan Tip - You can use mouse to highlight names and then use copy paste in konsole for give answers"
	
	echo " You can also use this script to install Arch on usb stick formatted with partition at least 8G$Nline and then run as USB HDD on another computer to install.$Nline If you install from Arch - change in script '$arch_backup' folder on (root) = '/'$Reset$Nline$Green You can prepare USB stick with fdisk - / delete partition / and make new one / and do not forget to set the boot flag for it$Reset$Nline"
	
	echo  "$LGreen You are as root going to Install a New Arch Limux into a partotion. $LRed The data on this partition will be lost !!!$Reset$Nline"
	
	echo  "$LGreen If you have prepared a $LRed partition to format$LGreen you can continue $Reset$Nline"
	
	echo -n "$LGreen Give full Device name to $LRed Install Arch Linux or Enter for skip : "; read install_partition; echo "$Reset"
	
	if [[ "$install_partition" = "" ]]; then
		echo "$Nline	$Orange Ok. You tried, you failed but, at least, you tried and you might succeed next time around :).$Nline\
		You should prepare your hard drive for such spare partition.$Reset$Nline"
		echo  "$Nline$LCyan Tip - I have first partition '/dev/sda1' 15GB, only for play/testing distros$Reset"
		echo  "$Green But in fact I use as primary all (3) for differents systems include DOS \ and several extended logical partitions for swap my Linux and 'homes' - data$Reset$Nline"
		exit 1
		
	fi
	
	if ! [ -b "$install_partition" ]; then echo "$LRed "$install_partition"$Red is not a block device.$Reset$Nline"; exit 1; fi
	
}

make_file_system_type () {
	
	# Format and label filesystem on $install_partition
	
	fuser -k "$new_root_dir"
	umount -R "$new_root_dir"
	
	echo "$Nline$LRed Make $file_system_type on $install_partition - mkfs -t "$file_system_type" "$install_partition" $Reset$Nline"
	mkfs -t "$file_system_type" "$install_partition"
	
	if ! [ $? = 0 ]; then echo "exit"; exit 1; fi
	label_install_partition=$(blkid "$install_partition" -o value -s LABEL)
	
	if [[ "" = "$label_install_partition" ]]; then
		file_system_type=$(blkid "$install_partition" -o value -s TYPE)
		
		if [ "$file_system_type" = "ext2" ] || [ "$file_system_type" = "ext3" ] || [ "$file_system_type" = "ext4" ]; then
			echo "$Nline$Green LABEL = tune2fs -L "$host_name" "$install_partition"$Reset$Nline"
			tune2fs -L "$host_name" "$install_partition"
		fi
	fi
}

get_it () {

	# Build download command, mirror and path
	local mirror= mirrors="$1" file="$2"
	shift
	for try in 1 2 3 4 5 6 7 8 9
	do :
		echo "$Red try nr. $try$Reset$Nline"
		for mirror in $mirrors
		do :
			_get_command "$mirror$file" && return 0
		done
	done
	return 1

}

get_size_file_to_download () {

	local mirror= mirrors="$1" file="$2"
	shift
	for try in 1 2 3 4 5
	do :
		for mirror in $mirrors
		do :
			_chk_command "$mirror$file" && return 0
		done
	done
	return 1

}

download_bootstrap() {
	
	# Download latest bootstrap
	echo "$Nline$Green cd "$TMPDIR" $Reset"
	cd "$TMPDIR"
	rm -f "sha1sums.txt"
	
	echo "$Nline$Green Download ${mirrors}sha1sums.txt =$Reset$Nline"
	get_it "$mirrors" "sha1sums.txt"
	
	if ! [ $? = 0 ]
	then :
		echo "$Nline$Green cp -f "${arch_backup}/sha1sums.txt" "$TMPDIR"/ $Reset"
		cp -f "${arch_backup}/sha1sums.txt" "$TMPDIR"/
		
		sha1sumstxt=$(cat "sha1sums.txt" | grep "$cpu_type.tar.gz")
		[[ -z "$sha1sumstxt" ]] && exit || echo "$sha1sumstxt" > "sha1sums.txt"
		
		read -r sha1sums file_name_x < "sha1sums.txt"
		
		echo "$Nline$Green cp -f "${arch_backup}/$file_name_x" "$TMPDIR"/ $Reset"
		cp -f "${arch_backup}/$file_name_x" "$TMPDIR"/
		
		sha1sum -c "sha1sums.txt" || exit 1
	else :
		
		sha1sumstxt=$(cat "sha1sums.txt" | grep "$cpu_type.tar.gz")
		[[ -z "$sha1sumstxt" ]] && exit || echo "$sha1sumstxt" > "sha1sums.txt"
		read -r sha1sums file_name_x < "sha1sums.txt"
		echo "$Nline$Green cp -f "${arch_backup}/$file_name_x" "$TMPDIR"/ $Reset"
		cp -f "${arch_backup}/$file_name_x" "$TMPDIR"/
		
		sha1sum -c "sha1sums.txt"
		if ! [ $? = 0 ]; then
			echo "$Nline$Green Download $mirrors$file_name_x =$Reset$Nline"
			rm -f "$file_name_x"
			get_it "$mirrors" "$file_name_x"
			sha1sum -c "sha1sums.txt" || exit 1
			cp -f ${TMPDIR}/${file_name_x} ${arch_backup}/
			cp -f ${TMPDIR}/"sha1sums.txt" ${arch_backup}/
		fi
		
	fi
	
}

mount_destination () {
	
	# Nomunt $install_partition on $new_root_dir
	mkdir -p "$new_root_dir"
	if ! [ $? = 0 ]; then echo "$LRed Erorr: Cannot create folder "$new_root_dir""; exit 1; fi
	echo "$Nline$LRed Mount $install_partition on $new_root_dir :$Reset$Nline"
	mount "$install_partition" "$new_root_dir"
	# Sukcess continue
	if ! [ $? = 0 ]; then echo "$LRed Erorr: Cannot mount folder "$install_partition" on "$new_root_dir""; exit 1; fi
}

extract_bootstrap () {
	
	# Extract bootstrap
	
	echo "$LGreen  Extract bootstrap - tar -xpzf "$filename" -C "$new_root_dir" --strip-components 1 :$Reset$Nline"
	tar -xpzf "$filename" -C "$new_root_dir" --strip-components 1 >/dev/null 2>&1
	if ! [ $? = 0 ]; then echo "$LRed Erorr: Cannot extract bootstrap "$new_root_dir""; exit 1; fi
	
	backup=$(echo $backup | tr '[A-Z]' '[a-z]')
	if [[ "$backup" = "yes" ]] || [[ "$backup" = "y" ]]; then
		mkdir -p "$arch_backup"
		mv -u "sha1sums.txt" "$arch_backup/"
		mv -u "$filename" "$arch_backup/"
	fi
	
	rm -f "$filename"
	rm -f "sha1sums.txt"
	
	echo;cat "$new_root_dir/README"
}

mount_new_root () {
	
	# Mount options taked from arch-chroot script
	
	mount -t proc proc -o nosuid,noexec,nodev "$new_root_dir/proc"
	mount -t sysfs sys -o nosuid,noexec,nodev,ro "$new_root_dir/sys"
	mount -t devtmpfs -o mode=0755,nosuid udev "$new_root_dir/dev"
	mkdir -p "$new_root_dir/dev/pts" "$new_root_dir/dev/shm"
	mount -t devpts -o mode=0620,gid=5,nosuid,noexec devpts "$new_root_dir/dev/pts"
	mount -t tmpfs -o mode=1777,nosuid,nodev shm "$new_root_dir/dev/shm"
	mount -t tmpfs -o nosuid,nodev,mode=0755 run "$new_root_dir/run"
	mount -t tmpfs -o mode=1777,strictatime,nodev,nosuid tmp "$new_root_dir/tmp"
	# Workaround for Debian
	mkdir -p "$new_root_dir/run/shm"
}

configure_bootstrap() {
	
	# Set the /etc/hostname:
	echo "$Nline$Green "$new_root_dir/etc/hostname" =$Reset$Nline"
	echo "$host_name" > "$new_root_dir/etc/hostname"
	cat "$new_root_dir/etc/hostname"
	#$editor "$new_root_dir/etc/hostname" >/dev/null 2>&1
	
	# Set the time zone /etc/localtime:
	echo "$Nline$Green "$new_root_dir/etc/localtime" =$Reset$Nline"
	ln -s "/usr/share/zoneinfo/$localtime" "$new_root_dir/etc/localtime"
	ls -l "$new_root_dir/etc/localtime"
	
	# Set the time hwclock --systohc --utc:
	echo "$Nline$Green hwclock --systohc --utc :$Reset$Nline"
	chroot_exec "hwclock --systohc --utc"
	
	# Set the /etc/vconsole.conf:
	echo "$Nline$Green "$new_root_dir/etc/vconsole.conf" =$Reset$Nline"
	echo "$vconsole_conf" > "$new_root_dir/etc/vconsole.conf"
	cat "$new_root_dir/etc/vconsole.conf"
	#$editor "$new_root_dir/etc/vconsole.conf" >/dev/null 2>&1
	
	# Set the /etc/locale.conf:
	echo "$Nline$Green "$new_root_dir/etc/locale.conf" =$Reset$Nline"
	echo "$locale_conf" > "$new_root_dir/etc/locale.conf"
	cat "$new_root_dir/etc/locale.conf"
	#$editor "$new_root_dir/etc/locale.conf" >/dev/null 2>&1
	
	# Set the /etc/locale.gen:
	echo "$Nline$Green "$new_root_dir/etc/locale.gen" =$Reset$Nline"
	sed -i.org "s/^#$locale_gen  /$locale_gen  /" "$new_root_dir/etc/locale.gen"
	cat "$new_root_dir/etc/locale.gen"|grep "$locale_gen"
	
	# Copy the /etc/resolv.conf: # https://wiki.archlinux.org/index.php/resolv.conf
	echo "$Nline$Green Copy the resolv.conf - cp -L /etc/resolv.conf "$new_root_dir/etc/" :$Reset$Nline"
	cp -v -L /etc/resolv.conf "$new_root_dir/etc/"
	cat "$new_root_dir/etc/resolv.conf"
	#$editor "$new_root_dir/etc/resolv.conf" >/dev/null 2>&1
	
	# Generate /etc/fstab: https://wiki.archlinux.org/index.php/fstab
	echo "$Nline$Green Set the genfstab "$new_root_dir/etc/fstab" :$Reset$Nline"
	chroot_exec "genfstab -L / > /etc/fstab"
	
	cat "$new_root_dir/etc/fstab"
	#$editor "$new_root_dir/etc/fstab" >/dev/null 2>&1
}

init_pacman() {
	
	# Set the pacman.conf:- uncomment /etc/pacman.d/mirrorlist
	echo "$Nline$Green uncomment  /etc/pacman.d/mirrorlist "$new_root_dir/etc/pacman.d/mirrorlist" :$Reset$Nline"
	sed -i.org 's/^#Server =/Server =/' "$new_root_dir/etc/pacman.d/mirrorlist"
	
	# Set up the pacman keyring
	echo "$Nline$Green pacman-key --init && pacman-key --populate archlinux :$Reset$Nline"
	echo "$Nline$Green$Blink This may take a while :$Reset$Nline"
	chroot_exec "pacman-key --init && pacman-key --populate archlinux"
	
	
	#  Restore backup pacman download packages
	if [[ $(ls -A "$arch_backup/var/cache/pacman/pkg/") ]]; then
	mkdir -p "$new_root_dir/var/cache/pacman"
	mkdir -p "$new_root_dir/var/lib/pacman/sync"
	echo "$Nline$Green Restore backup of pacman download packages - cp -fax "$arch_backup/var/cache/pacman" "$new_root_dir/var/cache/"$Nline$Yellow Wait a while:$Blink ... : $Reset$Nline"
	cp -fax "$arch_backup/var/cache/pacman" "$new_root_dir/var/cache/"
	echo "$Nline$Green Restore backup of pacman download packages - cp -fax "$arch_backup/var/lib/pacman/sync" "$new_root_dir/var/lib/pacman/" :$Reset$Nline"
	cp -fax "$arch_backup/var/lib/pacman/sync" "$new_root_dir/var/lib/pacman/"
	echo "$Nline$Green Restore backup of grub and download theme packages - cp -fax "$arch_backup/boot" "$new_root_dir/" :$Reset$Nline"
	cp -fax "$arch_backup/boot" "$new_root_dir/"
	fi
	
	# Synchronize and update database packages ; sed for locale-gen  (missing in bootstrap)
	echo "$Nline$Green Synchronize and update database packages - pacman --color auto --needed --noconfirm -Suy : $Cyan sed awk gzip grep :$Reset$Nline"
	chroot_exec "pacman --color auto --noconfirm -Suy 2>/dev/null"
	
	echo "$Nline$Green cp -vfax "$new_root_dir/etc/pacman.d/mirrorlist.pacnew" "$new_root_dir/etc/pacman.d/mirrorlist" :$Reset$Nline"
	cp -vfax "$new_root_dir/etc/pacman.d/mirrorlist.pacnew" "$new_root_dir/etc/pacman.d/mirrorlist"
	sed -i.org 's/^#Server =/Server =/' "$new_root_dir/etc/pacman.d/mirrorlist"
	chroot_exec "pacman --color auto --noconfirm -S sed awk gzip grep"
	
	# Generate locale-gen:
	echo "$Nline$Green Generate locale-gen :$Reset$Nline"
	chroot_exec "locale-gen"
	
	# Rankmirrors to Set the Fastest Download Server
	echo "$Nline$Green Rankmirrors to Set the Fastest Download Server - pacman --color auto --needed --noconfirm -S : $Cyan reflector :$Reset$Nline"
	
	chroot_exec "pacman --color auto --needed --noconfirm -S reflector"
	
	echo "$Nline$Green reflector --verbose --country "$country" -l 7 --sort rate --save /etc/pacman.d/mirrorlist :$Reset$Nline"
	
	chroot_exec "reflector --verbose --country "$country" -l 7 --sort rate --save /etc/pacman.d/mirrorlist"
	chroot_exec "pacman --color auto -Syu 2>/dev/null"
	
	echo "$Nline$Green pacman-optimize :$Reset$Nline"
	
	chroot_exec "pacman-optimize"
}

install_base_packages () {
	
	# Install base packages
	
	echo "$Nline$Green Install base packages - pacman --color auto --needed --noconfirm -Su --force : $Cyan"$base_packages" :$Reset$Nline"
	
	chroot_exec "pacman --color auto --needed --noconfirm -Su --force "$base_packages""
	
	# Sukcess continue
	if ! [ $? = 0 ]; then echo "$Nline$Red$Blink try agen$Nline$Reset";umount_new_root;exit 1;fi
	
	# Add "consolefont" to HOOKS in /etc/mkinitcpio.conf
	consolefont=$(cat "$new_root_dir/etc/mkinitcpio.conf"|grep ^HOOKS|grep consolefont)
	if [[ $consolefont = "" ]]; then sed -i.org "s/ keyboard / consolefont keyboard /" "$new_root_dir/etc/mkinitcpio.conf"; fi
}

install_desktop_environment () {
	
	# X Window System
	echo "$Nline$Green Install X Window System - pacman --color auto --needed --noconfirm -Su --force : $Cyan"$x_window_system" :$Reset$Nline"
	chroot_exec "pacman --color auto --needed --noconfirm -Su --force ${x_window_system}"
	
	# Desktop environment
	if [[ "kde" = "$desktop_environment" ]]; then
	echo "$Nline$Green Install Desktop environment - pacman --color auto --needed --noconfirm -Su --force : $Cyan"$kde_base" :$Reset$Nline"
	chroot_exec "pacman --color auto --needed --noconfirm -Su --force "$kde_base""

	# Desktop langłage environment
	echo "$Nline$Green Install Desktop environment - pacman --color auto --needed --noconfirm -Su --force : $Cyan"$desktop_environment_language" :$Reset$Nline"
	chroot_exec "pacman --color auto --needed --noconfirm -Su --force "$desktop_environment_language""
	
	fi
	
	# Write /etc/X11/xorg.conf.d/00-keyboard.con
	echo "$Nline$Green Write set-x11-keymap $set_x11_keymap :$Reset$Nline"
	cat <<-EOF > "$new_root_dir/etc/X11/xorg.conf.d/00-keyboard.conf"
	# Read and parsed by systemd-localed. It's probably wise not to edit this file
	# manually too freely.
	Section "InputClass"
		Identifier "system-keyboard"
		MatchIsKeyboard "on"
		Option "XkbLayout" "$set_x11_keymap"
	EndSection
	
	EOF
	
	# Display login manager
	echo "$Nline$Green Install Display login manager - pacman --color auto --needed --noconfirm -Su --force : $Cyan"$login_manager" :$Reset$Nline"
	chroot_exec "pacman --color auto --needed --noconfirm -Su --force "$login_manager""
	
	echo "$Nline$Green systemctl enable "$login_service":$Reset$Nline"
	chroot_exec "systemctl enable "$login_service""
	
	#echo "$Nline$Green cat $new_root_dir/etc/sysconfig/i18n :$Reset$Nline"
	#cat "$new_root_dir/etc/sysconfig/i18n"
	
	# pacman -S gnome gnome-extra
	# systemctl enable gdm.service
	
	# Cinnamon:
	# pacman -S cinnamon cinnamon-control-center cinnamon-screensaver nemo
	
	# pacman -S enlightenment17 entrance
	# systemctl enable entrance
}

install_network () {
	
	echo "$Nline$Green Configure network - pacman --color auto --needed --noconfirm -Su : $Cyan"$network" :$Reset$Nline"
	chroot_exec "pacman --color auto --needed --noconfirm -Su "$network""
	
	echo "$Nline$Green Configure network systemctl enable $network_service :$Reset$Nline"
	chroot_exec "systemctl enable "$network_service""
}

install_additional_packages () {
	
	
	echo "$Nline$Green Install additional packages - pacman --color auto --needed --noconfirm -Su : $Cyan"$additional_packages" :$Reset$Nline"
	chroot_exec pacman --color auto --needed --noconfirm -Su "$additional_packages"
	
	echo "$Nline$Green Install additional repositories to /etc/pacman.conf :$Reset$Nline"
	
	grep -F "[archlinuxfr]" "$new_root_dir"/etc/pacman.conf
	
	if ! [ $? = 0 ]; then
		echo "$Nline$Orange Add Server :$Nline$additional_repositories to /etc/pacman.conf $Reset$Nline"
		echo "$additional_repositories" >> "$new_root_dir/etc/pacman.conf"
	else
		echo "$Nline$Orange Server = http://repo.archlinux.fr/$cpu_type is in /etc/pacman.conf $Reset$Nline"
	fi
	
	echo "$Nline$Green Install extra packages - pacman --color auto --needed --noconfirm -Suy --force : $Cyan"$extra_packages" :$Reset$Nline"
	
	chroot_exec "pacman --color auto --noconfirm -Suy 2>/dev/null"
	chroot_exec "pacman --color auto --needed --noconfirm -Su --force "$extra_packages""
	
	# Start additional services
	
	echo "$Nline$Green Start additional services - systemctl enable $additional_systemctl_start_services :$Reset$Nline"
	
	chroot_exec "systemctl enable "$additional_systemctl_start_services""
	
}

additional_firmware_packages () {
	
	# Advanced Linux Sound Architecture
	
	echo "$Nline$Orange Firmware for Linux Sound Architecture - pacman --color auto --needed --noconfirm -Su --force : $Cyan"$linux_sound_architecture" :$Reset$Nline"
	
	chroot_exec "pacman --color auto --needed --noconfirm -Su --force "$linux_sound_architecture""
	
	
	echo "$Green$Nline"
	cat <<-EOF
		# For GeForce 400 series cards and newer [NVCx and newer], install the nvidia or nvidia-lts package along with nvidia-libgl.
		# For GeForce 8000/9000, ION and 100-300 series cards [NV5x, NV8x, NV9x and NVAx] from around 2006-2010, install the nvidia-340xx or nvidia-340xx-lts package along with nvidia-340xx-libgl.
		# For GeForce 6000/7000 series cards [NV4x and NV6x] from around 2004-2006, install the nvidia-304xx or nvidia-304xx-lts package along with nvidia-304xx-libgl.
		# If you are on 64-bit and also need 32-bit OpenGL support, you must also install the equivalent lib32 package from the multilib repository (e.g. lib32-nvidia-libgl, lib32-nvidia-340xx-libgl or lib32-nvidia-304xx-libgl).
		# https://wiki.archlinux.org/index.php/NVIDIA
		
		ran /etc/pacman.d/hooks/nvidia.hook
	EOF
	echo "$Reset$Nline"
	
	echo "$Nline$Orange Firmware for GeForce series cards - nvidia-xx  (download only): $Cyan"$firmware_nvidia_cards" :$Reset$Nline"
	
	chroot_exec "pacman --color auto --needed --noconfirm -Suw --force "$firmware_nvidia_cards""
	
	echo "$Nline$Orange pacman -Rdds nvidia<xxx> nvidia<xxx>-libgl # To remove$Reset$Nline"
}

create_initial_ramdisk () {
	
	# create an initial ramdisk environment
	# https://wiki.archlinux.org/index.php/mkinitcpio
	echo "$Nline$Green mkinitcpio -p linux :$Reset$Nline"
	chroot_exec "mkinitcpio -p linux"
}

make_backup_of_pckages () {
	
	
	# Saving a backup of pacman download packages for future installations
	
	backup=$(echo $backup | tr '[A-Z]' '[a-z]')
	if [[ $backup = "yes" ]] || [[ $backup = "y" ]]; then
	
	# Make backup
		
		if [[ $(ls -A "$new_root_dir"/var/cache/pacman/pkg/) ]]; then
			mkdir -p "$arch_backup/var/cache"
			mkdir -p "$arch_backup/var/lib/pacman"
			mkdir -p "$arch_backup/boot/grub/themes"
			rm -rf "$arch_backup/var/cache/pacman"
			rm -rf "$arch_backup/var/lib/pacman/sync"
			
			echo "$Nline$Green chroot_exec paccache -rvk1 :$Reset$Nline"
			chroot_exec "paccache -rvk1"
			
			echo "$Nline$Green Saving a backup of pacman download packages for future installations $Nline- cp -fax "$new_root_dir/var/cache/pacman" to "$arch_backup/var/cache/pacman"$Nline$Yellow Wait a while:$Blink ... : $Reset$Nline"
			cp -fax "$new_root_dir/var/cache/pacman" "$arch_backup/var/cache/"
			echo "$Nline$Green Saving a backup of pacman download packages for future installations $Nline- cp -fax "$new_root_dir/var/lib/pacman/sync" "$arch_backup/var/lib/" : $Reset$Nline"
			cp -fax "$new_root_dir/var/lib/pacman/sync" "$arch_backup/var/lib/pacman/"
			echo "$Nline$Green Saving a backup of grub themes download packages for future installations $Nline- cp -fax "$new_root_dir/boot/grub/themes/$grub_theme_package" "$arch_backup/boot/grub/themes/" : $Reset$Nline"
			cp -fax "$new_root_dir/boot/grub/themes/$grub_theme_package" "$arch_backup/boot/grub/themes/"
		fi
	fi
}

configure_bootloader () {
	
	
	
	if [ "$boot_loader" = "grub_2" ]; then
	
	echo "$Reset$Nline"
		# Get theme from url...
		mkdir -p "$new_root_dir/boot/grub/themes"
		echo "$Nline$Green wget -c -O "$grub_theme_package" $Cyan"$grub_theme_package_url" : $Reset$Nline"
		wget  -c -O "$new_root_dir/boot/grub/themes/$grub_theme_package" "$grub_theme_package_url"
		if ! [ $? = 0 ]; then
			echo "$Nline$Green cp -fax "$arch_backup/boot/grub/themes/$grub_theme_package" "$new_root_dir/boot/grub/themes/$grub_theme_package" :$Reset$Nline"
			cp -fax "$arch_backup/boot/grub/themes/$grub_theme_package" "$new_root_dir/boot/grub/themes/$grub_theme_package"
		fi
		echo "$Nline$Green tar xfz "$new_root_dir/boot/grub/themes/$grub_theme_package" -C "$new_root_dir/boot/grub/themes/" --strip-components 1 :$Reset$Nline"
		tar xfz "$new_root_dir/boot/grub/themes/$grub_theme_package" -C "$new_root_dir/boot/grub/themes/" --strip-components 1
		if [ $? = 0 ]; then
		i=$(sed -n "s|^#\?GRUB_THEME=|&|p" "$mount_di/etc/default/grub")
		if [[ -z $i ]]; then
			echo "$Nline$Green echo -e "GRUB_THEME=/boot/grub/themes/$grub_theme_name/theme.txt" >>"$new_root_dir/etc/default/grub" :$Reset$Nline"
			echo -e "\n# Uncomment and set to the desired gfxtheme" >>"$new_root_dir/etc/default/grub"
			echo -e "GRUB_THEME=/boot/grub/themes/$grub_theme_name/theme.txt" >>"$new_root_dir/etc/default/grub"
		else
			echo "$Nline$Green sed -i.org -e "'s|^#\?GRUB_THEME=.*|'GRUB_THEME=/boot/grub/themes/$grub_theme_name/theme.txt\|" "$new_root_dir/etc/default/grub" :$Reset$Nline"
			sed -i.org -e "s|^#\?GRUB_THEME=.*|GRUB_THEME=/boot/grub/themes/$grub_theme_name/theme.txt|" "$new_root_dir/etc/default/grub"
		fi
		fi
	
	# Install Grub into mbr
	if [ "$install_grub_mbr" = "ask" ]; then
	
	command=$(whereis -b lsscsi|awk '{print $2}')
	if [[ -f $command ]]
	then
	options=$(lsscsi -is | gawk -F' /' '{ print "/"$NF";" }'|tr -d '\n')
	IFS=";" options=($options)
	else
	options=$(ls /sys/block | gawk '{ print "/dev/"$NF" " }'|tr -d '\n')
	options=($options)
	fi
	
	keys=("a""b""c""d") default=$(( ${#options[@]}+1))
	ask_info="$Nline$Green Instal Grub in$LRed MBR ,..$Orange Test beta script$Green # by Leszek Ostachowski (C2016) GPL V2$Reset"

	ask_select
	install_grub_mbr=${Selected%% *}
	echo "$Nline Akcepted: $install_grub_mbr"
	fi
	
	if ! [ -b "$install_grub_mbr" ]; then
	echo "$LRed "$install_grub_mbr"$Red is not a block device skipped.$Reset$Nline"
	else
	echo "$Nline$Green "chroot grub-mkconfig -o /boot/grub/grub.cfg" :$Reset$Nline"
	chroot_exec "grub-mkconfig -o /boot/grub/grub.cfg"
	echo "$Nline$Green "chroot_exec "grub-install --recheck $install_grub_mbr :$Reset$Nline"
	chroot_exec "grub-install --recheck $install_grub_mbr"
	
	fi
	
	# Install Grub into parition
	echo "$Reset$Nline"
	if [[ "no" == $(r_ask "$Orange install Grub into parition - grub-mkconfig and grub-install --recheck --force$Green "$install_partition".$Orange Please answer or Enter for skip$Red") ]]; then
		echo "$Nline$Orange Skipped ...$Reset$Nline"
	else
		
		echo "$Nline$Green "chroot grub-mkconfig -o /boot/grub/grub.cfg" :$Reset$Nline"
		chroot_exec "grub-mkconfig -o /boot/grub/grub.cfg"
		echo "$Nline$Orange "chroot grub-install --recheck --force "$install_partition"":$Reset$Nline"
		chroot_exec "grub-install --recheck --force "$install_partition""
		echo -n "$Reset"
	fi
	
	elif [ "$boot_loader" = "syslinux" ]; then
		echo "$Nline$Green syslinux-install_update -ami :$Reset$Nline"
		syslinux-install_update -ami
	fi
	
	# pacman -S grub
	# pacman -S grub-bios
	# pacman -S os-prober
	# grub-install --target=i386-pc --recheck /dev/sda
	# grub-mkconfig -o /boot/grub/grub.cfg
	# Żeby zapobiec (nieszkodliwej) informacji o błędzie podczas uruchamiania:
	# cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
	
	# pacman -S syslinux
	# syslinux-install_update -i -a -m
	# nano /boot/syslinux/syslinux.cfg
}

add_to_grub() {

	echo "$host_name" > "$new_root_dir/$host_name"
	
	# add to old Grub "/boot/grub/menu.lst"
	command=$(whereis -b grub|awk '{print $2}')
	if [[ -f $command ]]
	then
		grub_root_dev=$(echo "find /$host_name"|grub|grep "(hd"| head -1)
		
		# Grub 1 "/boot/grub/menu.lst"
		grub_menu_lst=$( cat <<-EOF
		
		title $host_name Boot loader on $grub_root_dev
			rootnoverify $grub_root_dev
			chainloader +1
			
		EOF
		)
		
		
		echo "$Reset$Nline"
		echo "$Nlineline$Red Add below lines to /boot/grub/menu.lst : $Nline$Cyan $grub_menu_lst $Reset$Nline"
		if [[ "no" == $(r_ask "$Green Add abowe lines to /boot/grub/menu.lst ?$Orange Please answer$LRed") ]]; then
		echo "$Nlineline$Orange Skipped.$Reset$Nline"
		else
		echo "$grub_menu_lst" >> "/boot/grub/menu.lst"
		echo "$Nlineline$Orange ok add $Reset$Nline"
		fi
	fi
	
	# add to new Grub "/etc/grub.d/40_custom"
	command1=$(whereis -b grub-mkconfig|awk '{print $2}')
	command2=$(whereis -b grub2-mkconfig|awk '{print $2}')
	
	if [[ -f $command1 ]] || [[ -f $command2 ]] ;then
	
	# Grub 2 "/etc/grub.d/40_custom"
	grub_40_custom=$( cat <<-EOF
	
	menuentry "$host_name Boot loader on root = search --file /$host_name" --class arch {
	search --file --no-floppy --set=root /$host_name
	chainloader +1
	
	}
	
	EOF
	)
	
	echo "$Nlineline$Red Add below lines to /etc/grub.d/40_custom : $Nline$Cyan $grub_40_custom $Reset$Nline"
		if [[ "no" == $(r_ask "$Green Add abowe lines to /etc/grub.d/40_custom and grub-mkconfig -o /boot/grub/grub.cfg ?$Orange Please answer$LRed") ]]; then
			echo "$Nlineline$Orange Skipped.$Reset$Nline"
		else
		echo "$grub_40_custom" >> "/etc/grub.d/40_custom"
		echo "$Nlineline$Orange ok add $Reset$Nline"
		
		if [[ -f $command1 ]] ;then
			grub-mkconfig -o /boot/grub/grub.cfg
		elif [[ -f $command2 ]] ;then
			grub2-mkconfig -o /boot/grub2/grub.cfg
		fi
		fi
	fi

}

ask_passwd () {
	
	# Build sudoers_file
	
	echo "$Nline$Green Create grouo sudo - groupadd sudo :$Reset$Nline"
	chroot_exec "groupadd sudo"
	cp -fax "$new_root_dir/etc/sudoers" "$new_root_dir/etc/sudoers.org"
	echo "$Nline$Green \$sudoers_file > "$new_root_dir/etc/sudoers" :$Reset$Nline"
	echo "$sudoers_file" > "$new_root_dir/etc/sudoers"
	chmod 0440 "$new_root_dir/etc/sudoers"
	
	echo "$Nline$Green useradd -m -g users -G audio,games,lp,optical,power,scanner,storage,video,wheel,sudo -s /bin/bash $user_login :$Reset$Nline"
	chroot_exec "useradd -m -g users -G audio,games,lp,optical,power,scanner,storage,video,wheel,sudo -s /bin/bash "$user_login""
	
	echo "$Nline$Green Give passwd for $user_login :$Reset$Nline"
	chroot_exec "passwd "$user_login""
	
	# write kde dolphin and kate config
	mkdir -p "$new_root_dir/home/$user_login/.config"
	
	echo "$dolphinrc" > "$new_root_dir/home/$user_login/.config/dolphinrc"
	echo "$katepartrc" > "$new_root_dir/home/$user_login/.config/katepartrc"
	echo "$kateschemarc" > "$new_root_dir/home/$user_login/.config/kateschemarc"
	echo "$kwinrc" > "$new_root_dir/home/$user_login/.config/kwinrc"
	echo "$plasmarc" > "$new_root_dir/home/$user_login/.config/plasmarc"
	echo "$kdeglobals" > "$new_root_dir/home/$user_login/.config/kdeglobals"
	echo "$plasma_org" > "$new_root_dir/home/$user_login/.config/plasma-org.kde.plasma.desktop-appletsrc"
	
	chroot_exec "chown -R "$user_login:users" "/home/$user_login/.config""
	
	echo "$Nline$Green Give passwd for root :$Reset$Nline"
	chroot_exec "passwd"
}

end_message () {
	
	# Write some informations to $user_login home folder
	echo "$info_for_user" > "$new_root_dir/home/$user_login/Packages_Installations.txt"
	chmod 666 "$new_root_dir/home/$user_login/Packages_Installations.txt" # write by anybody
	
	echo "$Powiedz_wiersz_lokomotywa" > "$new_root_dir/home/$user_login/Powiedz wiersz lokomotywa.sh"
	chmod 777 "$new_root_dir/home/$user_login/Powiedz wiersz lokomotywa.sh"
	
	echo -n "$Green$Nline"
	
	cat <<-EOF
		
		Hi,
		You has successfully install Arch Linux.
		Please see https://wiki.archlinux.org/index.php/Beginners
		If you'll need to configure your mirrors, please see https://wiki.archlinux.org/index.php/Mirrors
		
		Windows is a battleground for viruses.
		Linux is an endless construction site, and
		if you have a only one Linux, this means only that you have one too few :)
		
		$Nline$Orange$Nline
		grub-install --recheck <device>		# To install Grub in MBR on ( /dev/sda ; /dev/sdb...)
		or grub2-install --recheck <device>	# To install Grub in MBR on ( /dev/sda ; /dev/sdb...)
		
		grub-mkconfig -o /boot/grub/grub.cfg			# to configure
		or grub2-mkconfig -o /boot/grub2/grub.cfg		# to configure
		
		$Reset$Nline
	EOF
	echo -n "$Reset"
}

umount_new_root() {
	
	# Umount options taked from arch-chroot script and
	
	echo -n "$LGreen Enter for umount $install_partition , or [*] for skip umonut and enter in chroot :"; read x
	if [[ "$x" = "" ]];then
		
		echo "$Nline$Green umount $install_partition =$Reset$Nline"
		fuser -k "$new_root_dir"
		umount -R "$new_root_dir"
	# If the partition is "busy", you can find the cause with fuser. Reboot the computer
	
	DATA[0]='              +                                    _     _ _                   '
	DATA[1]='              #                      __ _ _ __ ___| |__ | (_)_ __  _   ___  __ '
	DATA[2]='             ###                    / _` | `__/ __| `_ \| | | `_ \| | | \ \/ / '
	DATA[3]='            #####                  | (_| | | | (__| | | | | | | | | |_| |>  <  '
	DATA[4]='           #######                  \__,_|_|  \___|_| |_|_|_|_| |_|\__,_/_/\_\ '
	DATA[5]='          ;#######;            '
	DATA[6]='          +##.#####            '
	DATA[7]='         +##########           '
	DATA[8]='        #############;         '
	DATA[9]='       ###############+        '
	DATA[10]='      #######   #######       '
	DATA[11]='    .######;     ;###;`".     '
	DATA[12]='   .#######;     ;#####.      '
	DATA[13]='   #########.   .########`    '
	DATA[14]='  ######"           "######   '
	DATA[15]=' ;####                 ####;  '
	DATA[16]=' ##"                     "##      A simple, elegant gnu/linux distribution. '
	DATA[17]='#"                         "#  Ctrl+c'
	# virtual coordinate system is X*Y ${#DATA} * 5
	
	REAL_OFFSET_X=0
	REAL_OFFSET_Y=0
	
	draw_char() {
	  V_COORD_X=$1
	  V_COORD_Y=$2
	
	  tput cup $((REAL_OFFSET_Y + V_COORD_Y)) $((REAL_OFFSET_X + V_COORD_X))
	
	  printf %c ${DATA[V_COORD_Y]:V_COORD_X:1}
	}
	
	
	trap 'exit 1' INT TERM
	trap 'tput setaf 9; tput cvvis; clear' EXIT
	
	tput civis
	clear
	
	for ((q=10; q >= 0; q--)); do
	echo $q
	for ((c=1; c <= 7; c++)); do
	  tput setaf $c
	  for ((x=0; x<${#DATA[0]}; x++)); do
	    for ((y=0; y<=17; y++)); do
	      draw_char $x $y
	    done
	  done
	done
	
	done
	# http://wiki.bash-hackers.org/scripting/terminalcodes
	
	else
		echo "$Nline$Green chroot $new_root_dir $Nline"
		chroot "$new_root_dir" /usr/bin/env -i HOME=/root TERM=$TERM /bin/bash -i
		
	fi
	
}

##################
get_data_for_user() {

# Data for user account
##################

info_for_user=$(cat <<-EOF


# Type in konsloe or copy paste

nmtui		# To configure wifi in konsole
wifi-menu -o 	# or

#----------------------------------------------#

# If your old system is missing in grub menu:
sudo grub-mkconfig -o /boot/grub/grub.cfg

# To install Grub in MBR on ( /dev/sda ; /dev/sdb...)

sudo grub-install --recheck <device>

# Install Grub into parition ( /dev/sda1 ; /dev/sdb3...)

sudo grub-install --recheck --force <device>

# To update configure:

sudo grub-mkconfig -o /boot/grub/grub.cfg

# or

sudo update-grub

# Example Grub 2 menu entry for boot MS DOS on /dev/sda3

# Grub 2 start count partitions from 1 not from 0

# --class determine icon for menuentry from theme

	menuentry "MS DOS (on /dev/sda3)" --class windows {
		insmod part_msdos
		insmod ntfs
		set root='hd0,msdos3'
		chainloader +1

	# drivemap -s (hd0) (hd1)  # This performs a "virtual" swap between your first and second hard drive
	# parttool (hd0,1) hidden- # This performs unset hiden flag for partiton
	# parttool (hd0,2) hidden+ # This performs set hiden flag for partiton
	# parttool \${root} boot+  # This performs set boot flag for partiton and clear otcher
	# boot
	}

#----------------------------------------------#

# stop baloofilerc indexing:

kwriteconfig --file baloofilerc --group 'Basic Settings' --key 'Indexing-Enabled' false

#----------------------------------------------#

# AUR helpers
xdg-open 'https://wiki.archlinux.org/index.php/Unofficial_user_repositories'
xdg-open 'https://wiki.archlinux.org/index.php/Yaourt_(Polski)'

# yaourt  package_name		 # To instal packages ftom AUR - octopi, fakepkg...

yaourt --noconfirm pkgbuilder	 # To compile and install pkgbuilder
pkgbuilder octopi-git		 # To compile and install octopi

yaourt --noconfirm apacman	 # To compile and install apacman

xdg-open 'https://wiki.archlinux.org/index.php/powerpill'

yaourt --noconfirm powerpill
powerpill -Syu package_name	 # To install

yaourt --noconfirm packer	 # To compile and install packer

# packer -Syu			 # To instal packages
# packer -S --noedit package_name

su -c "pacman -Syu supertux	 # To install supertux game
su -c "pacman -S playonlinux"	 # To install package playonlinux
su -c "pacman -S seamonkey"	 # To install package seamonkey

#----------------------------------------------#

# You can also define how many recent versions you want to keep in cache: paccache -rvk x

paccache -rvk 1

# For search package

pacsearch xxx

#----------------------------------------------#

# Force installation a package - get from internet and install:

xdg-open 'https://wiki.archlinux.org/index.php/Arch_Linux_Archive#.2Fpackages'

wget -O superkaramba-15.08.3-2-i686.pkg.tar.xz http://archive.archlinux.org/packages/k/kdeutils-superkaramba/kdeutils-superkaramba-15.08.3-2-i686.pkg.tar.xz
su -c "pacman -U superkaramba*"

# Install Easy Monitor for suprekaramba:
# Download latest package of Easy Monitor (.skz)

xdg-open 'https://www.trinity-look.org/p/1105311'

cd Downloads
mkdir -p EasyMonitor_install
cp *EasyMonitor.skz EasyMonitor_install/EasyMonitor.zip
cd EasyMonitor_install
unzip EasyMonitor.zip; rm -f EasyMonitor.zip
bash install_easy_monitor.sh

#----------------------------------------------#
#----------------------------------------------#

yaourt --noconfirm freetype2-infinality
sudo pacman -U /tmp/yaourt-tmp-\$USER/freetype2-infinality*

yaourt --noconfirm fontconfig-infinality
sudo pacman -U /tmp/yaourt-tmp-\$USER/fontconfig-infinality*

yaourt --noconfirm cairo-infinality-lcdfilter
sudo pacman -U /tmp/yaourt-tmp-\$USER/cairo-infinality-lcdfilter*

#----------------------------------------------#

install sddm editor:

yaourt --noconfirm sddm-config-editor

#----------------------------------------------#

Skins for qmmp player:

wget -O Skins_All_in_One.zip http://qmmp.ylsoftware.com/files/skins/Skins_All_in_One.zip
unzip Skins_All_in_One.zip
sudo mv Skins_All_in_One /usr/share/qmmp/skins

#----------------------------------------------#

To set the default global system locale for all users, type the following command as root:

sudo localectl set-locale LANG=pl_PL.UTF-8 or localectl set-locale LANG=en_US.UTF-8
sudo localectl set-keymap pl ; localectl list-keymaps
For Xorg: localectl set-x11-keymap pl

Launch application with different locale from terminal. Example:
env LANG=LANG=pl_PL.UTF-8 abiword &

Launch application with different locale from desktop. Example:
cp /usr/share/applications/abiword.desktop ~/.local/share/applications/
Edit the Exec command: kate ~/.local/share/applications/abiword.desktop
Exec=env LANG=LANG=pl_PL.UTF-8 abiword %U

Launch an X application with root privilages from konsole. Example:
su
export \$(dbus-launch) >/dev/null 2>&1
kate

#----------------------------------------------#

Openbox is a lightweight, powerful, and highly configurable stacking window manager

xdg-open 'https://wiki.archlinux.org/index.php/Openbox'
xdg-open 'https://wiki.archlinux.org/index.php/Openbox_(Polski)'

#----------------------------------------------#

xdg-open 'https://wiki.archlinux.org/index.php/pacman'

su -c "pacman -Ss '^nvidia-'"		 # To search packages ; su -c "command" - execute as root or sudo command

sudo pacman -Qs string1 string2.. 	 # To search for already installed packages
sudo pacman -Si package_name 		 # To display extensive information about a given package:

sudo pacman -Qii package_name 		 # Passing two -i flags will also display the list of backup files and their modification states:
sudo pacman -Ql package_name 		 # To retrieve a list of the files installed by a package:
sudo pacman -Qk package_name 		 # To verify the presence of the files installed by a package: Passing the k flag twice will perform a more thorough check.
suod pacman -Qo /path/to/file_name	 # One can also query the database to know which package a file in the file system belongs to:
sudo pacman -Qdt 			 # To list all packages no longer required as dependencies (orphans):
sudo pacman -Qet			 # To list all packages explicitly installed and not required as dependencies:
sudo pacman -Sc				 # To remove old packages from pacman cache
sudo pacman -Scc			 # To remove all packages from pacman cache

sudo pacman -Syu --noconfirm --needed --force <package>		# To install without asking
sudo pacman -Syuw --noconfirm --needed --force <package>	# To download only
sudo pacman -Rdds <package>					# To remove

# To see old and new versions of available packages, 
# uncomment the "VerbosePkgLists" line in /etc/pacman.conf. The output of pacman -Syu will be change:

#----------------------------------------------#

# GUI configuration tools:

yaourt --noconfirm grub-customizer

# Themes:

yaourt grub theme
yaourt --noconfirm grub2-theme-archxion

mkdir -p grub2-tuxkiller-themev2; cd grub2-tuxkiller-themev2
wget -O grub2-tuxkiller-themev2.zip http://gnome-look.org/CONTENT/content-files/169520-grub2-tuxkiller-themev2.zip
unzip grub2-tuxkiller-themev2.zip; rm -f grub2-tuxkiller-themev2.zip
sudo cp -fax Tuxkiller2 "/boot/grub/themes/"
cat readme.txt

grub-customizer

# and selct Tuxkiller2 theme

xdg-open 'https://wiki.archlinux.org/index.php/GRUB'

#----------------------------------------------#

# Apps, look themes, boot splasch themes,..

xdg-open 'https://www.opendesktop.org/'

http://kde-apps.org
http://kde-look.org
http://gnome-look.org
http://gtk-apps.org
http://qt-apps.org

yaourt --noconfirm qmplay2

# Linux news:

vlc https://www.youtube.com/watch?v=fxjElWL8igo
xdg-open 'https://DistroWatch.com'

#----------------------------------------------#

# For GeForce 400 series cards and newer [NVCx and newer], install the nvidia or nvidia package along with nvidia-libgl.

# Type command in konsole:

su -c "pacman -Su nvidia nvidia-libgl"

# For GeForce 8000/9000, ION and 100-300 series cards [NV5x, NV8x, NV9x and NVAx] from around 2006-2010, install the nvidia-340xx or nvidia-340xx-lts package along with nvidia-340xx-libgl.

su -c "pacman -Su nvidia-340xx nvidia-340xx-libgl"

# For GeForce 6000/7000 series cards [NV4x and NV6x] from around 2004-2006, install the nvidia-304xx or nvidia-304xx-lts package along with nvidia-304xx-libgl.

su -c "pacman -Su nvidia-304xx nvidia-304xx-libgl"

# To remove
su -c "pacman -Rdds nvidia<xxx> nvidia<xxx>-libgl"
su -c "pacman -Rdds '^nvidia'"

# If you are on 64-bit and also need 32-bit OpenGL support, you must also install the equivalent lib32 package from the multilib repository (e.g. lib32-nvidia-libgl, lib32-nvidia-340xx-libgl or lib32-nvidia-304xx-libgl).

https://wiki.archlinux.org/index.php/NVIDIA

#----------------------------------------------#

# Configure Plymouth Bootsplash

yaourt --noconfirm -S plymouth-git

# Add plymouth to the HOOKS array in mkinitcpio.conf. It must be added after base and udev for it to work, Exaple:
# file "/etc/mkinitcpio.conf" >> HOOKS="base udev plymouth [...] "

# Example: Add "plymouth" to HOOKS in /etc/mkinitcpio.conf

su -c 'Plymouth=\$(cat /etc/mkinitcpio.conf|grep ^HOOKS|grep plymouth); if [[ \$Plymouth = "" ]]; then sed -i.org "s|^HOOKS=\"base udev |HOOKS=\"base udev plymouth |" /etc/mkinitcpio.conf; fi'

# (it is posibile to put plymouth before udev, but may fail...?)


# For early KMS start (if you are using the open drivers) add the module radeon (for radeon cards), i915 (for intel cards) or nouveau (for open driver nvidia cards) to the MODULES line in /etc/mkinitcpio.conf, Exaple:
# file "/etc/mkinitcpio.conf >> MODULES="i915 [...]" or "radeon" or "nouveau"

# Example: Add "nouveau" to MODULES in /etc/mkinitcpio.conf

su -c 'Nouveau=\$(cat /etc/mkinitcpio.conf|grep ^MODULES|grep nouveau); if [[ \$Nouveau = "" ]]; then sed -i.org "s|^MODULES=\"|MODULES=\"nouveau |" /etc/mkinitcpio.conf; fi'

#----------------------------------------------#

# You now need to set "quiet splash" as your kernel command line parameter in your bootloader
# Permanently set quiet "quiet splash loglevel=3 rd.systemd.show_status=false rd.udev.log-priority=3"
# file "/etc/default/grub" >> GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=3 rd.systemd.show_status=false rd.udev.log-priority=3"

# Exaple:

su -c 'sed -i.org -e "s|^#\?GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash loglevel=3 rd.systemd.show_status=false rd.udev.log-priority=3\"|" /etc/default/grub'

# And Finaly:

plymouth-set-default-theme --list
sudo plymouth-set-default-theme <theme> -R # To set and make initrd
sudo mkinitcpio -p linux; sudo grub-mkconfig -o /boot/grub/grub.cfg

#######

sudo plymouth-set-default-theme --reset; sudo mkinitcpio -p linux # reset to default theme

#######

# Themes

# Downloading, untar package "Mageia-Cold-Fire.tar.gz"

mkdir plymouth-theme-Mageia-ColdFire
cd plymouth-theme-Mageia-ColdFire
wget -O Mageia-ColdFire.tar.gz http://kde-look.org/CONTENT/content-files/170783-Mageia-ColdFire.tar.gz
tar -xpzf Mageia-ColdFire.tar.gz
sudo cp -fr Mageia-ColdFire /usr/share/plymouth/themes/; sudo plymouth-set-default-theme Mageia-ColdFire -R

# Downloading, unpack package "plymouth-theme-photos-insects-0.2-1.noarch.rpm"
# http://rpm.pbone.net

mkdir plymouth-theme-photos-insects
cd plymouth-theme-photos-insects
wget -O plymouth-theme-photos-insects-0.2-1.noarch.rpm ftp://ftp.pbone.net/mirror/ftp.mandrivauser.de/rpm/GPL/2010.1/x86_64/release/plymouth-theme-photos-insects-0.2-1mud2010.1.noarch.rpm
ark -b plymouth-theme-photos-insects-0.2-1.noarch.rpm
sudo cp -fr "usr/share/plymouth/themes/photos-insects" "/usr/share/plymouth/themes/" ; sudo plymouth-set-default-theme photos-insects -R

# Downloading, unpack package "plymouth-theme-lmde_0.5.0-1_all.deb"

mkdir plymouth-theme-lmde
cd plymouth-theme-lmde
wget -O plymouth-theme-lmde_0.5.0-1_all.deb https://launchpadlibrarian.net/71936942/plymouth-theme-lmde_0.5.0-1_all.deb
ark -b plymouth-theme-lmde_0.5.0-1_all.deb
ark -b control.tar.gz
ark -b data.tar.gz
cat control

# modification

cd lib/plymouth/themes/LMDE
sed -i.org 's|/lib/|/usr/share/|' LMDE.plymouth
cd ..
sudo cp -fr "LMDE" "/usr/share/plymouth/themes/"; sudo plymouth-set-default-theme LMDE -R

# or

yaourt --noconfirm plymouth theme

# reboot
#######
# Check
# IMPORTANT
# UNDER NO CIRCUMSTANCES TRY TO PRE VIEWING THE THEME WITH COMMAND:

# To quit the preview, press Ctrl+Alt+F2 again and type: plymouth --quit or:

su -c "plymouthd; plymouth --show-splash ; for ((I=0; I<10; I++)); do plymouth --update=test\$I ; sleep 1; done; plymouth --quit"
# ( but may fail...?)

#######

# Exaple config plymouth file:
# file "/etc/plymouth/plymouthd.conf", Exaple:
# file "/usr/share/plymouth/plymouthd.defaults", Exaple:

[Daemon]
Theme=spinner
ShowDelay=5

#----------------------------------------------#
https://wiki.archlinux.org/index.php/Category:Bootsplash
https://wiki.archlinux.org/index.php/plymouth

How to create a customized theme for Plymouth with Super-boot-manager
https://www.youtube.com/watch?v=KpFnGxBhvdk

#----------------------------------------------#
https://wiki.archlinux.org/index.php?title=AUR_helpers
https://archlinux.fr/yaourt-en

yaourt -h                                 Pomoc
yaourt -v                                 Informacje o wersji Yaourt
yaourt ... --noconfirm                    Wyłączenie potwierdzenia polecenia
yaourt --stats                            Statystyki o pakietach i repozytoriach
yaourt -S ...                             Instalacja pakietu - także z AUR 
yaourt -Sb ...                            Budowanie pakietu ze źródła
yaourt -Sc ...                            Czyszczenie pamięci podręcznej Pacmana
yaourt -Sd ...                            Wyłączenie sprawdzania zależności podczas instalacji
yaourt -Sf ...                            Wymuszanie instalacji pakietu
yaourt -Sg ...                            Wyświetlenie wszystkich pakietów w grupie
yaourt -Si ...                            Informacje o wybranym pakiecie
yaourt -Sl ...                            Wyświetlenie wszystkich pakietów wchodzących w skład wybranego repozytorium
yaourt -S ... --ignore <nazwa_pakietu>    Ignorowanie wybranych pakietów podczas instacji
yaourt -Su                                Aktualizacja zainstalowanych pakietów z repozytorium
yaourt -Su --aur                          Aktualizacja zainstalowanych pakietów z repozytorium i AUR
yaourt -Sud                               Wyłączenie sprawdzania zależności podczas aktualizacji
yaourt -Suf                               Wymuszanie aktualizacji ignorując konflikty pakietów
yaourt -Su --ignore <nazwa_pakietu>       Aktualizacja zainstalowanych pakietów oprócz tych wybranych
yaourt -Sy                                Synchronizacja lokalnej bazy pakietów z repozytorium
yaourt -Su                                Reinstalacja wszystkich pakietów oznaczonych jako "nowsze niż te znajdujące się w repozytorium
yaourt -Qe,
yaourt -Qd,                               Wyszukiwanie pakietów jako zależności dla innych
yaourt -Qt                                Wyszukiwanie pakietów nie wymaganych przez inne
yaourt -Qdt                               Wyszukiwanie niepotrzebnych zależności
yaourt -Qet
yaourt -Qg ...                            Wyświetlenie wszystkich zainstalowanych pakietów z wybranej grupy
yaourt -Qi ...                            Informacje o wybranym i zainstalowanym pakiecie
yaourt -Ql ...
yaourt -Qs ...                            Wyszukiwanie pakietu już zainstalowanego
yaourt -Sq --depends <nazwa_pakietu>      Wyświetlenie wszystkich zależności wybranego pakietu
yaourt -Sq --conflicts <nazwa_pakietu>    Wyświetlenie wszystkich konfliktów z wybranym pakietem
yaourt -Sq --provides <nazwa_pakietu>
yaourt -C                                 Zarządzanie plikami .pacsave/.pacnew
yaourt -Cc                                Usuwanie wszystkich .pacsave/.pacnew
yaourt -Cd                                Czyszczenie bazy Pacmana (także stare repozytoria)
yaourt -Sc                                Usuwanie starych pakietów z pamięci podręcznej Pacmana
yaourt -Scc                               Usuwanie wszystkich pakietów z pamięci podręcznej Pacmana
yaourt -R <nazwa_pakietu>                 Odinstalowanie pakietu
yaourt -Rc ...                            Odinstalowanie pakietu i jego zależności
yaourt -Rns ...                           Odinstalowanie pakietu i jego zależności 
yaourt -Rdd ...                           Odinstalowanie pakietu bez sprawdzania zależności   
yaourt -Rk ...
yaourt -B <ściezka do archiwum>           Kopia zapasowa bazy Pacmana

#----------------------------------------------#

EOF
)

katepartrc=$(cat <<-EOF
[Document]
Allow End of Line Detection=true
BOM=false
Backup Flags=0
Backup Prefix=
Backup Suffix=~
Encoding=UTF-8
End of Line=0
Indent On Backspace=true
Indent On Tab=true
Indent On Text Paste=false
Indentation Mode=normal
Indentation Width=8
Keep Extra Spaces=false
Line Length Limit=4096
Newline At EOF=false
On-The-Fly Spellcheck=false
Overwrite Mode=false
PageUp/PageDown Moves Cursor=false
Remove Spaces=0
ReplaceTabsDyn=false
Show Spaces=true
Show Tabs=true
Smart Home=true
Swap Directory=
Swap File Mode=1
Swap Sync Interval=15
Tab Handling=2
Tab Width=8
Word Wrap=false
Word Wrap Column=80

[Editor]
Encoding Prober Type=1
Fallback Encoding=ISO-8859-15

[Renderer]
Animate Bracket Matching=true
Schema=Solarized (dark)
Show Indentation Lines=false
Show Whole Bracket Expression=true
Word Wrap Marker=false

[View]
Allow Mark Menu=true
Auto Brackets=false
Auto Center Lines=0
Auto Completion=true
Bookmark Menu Sorting=0
Default Mark Type=1
Dynamic Word Wrap=true
Dynamic Word Wrap Align Indent=80
Dynamic Word Wrap Indicators=1
Fold First Line=false
Folding Bar=true
Icon Bar=false
Input Mode=0
Keyword Completion=true
Line Modification=false
Line Numbers=true
Maximum Search History Size=100
Persistent Selection=false
Scroll Bar Marks=false
Scroll Bar Mini Map=false
Scroll Bar Mini Map All=false
Scroll Bar Mini Map Width=60
Scroll Past End=false
Search/Replace Flags=140
Show Scrollbars=0
Show Word Count=false
Smart Copy Cut=false
Vi Input Mode Steal Keys=false
Vi Relative Line Numbers=false
Word Completion=true
Word Completion Minimal Word Length=3
Word Completion Remove Tail=true

EOF
)

dolphinrc=$(cat <<-EOF
Height 700=600
Width 820=900

[CompactMode]
FontWeight=50

[DetailsMode]
FontWeight=50

[General]
EditableUrl=true
GlobalViewProps=true
LockPanels=false
ShowFullPath=true
Version=200
ViewPropsTimestamp=2016,2,15,23,15,21

[IconsMode]
FontWeight=50

[KPropertiesDialog]
Height 1200=446
Width 1920=371

[MainWindow]
Height 1200=702
ToolBarsMovable=Disabled
Width 1920=1118

[PreviewSettings]
Plugins=directorythumbnail,imagethumbnail,jpegthumbnail,svgthumbnail,ffmpegthumbs

[SettingsDialog]
Height 1200=410
Width 1920=585

EOF
)

kateschemarc=$(cat <<-EOF
[Solarized (dark)]
Color Search Highlight=85,0,0

EOF
)

kwinrc=$(cat <<-EOF
[Compositing]
OpenGLIsUnsafe=false

[Desktops]
Number=1

[Effect-Zoom]
InitialZoom=1

[org.kde.kdecoration2]
BorderSize=Normal
ButtonsOnLeft=MS
ButtonsOnRight=HIAX
CloseOnDoubleClickOnMenu=false
library=org.kde.oxygen

EOF
)

plasmarc=$(cat <<-EOF
[Theme]
name=oxygen

EOF
)

kdeglobals=$(cat <<-EOF
[ColorEffects:Disabled]
Color=56,56,56
ColorAmount=0
ColorEffect=0
ContrastAmount=0.65000000000000002
ContrastEffect=1
IntensityAmount=0.10000000000000001
IntensityEffect=2

[ColorEffects:Inactive]
ChangeSelectionColor=true
Color=112,111,110
ColorAmount=0.025000000000000001
ColorEffect=2
ContrastAmount=0.10000000000000001
ContrastEffect=2
Enable=false
IntensityAmount=0
IntensityEffect=0

[Colors:Button]
BackgroundAlternate=77,77,77
BackgroundNormal=49,54,59
DecorationFocus=61,174,233
DecorationHover=61,174,233
ForegroundActive=61,174,233
ForegroundInactive=189,195,199
ForegroundLink=41,128,185
ForegroundNegative=218,68,83
ForegroundNeutral=246,116,0
ForegroundNormal=239,240,241
ForegroundPositive=39,174,96
ForegroundVisited=127,140,141

[Colors:Selection]
BackgroundAlternate=29,153,243
BackgroundNormal=61,174,233
DecorationFocus=61,174,233
DecorationHover=61,174,233
ForegroundActive=252,252,252
ForegroundInactive=239,240,241
ForegroundLink=253,188,75
ForegroundNegative=218,68,83
ForegroundNeutral=246,116,0
ForegroundNormal=239,240,241
ForegroundPositive=39,174,96
ForegroundVisited=189,195,199

[Colors:Tooltip]
BackgroundAlternate=77,77,77
BackgroundNormal=49,54,59
DecorationFocus=61,174,233
DecorationHover=61,174,233
ForegroundActive=61,174,233
ForegroundInactive=189,195,199
ForegroundLink=41,128,185
ForegroundNegative=218,68,83
ForegroundNeutral=246,116,0
ForegroundNormal=239,240,241
ForegroundPositive=39,174,96
ForegroundVisited=127,140,141

[Colors:View]
BackgroundAlternate=49,54,59
BackgroundNormal=35,38,41
DecorationFocus=61,174,233
DecorationHover=61,174,233
ForegroundActive=61,174,233
ForegroundInactive=189,195,199
ForegroundLink=41,128,185
ForegroundNegative=218,68,83
ForegroundNeutral=246,116,0
ForegroundNormal=239,240,241
ForegroundPositive=39,174,96
ForegroundVisited=127,140,141

[Colors:Window]
BackgroundAlternate=77,77,77
BackgroundNormal=49,54,59
DecorationFocus=61,174,233
DecorationHover=61,174,233
ForegroundActive=61,174,233
ForegroundInactive=189,195,199
ForegroundLink=41,128,185
ForegroundNegative=218,68,83
ForegroundNeutral=246,116,0
ForegroundNormal=239,240,241
ForegroundPositive=39,174,96
ForegroundVisited=127,140,141

[DesktopIcons]
ActiveColor=169,156,255
ActiveColor2=0,0,0
ActiveEffect=togamma
ActiveSemiTransparent=false
ActiveValue=0.699999988
Animated=true
DefaultColor=144,128,248
DefaultColor2=0,0,0
DefaultEffect=none
DefaultSemiTransparent=false
DefaultValue=1
DisabledColor=34,202,0
DisabledColor2=0,0,0
DisabledEffect=togray
DisabledSemiTransparent=true
DisabledValue=1
Size=48

[DialogIcons]
ActiveColor=169,156,255
ActiveColor2=0,0,0
ActiveEffect=none
ActiveSemiTransparent=false
ActiveValue=1
Animated=false
DefaultColor=144,128,248
DefaultColor2=0,0,0
DefaultEffect=none
DefaultSemiTransparent=false
DefaultValue=1
DisabledColor=34,202,0
DisabledColor2=0,0,0
DisabledEffect=togray
DisabledSemiTransparent=true
DisabledValue=1
Size=32

[General]
ColorScheme=Breeze Dark
Name=Breeze
XftAntialias=true
XftHintStyle=hintmedium
XftSubPixel=none
shadeSortColumn=true
widgetStyle=Breeze

[Icons]
Theme=oxygen

[KDE]
ColorScheme=Breeze
contrast=4
widgetStyle=Breeze

[MainToolbarIcons]
ActiveColor=169,156,255
ActiveColor2=0,0,0
ActiveEffect=none
ActiveSemiTransparent=false
ActiveValue=1
Animated=false
DefaultColor=144,128,248
DefaultColor2=0,0,0
DefaultEffect=none
DefaultSemiTransparent=false
DefaultValue=1
DisabledColor=34,202,0
DisabledColor2=0,0,0
DisabledEffect=togray
DisabledSemiTransparent=true
DisabledValue=1
Size=22

[PanelIcons]
ActiveColor=169,156,255
ActiveColor2=0,0,0
ActiveEffect=togamma
ActiveSemiTransparent=false
ActiveValue=0.699999988
Animated=false
DefaultColor=144,128,248
DefaultColor2=0,0,0
DefaultEffect=none
DefaultSemiTransparent=false
DefaultValue=1
DisabledColor=34,202,0
DisabledColor2=0,0,0
DisabledEffect=togray
DisabledSemiTransparent=true
DisabledValue=1
Size=32

[SmallIcons]
ActiveColor=169,156,255
ActiveColor2=0,0,0
ActiveEffect=none
ActiveSemiTransparent=false
ActiveValue=1
Animated=false
DefaultColor=144,128,248
DefaultColor2=0,0,0
DefaultEffect=none
DefaultSemiTransparent=false
DefaultValue=1
DisabledColor=34,202,0
DisabledColor2=0,0,0
DisabledEffect=togray
DisabledSemiTransparent=true/dev/sda2
DisabledValue=1
Size=16

[ToolbarIcons]
ActiveColor=169,156,255
ActiveColor2=0,0,0
ActiveEffect=none
ActiveSemiTransparent=false
ActiveValue=1
Animated=false
DefaultColor=144,128,248
DefaultColor2=0,0,0
DefaultEffect=none
DefaultSemiTransparent=false
DefaultValue=1
DisabledColor=34,202,0
DisabledColor2=0,0,0
DisabledEffect=togray
DisabledSemiTransparent=true
DisabledValue=1
Size=22

[WM]
activeBackground=49,54,59
activeBlend=255,255,255
activeForeground=239,240,241
inactiveBackground=49,54,59
inactiveBlend=75,71,67
inactiveForeground=127,140,141

EOF
)

plasma_org=$(cat <<-EOF
[ActionPlugins][0]
MidButton;NoModifier=org.kde.paste
RightButton;NoModifier=org.kde.contextmenu
wheel:Vertical;NoModifier=org.kde.switchdesktop

[ActionPlugins][1]
RightButton;NoModifier=org.kde.contextmenu

[ActionPlugins][127]
RightButton;NoModifier=org.kde.contextmenu

[Containments][1]
activityId=
formfactor=2
immutability=1
lastScreen=0
location=4
plugin=org.kde.panel
wallpaperplugin=org.kde.image

[Containments][1][Applets][16]
immutability=1
plugin=org.kde.plasma.kicker

[Containments][1][Applets][16][Configuration][General]
favoriteApps=preferred://browser,systemsettings.desktop,org.kde.dolphin.desktop,org.kde.kate.desktop

[Containments][1][Applets][16][Shortcuts]
global=Alt+F1

[Containments][1][Applets][2][Configuration][General]
favorites=
systemApplications=systemsettings.desktop,

[Containments][1][Applets][3]
immutability=1
plugin=org.kde.plasma.pager

[Containments][1][Applets][4]
immutability=1
plugin=org.kde.plasma.taskmanager

[Containments][1][Applets][5]
immutability=1
plugin=org.kde.plasma.systemtray

[Containments][1][Applets][5][Configuration][Containments][8]
formfactor=2
location=4

[Containments][1][Applets][5][Configuration][Containments][8][Applets][10]
immutability=1
plugin=org.kde.plasma.notifications

[Containments][1][Applets][5][Configuration][Containments][8][Applets][11]
immutability=1
plugin=org.kde.plasma.devicenotifier

[Containments][1][Applets][5][Configuration][Containments][8][Applets][12]
immutability=1
plugin=org.kde.plasma.clipboard

[Containments][1][Applets][5][Configuration][Containments][8][Applets][13]
immutability=1
plugin=org.kde.discovernotifier

[Containments][1][Applets][5][Configuration][Containments][8][Applets][14]
immutability=1
plugin=org.kde.plasma.battery

[Containments][1][Applets][5][Configuration][Containments][8][Applets][15]
immutability=1
plugin=org.kde.plasma.networkmanagement

[Containments][1][Applets][5][Configuration][Containments][8][Applets][9]
immutability=1
plugin=org.kde.plasma.volume

[Containments][1][Applets][5][Configuration][General]
extraItems=org.kde.plasma.volume,org.kde.plasma.bluetooth,org.kde.plasma.mediacontroller,org.kde.plasma.clipboard,org.kde.plasma.networkmanagement,org.kde.discovernotifier,org.kde.plasma.battery,org.kde.plasma.devicenotifier,org.kde.plasma.notifications
knownItems=org.kde.plasma.volume,org.kde.plasma.bluetooth,org.kde.plasma.mediacontroller,org.kde.plasma.clipboard,org.kde.plasma.networkmanagement,org.kde.discovernotifier,org.kde.plasma.battery,org.kde.plasma.devicenotifier,org.kde.plasma.notifications

[Containments][1][Applets][6]
immutability=1
plugin=org.kde.plasma.digitalclock

[Containments][1][General]
AppletOrder=16;2;3;4;5;6

[Containments][7]
activityId=486d39d4-928e-4fc4-ba26-6ef69976352e
formfactor=0
immutability=1
lastScreen=0
location=0
plugin=org.kde.desktopcontainment
wallpaperplugin=org.kde.image

[Containments][7][ConfigDialog]
DialogHeight=540
DialogWidth=720

[Containments][7][Wallpaper][org.kde.image][General]
Image=file:/usr/share/wallpapers/Path/contents/images/1920x1200.jpg
height=1200
width=1920

EOF
)

Powiedz_wiersz_lokomotywa=$(cat <<-SOF
#!/bin/bash

Begin () {

if [ ! -t 0 ]; then # script is executed outside the terminal
# execute the script inside a terminal window
konsole -e "/bin/bash \\"\$0\\" \$*"
exit \$?
fi

while true; do
read -p "Wiersz - Julian Tuwim „Lokomotywa” [E] English or [P] Polski ?: " -n 1 -r ep

case \$ep in

[Ee]* ) echo;echo "„The Locomotive” by Julian Tuwim (1894-1953)"; echo \$Locomotive | espeak -v en -s 160
break;;

[Pp]* ) echo;echo "Wiersz - Julian Tuwim (1894-1953) „Lokomotywa”"; echo \$Lokomotywa | espeak -v pl -s 155 -p 20
break;;

* )
break;;

esac
done

}

Locomotive=\$(cat <<-EOF
The Locomotive by Julian Tuwim (1894-1953)

A big locomotive has pulled into town,
Heavy, humungus, with sweat rolling down,
A plump jumbo olive.
Huffing and puffing and panting and smelly,
Fire belches forth from her fat cast iron belly.

Poof, how she's burning,
Oof, how she's boiling,
Puff, how she's churning,
Huff, how she's toiling.
She's fully exhausted and all out of breath,
Yet the coalman continues to stoke her to death.

Numerous wagons she tugs down the track:
Iron and steel monsters hitched up to her back,
All filled with people and other things too:
The first carries cattle, then horses not few;
The third car with corpulent people is filled,
Eating fat frankfurters all freshly grilled.
The fourth car is packed to the hilt with bananas,
The fifth has a cargo of six grand pi-an-as.
The sixth wagon carries a cannon of steel,
With heavy iron girders beneath every wheel.
The seventh has tables, oak cupboards with plates,
While an elephant, bear, two giraffes fill the eighth.
The ninth contains nothing but well-fattened swine,
In the tenth: bags and boxes, now isn't that fine?
/dev/sda2
There must be at least forty cars in a row,
And what they all carry, I simply don't know:

But if one thousand athletes, with muscles of steel,
Each ate one thousand cutlets in one giant meal,
And each one exerted as much as he could,
They'd never quite manage to lift such a load.

First a toot!
Then a hoot!
Steam is churning,
Wheels are turning!

More slowly - than turtles - with freight - on their - backs,
The drowsy - steam engine - sets off - down the tracks.
She chugs and she tugs at her wagons with strain,
As wheel after wheel slowly turns on the train.
She doubles her effort and quickens her pace,
And rambles and scrambles to keep up the race.
Oh whither, oh whither? go forward at will,
And chug along over the bridge, up the hill,
Through mountains and tunnels and meadows and woods,
Now hurry, now hurry, deliver your goods.
Keep up your tempo, now push along, push along,
Chug along, tug along, tug along, chug along
Lightly and sprightly she carries her freight
Like a ping-pong ball bouncing without any weight,
Not heavy equipment exhausted to death,
But a little tin toy, just a light puff of breath.
Oh whither, oh whither, you'll tell me, I trust,
What is it, what is it that gives you your thrust?
What gives you momentum to roll down the track?
It's hot steam that gives me my clickety-clack.
Hot steam from the boiler through tubes to the pistons,
The pistons then push at the wheels from short distance,
They drive and they push, and the train starts a-swooshin'
'Cuz steam on the pistons keeps pushin' and pushin';
The wheels start a rattlin', clatterin', chatterin'
Chug along, tug along, chug along, tug along! . . .
EOF
)

Lokomotywa=\$(cat <<-EOF
Julian Tuwim (1894-1953) „Lokomotywa”

Stoi na stacji lokomotywa,
Ciężka, ogromna i pot z niej spływa -
Tłusta oliwa.
Stoi i sapie, dyszy i dmucha,
Żar z rozgrzanego jej brzucha bucha:
Buch - jak gorąco!
Uch - jak gorąco!
Puff - jak gorąco!
Uff - jak gorąco!
Już ledwo sapie, już ledwo zipie,
A jeszcze palacz węgiel w nią sypie.
Wagony do niej podoczepiali
Wielkie i ciężkie, z żelaza, stali,
I pełno ludzi w każdym wagonie,
A w jednym krowy, a w drugim konie,
A w trzecim siedzą same grubasy,
Siedzą i jedzą tłuste kiełbasy.
A czwarty wagon pełen bananów,
A w piątym stoi sześć fortepianów,
W szóstym armata, o! jaka wielka!
Pod każdym kołem żelazna belka!
W siódmym dębowe stoły i szafy,
W ósmym słoń, niedźwiedź i dwie żyrafy,
W dziewiątym - same tuczone świnie,
W dziesiątym - kufry, paki i skrzynie,
A tych wagonów jest ze czterdzieści,
Sam nie wiem, co się w nich jeszcze mieści.

Lecz choćby przyszło tysiąc atletów
I każdy zjadłby tysiąc kotletów,
I każdy nie wiem jak się natężał,
To nie udźwigną - taki to ciężar!

Nagle - gwizd!
Nagle - świst!
Para - buch!
Koła - w ruch!

Najpierw
powoli
jak żółw
ociężale
Ruszyła
maszyna
po szynach
ospale.
Szarpnęła wagony i ciągnie z mozołem,
I kręci się, kręci się koło za kołem,
I biegu przyspiesza, i gna coraz prędzej,
I dudni, i stuka, łomoce i pędzi.

A dokąd? A dokąd? A dokąd? Na wprost!
Po torze, po torze, po torze, przez most,
Przez góry, przez tunel, przez pola, przez las
I spieszy się, spieszy, by zdążyć na czas,
Do taktu turkoce i puka, i stuka to:
Tak to to, tak to to, tak to to, tak to to,
Gładko tak, lekko tak toczy się w dal,
Jak gdyby to była piłeczka, nie stal,
Nie ciężka maszyna zziajana, zdyszana,
Lecz raszka, igraszka, zabawka blaszana.

A skądże to, jakże to, czemu tak gna?
A co to to, co to to, kto to tak pcha?
Że pędzi, że wali, że bucha, buch-buch?
To para gorąca wprawiła to w ruch,
To para, co z kotła rurami do tłoków,
A tłoki kołami ruszają z dwóch boków
I gnają, i pchają, i pociąg się toczy,
Bo para te tłoki wciąż tłoczy i tłoczy,,
I koła turkocą, i puka, i stuka to:
Tak to to, tak to to, tak to to, tak to to!...
EOF
)

Begin

SOF
)

}

Begin
#End
