#!/bin/bash
# new_funtoo_install.sh script
# Test Install Funtoo Linux script for Easy Monitor - Test beta,
# http://www.funtoo.org/Welcome
# http://www.funtoo.org/Install
# http://www.funtoo.org/Funtoo_Linux_First_Steps
# http://www.funtoo.org/KDE_Plasma_5

# http://www.funtoo.org/Subarches
##################

get_parameters () {


# Parameters to change

distro="Funtoo"
post_fix=`date +%F`
host_name="$distro$post_fix"

user_login="funtooi"
# name of your user account

country_setup="Polski"

# ="Polski" for Polish
# ="Русский" Rosyjski
# ="No" English
#
#
#

# You can finish hier, but if you want - Packages selection
##################

: ${mirrors:="http://ftp.osuosl.org/pub/funtoo/funtoo-stable/x86-32bit/i686/"}; file_name="stage3-latest.tar.xz"; shasums_file="stage3-latest.tar.xz.hash.txt"
# http://ftp.osuosl.org/pub/funtoo/funtoo-stable/x86-32bit/i686/stage3-latest.tar.xz stage3-latest.tar.xz.hash.txt

backup="yes"
backup_dir="/$distro"_stage3""
# if "yes" - Saving download packages for future installations
# need place in $backup_dir - root filesystem ( about 1,5GB and depend on your choice of packages)

dest="/mnt/$distro"
file_system_type="ext4"

# ( Old Grub )
# it is possible to install new Grub on partition - Example: "dev/sda1"
# and boot from another bootloader Example for old Grub :
#--------------------#
# title $distro
#    rootnoverify (hd0,0)
# #  makeactive
#    chainloader +1
#--------------------#

##################
# advanced parameters to change

if [[ $country_setup = "Polski" ]]; then

lc=Polish

make_conf=$(cat <<-EOF
LINGUAS="pl en"
LANGUAGE=48
#EMERGE_DEFAULT_OPTS="--ask --verbose"
ACCEPT_LICENSE="*"
EOF
)

set_locale=pl_PL.utf8

locale_gen=$(cat <<-EOF
pl_PL.UTF-8 UTF-8
pl_PL ISO-8859-2
EOF
)
# /etc/locale.gen
# && locale-gen
# The format of each line:
# <locale> <charmap>
#
# Where <locale> is a locale located in /usr/share/i18n/locales/ and
# where <charmap> is a charmap located in /usr/share/i18n/charmaps/.
#
# All blank lines and lines starting with # are ignored.
#
# For the default list of supported combinations, see the file:
# /usr/share/i18n/SUPPORTED

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

# /etc/vconsole.conf ( Arch... )
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
CONSOLEFONT=Lat2-Terminus16

EOF
)

# /etc/conf.d/consolefont  ( Gentoo Funtoo.. )
console_font=$(cat <<-EOF
# The consolefont service is not activated by default. If you need to
# use it, you should run "rc-update add consolefont boot" as root.
#
# consolefont specifies the default font that you'd like Linux to use on the
# console.  You can find a good selection of fonts in /usr/share/consolefonts;
# you shouldn't specify the trailing ".psf.gz", just the font name below.
# To use the default console font, comment out the CONSOLEFONT setting below.
# consolefont="default8x16"
consolefont="lat2a-16"

# consoletranslation is the charset map file to use.  Leave commented to use
# the default one.  Have a look in /usr/share/consoletrans for a selection of
# map files you can use.
# consoletranslation="8859-1_to_uni"
consoletranslation="8859-2_to_uni"

# unicodemap is the unicode map file to use. Leave commented to use the
# default one. Have a look in /usr/share/unimaps for a selection of map files
# you can use.
#unicodemap="iso01"
#unicodemap="8859-2.a0-ff.uni"

EOF
)

# /etc/conf.d/keymaps ( Gentoo Funtoo.. )
key_maps=$(cat <<-EOF
# Use keymap to specify the default console keymap.  There is a complete tree
# of keymaps in /usr/share/keymaps to choose from.
#keymap="us"
keymap="pl"

# Should we first load the 'windowkeys' console keymap?  Most x86 users will
# say "yes" here.  Note that non-x86 users should leave it as "no".
# Loading this keymap will enable VT switching (like ALT+Left/Right)
# using the special windows keys on the linux console.
windowkeys="YES"

# The maps to load for extended keyboards.  Most users will leave this as is.
extended_keymaps=""
#extended_keymaps="backspace keypad euro2"

# Tell dumpkeys(1) to interpret character action codes to be
# from the specified character set.
# This only matters if you set unicode="yes" in /etc/rc.conf.
# For a list of valid sets, run \`dumpkeys --help\`
dumpkeys_charset=""

# Some fonts map AltGr-E to the currency symbol instead of the Euro.
# To fix this, set to "yes"
fix_euro="NO"

EOF
)

# Arch  /etc/locale.conf
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

# Funtoo Gentoo /etc/env.d/02locale
_02locale=$(cat <<-EOF
LANG=pl_PL.utf8
LC_CTYPE="pl_PL.utf8"
LC_NUMERIC="pl_PL.utf8"
LC_TIME="pl_PL.utf8"
LC_COLLATE=POSIX
LC_MONETARY="pl_PL.utf8"
LC_MESSAGES="pl_PL.utf8"
LC_PAPER="pl_PL.utf8"
LC_NAME="pl_PL.utf8"
LC_ADDRESS="pl_PL.utf8"
LC_TELEPHONE="pl_PL.utf8"
LC_MEASUREMENT="pl_PL.utf8"
LC_IDENTIFICATION="pl_PL.utf8"
LC_ALL=

EOF
)

fi

if [[ $country_setup = "Русский" ]]; then

lc=Russian

make_conf=$(cat <<-EOF
LINGUAS="ru en"
ACCEPT_LICENSE="*"
EOF
)


set_locale=ru_RU.utf8

locale_gen=$(cat <<-EOF
ru_RU.UTF-8 UTF-8
EOF
)

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

EOF
)

locale_conf=$(cat <<-EOF
LOCALE=ru_RU.UTF-8
LC_MESSAGES="ru_RU.UTF-8"
EOF
)
fi

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
}
# End of advanced parameters to change
##################

prepare_check_environment () {

################## Variables for color terminal
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
	
	echo "$n$Green Install $distro Linux into a partition from another distribution,..$Orange Test beta script$Reset"
	echo "$Green # by Leszek Ostachowski (2016) GPL V2$Reset$n"
	echo "$Orange Script is under construction, so for now install „Stage 3” on destinatin partition and then you're on your own... http://www.funtoo.org/Install$Reset$n"
	
	if ! [ $(id -u) = 0 ]; then echo "$n$Orange This install script must be run with root privileges.$Reset$n";exit 1;fi
	
	# Gathering informations about dowload program
	if command -v wget >/dev/null 2>&1; then
		_get_command() { wget -O- "$@" ; }
	elif command -v curl >/dev/null 2>&1; then
		_get_command() { curl -fL "$@" ; }
	else
		echo "This script needs curl or wget" >&2
		exit 2
	fi
	
	if [ -z $TMPDIR ]; then TMPDIR=/tmp; fi
	
	mkdir -p "$dest"
	if ! [ $? = 0 ]; then echo "error can't create $dest"; exit 1; fi
	
	
	if [[ $backup = "yes" ]] || [[ $backup = "Yes" ]]; then
		mkdir -p "$backup_dir"
		mkdir -p "$backup_dir/usr/portage"
		if ! [ $? = 0 ]; then echo "error can't create $backup_dir"; fi
	fi
}

function r_ask () {
    read -p "$1 ([y]es or [N]o): " -n 1 -r
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo -n "yes" ;;
        *)     echo -n "no" ;;
    esac
}

ask_for_install () {
	
	fdisk -l
	
	echo  "$n$LCyan Tip - You can use mouse to highlight names and then use copy paste in konsole for give answers$Reset$n$n"
	
	echo  "$LGreen You are as root going to Install a New $distro Limux into a partotion. $LRed The data on this partition will be lost !!!$Reset$n"
	
	echo  "$LGreen If you have prepared a $LRed partition to format $Cyan and ( you need 1 GB free space left on root ) you can continue $Reset$n"
	
	echo -n "$LGreen Give full Device name to $LRed Install $distro Linux or Enter for skip : "; read dest_partition; echo "$Reset"
	
	if [[ "$dest_partition" = "" ]]; then
		echo "$n	$Orange Ok. You tried, you failed but, at least, you tried and you might succeed next time around :).$n\
		You should prepare your hard drive for such spare partition.$Reset$n"
		echo  "$n$LCyan Tip - I have first partition '/dev/sda1' 15GB, only for play/testing distros$Reset"
		echo  "$Green But in fact I use as primary all (3) for differents systems include DOS \ and several extended logical partitions for swap my Linux and 'homes' - data$Reset$n"
		exit 1
	fi
	
	if ! [ -b "$dest_partition" ]; then echo "$LRed "$dest_partition"$Red is not a block device.$Reset$n"; exit 1; fi
	
}

make_file_system_type () {
	
	# Format and label filesystem on $dest_partition
	
	fuser -k "$dest"
	umount -R "$dest"
	
	echo "$n$LRed Make $file_system_type on $dest_partition - mkfs -t "$file_system_type" "$dest_partition" $Reset$n"
	mkfs -t "$file_system_type" "$dest_partition"
	
	if ! [ $? = 0 ]; then exit 1; fi
	label_dest_partition=$(blkid "$dest_partition" -o value -s LABEL)
	
	if [[ "" = "$label_dest_partition" ]]; then
	
	#while true; do
	#	echo -n "$n$LBlue LABEL$LYellow is epty for the device $dest_partition $LRed Do you want give a LABEL for it , "
	#	read -p "Please answer Y or N? " yn
	#	case $yn in
	#	[Yy]* ) echo "Yes"
	#	echo -n "$n$LRed Give a LABEL for it : "; read $host_name
		
		file_system_type=$(blkid "$dest_partition" -o value -s TYPE)
		
		if [ "$file_system_type" = "ext2" ] || [ "$file_system_type" = "ext3" ] || [ "$file_system_type" = "ext4" ]; then
			echo "$n$Green LABEL = tune2fs -L "$host_name" "$dest_partition"$Reset$n"
			tune2fs -L "$host_name" "$dest_partition"
		fi
		
		if [ $file_system_type = "vfat" ]; then
			# dosfstools - Utilities for Making and Checking MS-DOS FAT File Systems on Linux
			umount "$dest_partition"
			fatlabel "$dest_partition" "$host_name"
			mount -v "$dest_partition" "$dest"; if [ $? = 0 ]; then echo  "$LYellow $(blkid "$dest_partition") $Reset"; else exit 1; fi
		fi
		
		if [ $file_system_type = "ntfs" ]; then
			# ntfsprogs - NTFS Utilities
			umount "$dest_partition"
			ntfslabel "$dest_partition" "$host_name"
			mount -v "$dest_partition" "$dest"; if [ $? = 0 ]; then echo  "$LYellow $(blkid "$dest_partition") $Reset"; else exit 1; fi
		fi
		
		#jfs_tune -L <label> <device> # jfsutils - IBM JFS Utility Programs
		#tunefs.reiserfs -l <label> <device> # reiserfs - Reiser File System utilities
		#xfs_admin -L <label> <device> # xfsprogs - Utilities for managing the XFS file system
	#	break;;
	#	
	#	[Nn]* ) echo "No"; break;;
	#	* ) echo "Please answer Y or N.";;
	#	esac
	#done
	fi
}

mount_destination () {
	
	# Nomunt $dest_partition on $dest
	
	echo "$n$LRed Mount $dest_partition on "$dest" :$Reset$n"
	mount "$dest_partition" "$dest"
	
	# Sukcess continue
	if ! [ $? = 0 ]; then exit 1; fi
	
}

get_it () {
	
	# Build download command, mirror and pathy
	
	local file="$1" x=
	shift
	for x in $mirrors; do
		_get_command "$x$file" && return 0
	done
	return 1
}

download_it () {
	
	# Download
	
	cd $TMPDIR
	
	echo "$n$Green download $mirrors$shasums_file :$Reset$n"
	get_it "$shasums_file" > "$shasums_file"
	
	if ! [ $? = 0 ]; then
		if [ -f "$backup_dir/$shasums_file" ] && [ -f "$backup_dir/$file_name" ]; then
			cp -fax "$backup_dir/$shasums_file" "$TMPDIR"
			cp -fax "$backup_dir/$file_name" "$TMPDIR"
		else
			exit 1
		fi
	else
		cp -fax "$backup_dir/$file_name" "$TMPDIR"
		sum=$(cat $shasums_file | awk '{print $2}'; echo -n $file_name)
		echo $sum | sha256sum -c
		if ! [ $? = 0 ]; then
			echo "$n$Green download $mirrors$file_name :$Reset$n"
			get_it "$file_name" > "$file_name"
		fi
		
	fi
	
	# test
	sum=$(cat $shasums_file | awk '{print $2}'; echo -n $file_name)
	echo $sum | sha256sum -c || exit 1
}

extract_it () {
	
	# Extract bootstrap
	
	echo "$n$LGreen  Extract bootstrap - tar -xpf "$file_name" -C "$dest" :$Reset$n"
	
	tar -xpf "$file_name" -C "$dest"
	if ! [ $? = 0 ]; then exit 1; fi
	
	echo;cat "$dest/etc/"*release
}

make_backup_of_pckages () {
	
	# Saving a backup of download packages for future installations
	
	if [[ $backup = "yes" ]] || [[ $backup = "Yes" ]]; then
		
		# Make backup
		
		if [ -f "$shasums_file" ] && [ -f "$file_name" ]; then
			
			echo "$n$Green Saving a backup of download packages: $file_name $shasums_file  in $backup_dir/ for future installations$Reset$n"
			mkdir -p "$backup_dir"
			mv -u "$shasums_file" "$backup_dir/$shasums_file"
			mv -u "$file_name" "$backup_dir/$file_name"
			
		fi
	fi
	
	# Clean tmp dir
	
	rm -f "$file_name"
	rm -f "$shasums_file"
}

prepare_chroot_exec () {
	
	# Mount options taked from arch-chroot script
	
	mount -t proc proc -o nosuid,noexec,nodev "$dest/proc"
	mount -t sysfs sys -o nosuid,noexec,nodev,ro "$dest/sys"
	mount -t devtmpfs -o mode=0755,nosuid udev "$dest/dev"
	mkdir -p "$dest/dev/pts" "$dest/dev/shm"
	mount -t devpts -o mode=0620,gid=5,nosuid,noexec devpts "$dest/dev/pts"
	mount -t tmpfs -o mode=1777,nosuid,nodev shm "$dest/dev/shm"
	mount -t tmpfs -o nosuid,nodev,mode=0755 run "$dest/run"
	mount -t tmpfs -o mode=1777,strictatime,nodev,nosuid tmp "$dest/tmp"
	# Workaround for Debian
	mkdir -p "$dest/run/shm"
}

chroot_exec () {
	
	# Execute command "$*" in chroot in $dest enviroment
	
	chroot "$dest" /usr/bin/env -i HOME=/root TERM=$TERM /bin/bash --login +h -c "source /etc/profile;env-update;$*"
	
}

configure_bootstrap () {
	
	#export $(dbus-launch) >/dev/null 2>&1
	#export XAUTHORITY=/home/$user/.Xauthority
	#DISPLAY=:0.0 ; export DISPLAY
	#xhost +si:localuser:your_username
	
	# Set the /etc/hostname:
	echo "$n$Green "$dest/etc/hostname" :$Reset$n"
	echo "$host_name" > "$dest/etc/hostname"
	cat "$dest/etc/hostname"
	#$editor "$dest/etc/hostname" >/dev/null 2>&1
	
	if ! [[ $localtime = "" ]]; then
	# Set the time zone /etc/localtime:
	echo "$n$Green "$dest/etc/localtime" =$Reset$n"
	ln -fs "/usr/share/zoneinfo/$localtime" "$dest/etc/localtime"
	fi
	ls -l "$dest/etc/localtime"
	
	# Set the time hwclock --systohc --utc:
	# /etc/conf.d/hwclock
	echo "$n$Green cat $dest/etc/conf.d/hwclock :$Reset$n"
	cat "$dest/etc/conf.d/hwclock"
	
	echo "$n$Green hwclock --systohc --utc :$Reset$n"
	chroot_exec "hwclock --systohc --utc"
	
	# If you dual-boot with Windows, you'll need to edit this file and change the value of clock from UTC to local,
	# because Windows will set your hardware clock to local time every time you boot Windows. Otherwise you normally wouldn't need to edit this file.
	
	# Copy the /etc/resolv.conf: # https://wiki.archlinux.org/index.php/resolv.conf
	echo "$n$Green Copy the resolv.conf - cp -L /etc/resolv.conf "$dest/etc/" :$Reset$n"
	cp -v -L /etc/resolv.conf "$dest/etc/"
	cat "$dest/etc/resolv.conf"
	#$editor "$dest/etc/resolv.conf" >/dev/null 2>&1
	
	# Generate /etc/fstab: https://wiki.archlinux.org/index.php/fstab
	echo "$n$Green Set the genfstab "$dest/etc/fstab" :$Reset$n"
	chroot_exec "genfstab -L / > /etc/fstab"
	cat "$dest/etc/fstab"
	#$editor "$dest/etc/fstab" >/dev/null 2>&1
	
	# Restore repository 'gentoo' into '/usr/portage'...
	if [[ $backup = "yes" ]] || [[ $backup = "Yes" ]]; then
	echo "$n$Green cp -fax $backup_dir/usr/portage $dest/usr/ :$Reset$n"
	cp -fax  "$backup_dir/usr/portage" "$dest/usr/"
	fi
	
	# Parameters used by gcc (compiler)
	# https://wiki.gentoo.org/wiki//etc/portage/make.conf
	n_proc=$(($(nproc)+1))
	
	#echo "MAKEOPTS=\"-j$n_proc\" > $dest/etc/portage/make.conf"
	#echo "MAKEOPTS=\"-j$n_proc\"" > "$dest/etc/portage/make.conf"
	
	echo "MAKEOPTS=\"-j$n_proc\" > $dest/etc/make.conf"
	echo "MAKEOPTS=\"-j$n_proc\"" > "$dest/etc/make.conf"
	
	# Parameters used by gcc (compiler), portage, and make. It's a good idea to set MAKEOPTS
	# nproc = 16 	# Set MAKEOPTS to this number plus one: MAKEOPTS="-j17"
	# Syncing repository 'gentoo' into '/usr/portage'...
	
	# Generate locale-gen:
	echo "$n$Green locale-gen :$Reset$n"
	chroot_exec "locale-gen"
	
	echo "$n$Green rc-update :$Reset$n"
	chroot_exec "rc-update"
	
	echo "$n$Green eselect locale list :$Reset$n"
	chroot_exec "eselect locale list"
	
	##############
	
	if ! [[ $country_setup = "No" ]]; then
	
	# Set the /etc/vconsole.conf:
	#echo "$n$Green $dest/etc/vconsole.conf :$Reset$n"
	#echo "$vconsole_conf" > "$dest/etc/vconsole.conf"
	#cat "$dest/etc/vconsole.conf"
	#$editor "$dest/etc/vconsole.conf" >/dev/null 2>&1
	
	# Set the /etc/locale.conf:
	#echo "$n$Green "$dest/etc/locale.conf" :$Reset$n"
	#echo "$locale_conf" > "$dest/etc/locale.conf"
	#cat "$dest/etc/locale.conf"
	#$editor "$dest/etc/locale.conf" >/dev/null 2>&1
	
	# Set the /etc/env.d/02locale:
	#echo "$n$Green echo $_02localel >> $dest/etc/env.d/02locale :$Reset$n"
	#echo "$_02locale" >> "$dest/etc/env.d/02locale"
	#cat "$dest/etc/env.d/02locale"
	
	# Set the /etc/conf.d/consolefont:
	echo "$n$Green cat $dest/etc/conf.d/consolefont :$Reset$n"
	echo "$console_font" > "$dest/etc/conf.d/consolefont"
	cat "$dest/etc/conf.d/consolefont"
	# /etc/conf.d/consolefont	Optional	Allows you to specify the default console font. To apply this font, enable the consolefont service by running rc-update add consolefont.
	
	# Set the /etc/conf.d/keymaps"
	echo "$n$Green cat $dest/etc/conf.d/keymaps :$Reset$n"
	echo "$key_maps" > "$dest/etc/conf.d/keymaps"
	cat "$dest/etc/conf.d/keymaps"
	# /etc/conf.d/keymaps	Optional	Keyboard mapping configuration file (for console pseudo-terminals). Set if you have a non-US keyboard
	
	# Set the /etc/locale.gen:
	echo "$n$Green "$dest/etc/locale.gen" :$Reset$n"
	echo "$locale_gen" >> "$dest/etc/locale.gen"
	cat "$dest/etc/locale.gen"
	#$editor "$dest/etc/locale.gen" >/dev/null 2>&1
	
	# LINGUAS=\"$LINGUAS\" LANGUAGE=\"$LANGUAGE\"
	
	echo "$n$Green grep -i $lc "$dest/usr/portage/profiles/desc/linguas.desc" :$Reset$n"
	grep -i $lc "$dest/usr/portage/profiles/desc/linguas.desc"
	
	# Set the /etc/portage/make.conf:
	#echo "$n$Green echo "$make_conf" >> $dest/etc/portage/make.conf :$Reset$n"
	#echo "$make_conf" >> "$dest/etc/portage/make.conf"
	
	echo "$n$Green echo $make_conf >> $dest/etc/make.conf :$Reset$n"
	echo "$make_conf" >> "$dest/etc/make.conf"
	
	# Generate locale-gen:
	echo "$n$Green locale-gen :$Reset$n"
	chroot_exec "locale-gen"
	
	echo "$n$Green eselect locale list :$Reset$n"
	chroot_exec "eselect locale list"
	
	echo "$n$Green eselect locale set $set_locale :$Reset$n"
	chroot_exec "eselect locale set $set_locale"
	
	echo "$n$Green etc-update; rc-update :$Reset$n"
	chroot_exec "etc-update; rc-update"
	
	echo "$n$Green locale :$Reset$n"
	chroot_exec "locale"
	
	fi
	
	echo "$n$Green cat $dest/etc/make.conf :$Reset$n"
	cat "$dest/etc/make.conf"
	
	echo "$n$Green cat $dest/etc/portage/make.conf :$Reset$n"
	cat "$dest/etc/portage/make.conf"
	
	# FIXME
	# echo -n "$n$LGreen Check log and Enter for continue :$Reset"; read x
	
	##############
	
	echo "$n$Magenta emerge --sync --quiet:$Reset$n"
	chroot_exec "emerge --sync --quiet"
	
	chroot_exec "eselect news read"
	
	echo -n "$n$LGreen Check log and continue :$Reset"
	
	echo "$n$Magenta emerge -auDN --quiet @world :$Reset$n"
	chroot_exec "emerge -auDN --quiet @world"
	
	echo "$n$Magenta emerge --ask --newuse --deep --with-bdeps=y --quiet @world :$Reset$n"
	chroot_exec "emerge --ask --newuse --deep --with-bdeps=y --quiet @world"
	
	echo "$n$Magenta emerge --quiet portage :$Reset$n"
	chroot_exec "emerge --quiet portage"
	
	echo "$n$Magenta emerge --quiet app-portage/eix :$Reset$n"
	chroot_exec "emerge --quiet app-portage/eix"
	
	echo "$n$Green eix-update; eix -I -U linguas :$Reset$n"
	chroot_exec "eix-update; eix -I -U linguas"
	
	echo "$n$Green emerge --quiet --newuse gentoolkit :$Reset$n"
	chroot_exec "emerge --quiet --newuse gentoolkit"
	
	echo "$n$Green emerge --quiet sudo :$Reset$n"
	chroot_exec "emerge --quiet sudo"
	
	echo "$n$Green emerge --quiet app-misc/mc :$Reset$n"
	chroot_exec "emerge --quiet app-misc/mc"
	
	echo "$n$Green etc-update; rc-update :$Reset$n"
	chroot_exec "etc-update; rc-update"

	# Profiles
	echo "$n$Green epro show :$Reset$n"
	chroot_exec "epro show"
	
	echo "$n$Green epro flavor desktop :$Reset$n"
	chroot_exec "epro flavor desktop"
	
	# FIXME
	# echo -n "$n$LGreen Check log and Enter for continue :$Reset"; read x
	
	# Profiles
	# Once you have rebooted into Funtoo Linux, you can further customize your system to your needs by using Funtoo Profiles. A quick introduction to profiles is included below -- consult the Funtoo Profiles page for more detailed information. There are five basic profile types: arch, build, subarch, flavors and mix-ins:
	# Sub-Profile Type	Description
	# arch	Typically x86-32bit or x86-64bit, this defines the processor type and support of your system. This is defined when your stage was built and should not be changed.
	# build	Defines whether your system is a current, stable or experimental build. current systems will have newer packages unmasked than stable systems. This is defined when your stage is built and is typically not changed.
	# subarch	Defines CPU optimizations for your system. The subarch is set at the time the stage3 is built, but can be changed later to better settings if necessary. Be sure to pick a setting that is compatible with your CPU.
	# flavor	Defines the general type of system, such as server or desktop, and will set default USE flags appropriate for your needs.
	# mix-ins	Defines various optional settings that you may be interested in enabling.
	
	echo "$n$Magenta emerge --quiet mirrorselect :$Reset$n"
	chroot_exec "emerge --quiet mirrorselect"
	#chroot_exec "mirrorselect -i -o >> /etc/portage/make.conf"
	#chroot_exec "mirrorselect -i -r -o >> /etc/portage/make.conf"
	
	echo "$n$Magenta emerge --quiet boot-update :$Reset$n"
	chroot_exec "emerge --quiet boot-update"
	
	echo "$n$Green grub-install --no-floppy /dev/sda :$Reset$n"
	#chroot_exec "grub-install --target=i386-pc --no-floppy /dev/sda"
	
	# For x86-64bit systems:
	# (chroot) # grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id="Funtoo Linux [GRUB]" --recheck /dev/sda
	# (chroot) # boot-update
	# For x86-32bit systems:
	# (chroot) # grub-install --target=i386-efi --efi-directory=/boot --bootloader-id="Funtoo Linux [GRUB]" --recheck /dev/sda
	# (chroot) # boot-update
	# You only need to run grub-install when you first install Funtoo Linux, but you need to re-run boot-update every time you modify your /etc/boot.conf file
	# or add new kernels to your system. This will regenerate /boot/grub/grub.cfg so that you will have new kernels available in your GRUB boot menu,
	# the next time you reboot.
	
	# Then, edit /etc/boot.conf using nano and specify "Funtoo Linux genkernel" as the default setting at the top of the file, replacing "Funtoo Linux".
	# /etc/boot.conf should now look like this:
	# /etc/boot.conf
	#
	# boot {
	# generate grub
	# default "Funtoo Linux genkernel" 
	# timeout 3
	# }
	#
	# "Funtoo Linux" {
	# 	kernel bzImage[-v]
	# }
	#
	# "Funtoo Linux genkernel" {
	#	kernel kernel[-v]
	#	initrd initramfs[-v]
	#	params += real_root=auto 
	# }
	#
	# "Funtoo Linux better-initramfs" {
	#	kernel vmlinuz[-v]
	#	initrd /initramfs.cpio.gz
	# }
	
	# Configuring your network Wi-Fi
	
	echo "$n$Magenta emerge --quiet linux-firmware :$Reset$n"
	chroot_exec "emerge --quiet linux-firmware"
	#--newuse or --changed-use
	echo "$n$Magenta emerge --autounmask-write --quiet networkmanager :$Reset$n"
	chroot_exec "emerge --autounmask-write --quiet networkmanager"
	
	chroot_exec "etc-update"
	chroot_exec "emerge --quiet networkmanager"
	
	echo "$n$Green rc-update add NetworkManager default :$Reset$n"
	chroot_exec "rc-update add NetworkManager default"
	# Once you've completed these installation steps and have booted into Funtoo Linux, you can use the nmtui command
	# (which has an easy-to-use console-based interface) to configure NetworkManager so that it will connect (and automatically reconnect, after reboot)
	# to a Wi-Fi access point:
	
	echo "$n$Green rc-update add dhcpcd default :$Reset$n"
	chroot_exec "rc-update add dhcpcd default"
	# When you reboot, dhcpcd will run in the background and manage all network interfaces and use DHCP to acquire network addresses from a DHCP server.
}

add_to_grub () {
	
	# Build Grub menu
	
	# Old Grub
	command=$(whereis -b grub|awk '{print $2}')
	if [[ -f $command ]]
	then
	old_grub_root_dev=$(echo "find $install_folder/system.sfs"|grub|grep "(hd"| head -1)
	label_dest_partition=$(blkid "$dest_partition" -o value -s LABEL)
	
	grub_menu_lst=$( cat <<-EOF
	
	title $distro on $dest_partition
	
		root $old_grub_root_dev
		kernel /boot/kernel-debian-sources-x86-3.19.3-1~exp1 root=LABEL=$label_dest_partition splash=silent quiet
		initrd /boot/initramfs-debian-sources-x86-3.19.3-1~exp1
	
	EOF
	)
	
	
	echo "$Reset$n"
	echo "$n$Red Add below lines to /boot/grub/menu.lst ? $n$Cyan $grub_menu_lst $Reset$n"
	if [[ "no" == $(r_ask "$Green Add abowe lines to /boot/grub/menu.lst :$Orange Please answer$LRed") ]]; then
		echo "$n$Orange Skipped.$Reset$n"
	else
		echo "$grub_menu_lst" >> "/boot/grub/menu.lst"
		echo "$n$Orange ok add $Reset$n"
	fi
	fi
	
	# Grub 2
	if [[ "no" == $(r_ask "$Green grub-mkconfig -o /boot/grub/grub.cfg :$Orange Please answer$LRed") ]]; then
		echo "$n$Orange Skipped.$Reset$n"
	else
		echo "$n$Orange ok $Reset$n"
		command=$(whereis -b grub-mkconfig|awk '{print $2}')
		if [[ -x $command ]] ;then
			grub-mkconfig -o /boot/grub/grub.cfg
		else
			command=$(whereis -b grub2-mkconfig|awk '{print $2}')
			if [[ -x $command ]] ;then
				grub2-mkconfig -o /boot/grub2/grub.cfg
			else
				echo "can't find grub-mkconfig command"
			fi
		fi
	fi
}

ask_passwd () {
	
	# Saving a backup of download packages for future installations
	if [[ $backup = "yes" ]] || [[ $backup = "Yes" ]]; then
		# Make backup
		echo "$n$Green cp -fax $dest/usr/portage $backup_dir/usr/ :$Reset$n"
		cp -fax "$dest/usr/portage" "$backup_dir/usr/"
	fi
	
	echo "$n$Green add user $user_login -m -s /bin/bash:$Reset$n"
	
	chroot_exec "useradd $user_login  -m -s /bin/bash"
	chroot_exec "usermod -G users $user_login; usermod -G wheel $user_login; usermod -G sudo $user_login; usermod -G audio $user_login; usermod -G portage $user_login; usermod -G cdrom,usb"
	
	echo "$n$Green Give passwd for $user_login :$Reset$n"
	chroot_exec "passwd "$user_login""
	
	# Write some informations to $user_login home folder
	#echo "$info_for_user" > "$dest/home/$user_login/Packages_Installations.txt"
	#chmod 666 "$dest/home/$user_login/Packages_Installations.txt" # write by anybody
	
	#echo "$Powiedz_wiersz_lokomotywa" > "$dest/home/$user_login/Powiedz wiersz lokomotywa.sh"
	#chmod 777 "$dest/home/$user_login/Powiedz wiersz lokomotywa.sh"
	
	
	# write kde dolphin and kate config
	# mkdir -p "$dest/home/$user_login/.config"
	
	#echo "$dolphinrc" > "$dest/home/$user_login/.config/dolphinrc"
	#echo "$katepartrc" > "$dest/home/$user_login/.config/katepartrc"
	#echo "$kateschemarc" > "$dest/home/$user_login/.config/kateschemarc"
	#echo "$kwinrc" > "$dest/home/$user_login/.config/kwinrc"
	#echo "$plasmarc" > "$dest/home/$user_login/.config/plasmarc"
	#echo "$kdeglobals" > "$dest/home/$user_login/.config/kdeglobals"
	#echo "$plasma_org" > "$dest/home/$user_login/.config/plasma-org.kde.plasma.desktop-appletsrc"
	
	#chroot_exec "chown -R "$user_login:users" "/home/$user_login/.config""

	# Build sudoers_file
	
	#echo "$n$Green Create grouo sudo - groupadd sudo :$Reset$n"
	#chroot_exec "groupadd sudo"
	#cp -fax "$dest/etc/sudoers" "$dest/etc/sudoers.bak"
	#echo "$n$Green \$sudoers_file > "$dest/etc/sudoers" :$Reset$n"
	#echo "$sudoers_file" > "$dest/etc/sudoers"
	#chmod 0440 "$dest/etc/sudoers"
	
	echo "$n$Green Give passwd for root :$Reset$n"
	chroot_exec "passwd"
}

umount_new_root() {
	
	echo -n "$n$LGreen Enter for umount $dest_partition , or [*] for skip umonut and go in chroot:"; read x
	if [[ "$x" = "" ]];then
		
		echo "$n$Green umount $dest_partition :$Reset$n"
		fuser -k "$dest"
		umount -R "$dest"
	else
		chroot $dest /usr/bin/env HOME=/root TERM=$TERM /bin/bash --login +h
	fi
	# If the partition is "busy", you can find the cause with fuser. Reboot the computer
	
	
}

end_message () {
	
	cat <<-EOF
		$Orange
		Hi,
		You has successfully install $distro „Stage 3” Linux.
		Script is under construction so now you're on your own...
		Once you've completed these installation steps and have booted into Funtoo Linux, you can use the nmtui command
		(which has an easy-to-use console-based interface) to configure NetworkManager
		
		# Instalacja Gnome
		http://www.funtoo.org/GNOME_First_Steps
		
		epro flavor desktop
		epro mix-ins +gnome
		
		emerge gnome-light or emerge gnome
		
		# Instalacja KDE
		http://www.funtoo.org/KDE_Plasma_5
		
		epro flavor desktop
		
		emerge --ask --update --verbose --deep --newuse --with-bdeps=y --autounmask-write @world
		emerge --ask --verbose x11-base/xorg-x11
		
		epro mix-in kde-plasma-5
		
		emerge -auvDN --with-bdeps=y @world kde-apps/kde-meta:5
		time emerge -auvDN --with-bdeps=y @world kde-apps/kde-meta:5
		
		http://www.funtoo.org/Install
		http://www.funtoo.org/Funtoo_Linux_First_Steps
		$Reset$n
	EOF
}
##################

get_parameters
prepare_check_environment
ask_for_install
make_file_system_type
mount_destination
download_it
extract_it
make_backup_of_pckages
prepare_chroot_exec
configure_bootstrap
add_to_grub
ask_passwd
end_message
umount_new_root

