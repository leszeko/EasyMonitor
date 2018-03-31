#!/bin/bash
# new_install_android.sh script
# Test Install Android Linux into a folder, script for Easy Monitor theme - Test beta,

Begin () {
prepare_check_environment
get_parameters
ask_for_install
download_it
extract_from_iso
add_to_grub
end_message
}

get_parameters () {
##################
# Parameters to change

install_folder="Android-x86
Last Update: 2017-04-25 13:12 UTC

[Android-x86]

    OS Type: Linux
    Based on: Android
    Origin: USA
    Architecture: i386, x86_64
    Desktop: Android
    Category: Desktop, Live Medium
    Release Model: Fixed
    Init: other
    Status: Active
    Popularity: 30 (324 hits per day) 

Android-x86 is an unofficial initiative to port Google's Android mobile operating system to run on devices powered by Intel and AMD x86 processors, rather than RISC-based ARM chips. The project began as a series of patches to the Android source code to enable Android to run on various netbooks and ultra-mobile PCs, particularly the ASUS Eee PC.

Popularity (hits per day): 12 months: 29 (369), 6 months: 30 (324), 3 months: 37 (257), 4 weeks: 39 (265), 1 week: 42 (266)

Average visitor rating: 6.73/10 from 11 review(s).


Android-x86 Summary
Distribution 	Android-x86
Home Page 	http://www.android-x86.org/
Mailing Lists 	http://groups.google.com/group/android-x86
User Forums 	--
Alternative User Forums 	LinuxQuestions.org
Documentation 	http://www.android-x86.org/documents
Screenshots 	http://www.android-x86.org/screenshot • DistroWatch Gallery
Screencasts 	
Download Mirrors 	http://www.android-x86.org/download • LinuxTracker.org
Bug Tracker 	http://code.google.com/p/android-x86/issues/list
Related Websites 	Wikipedia
Reviews 	6.x: DistroWatch
4.x: DistroWatch • Everyday Linux User • Linux User • TalLinux (Italian) • Linux Insider • LinuxBSDos • Dedoimedo
2.x: Land of Droid
Where To Buy 	OSDisc.com (sponsored link)

Recent Related News and Releases
  Releases, download links and checksums:
 • 2017-04-25: Distribution Release: Android-x86 6.0-r3"

: ${mirrors_1:="http://netcologne.dl.sourceforge.net/project/android-x86/Release%204.4/"}; file_name_1="android-x86-4.4-r4.iso"
#http://netcologne.dl.sourceforge.net/project/android-x86/Release%204.4/android-x86-4.4-r4.iso
MESSAGE=''
# End of parameters to change
##################
}

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
	
	echo "$Nline$Green Install Android Linux into a folder and add to Grub boot menu from another distribution,..$Orange Test beta script$Reset"
	echo "$Green # by Leszek Ostachowski (2016) GPL V2$Reset$Nline"
	
	if ! [ $(id -u) = 0 ]; then echo "$Nline$Orange This install Android Linux script must be run with root privileges.$Reset$Nline"
	su -c "/bin/bash \"$0\" $*"
	exit $?
	fi
	
	# Gathering informations about dowload program
	if command -v wget >/dev/null 2>&1; then
		_get_command() { wget -O- --secure-protocol=tlsv1_2 "$@" ; }
	elif command -v curl >/dev/null 2>&1; then
		_get_command() { curl -fL "$@" ; }
	else
		echo "$Red Eroor: This script needs curl or wget, exit$Reset$Nline" >&2
		exit 2
	fi
	
	if [ -z $TMPDIR ]; then TMPDIR=/tmp; fi
	
}

function r_ask () {
    read -p "$1 [y]es or [N]o: " -n 1 -r
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo -n "yes" ;;
        *)     echo -n "no" ;;
    esac
}

ask_for_install () {
	
	if [[ "no" == $(r_ask "$Green You are as root going to install a new Android Linux into a folder:$Cyan $install_folder ( you need 1GB free space left on root "/" ),$Orange Please answer$LRed") ]]; then
	echo "$Nline$Orange ok, next time, exit$Reset$Nline"; exit 0
	fi
	echo "$Reset$Nline"
}

get_it () {
	
	# Build download command, mirror and path
	local mirror= mirrors="$1" file="$2"
	shift
	for mirror in $mirrors; do
		_get_command "$mirror$file" && return 0
	done
	return 1
}


download_it () {
	
	mkdir -p "$install_folder"
	if ! [ $? = 0 ]; then
		echo "$Red Error: Cannot creat folder $install_folder, exit$Reset$Nline"
		exit 1
	fi
	cd "$install_folder"
	
	if [ -f $file_name_1 ]; then
		echo " file $file_name_1 exist$Reset$Nline"
		if ! [[ "no" == $(r_ask "$Green Download again:,$Orange Please answer$LRed") ]]; then
			echo "$Nline$Green Redownload $mirrors$file_name_1 =$Reset$Nline"
			get_it "$mirrors_1" "$file_name_1" > "$file_name_1"
			if ! [ $? = 0 ]; then echo "$Nline $Red Error: download, exit 1 $Reset$Nline"; exit 1; else echo "$Green ok"; fi
			MESSAGE+="$Nline$Green $(( mn+=1 )). Redownload $file_name_1 to $install_folder folder $Reset$Nline"
		else
			echo "$Nline$Orange Skipped.$Reset$Nline"
			MESSAGE+="$Nline$Orange $(( mn+=1 )). Skipped redownload $file_name_1 to $install_folder folder $Reset$Nline"
		fi
	else
		echo "$Nline$Green download $mirrors$file_name_1 =$Reset$Nline"
		get_it "$mirrors_1" "$file_name_1" > "$file_name_1"
		if ! [ $? = 0 ]; then echo "$Nline $Red Error: download, exit 1 $Reset$Nline"; exit 1; else echo "$Green ok"; fi
		MESSAGE+="$Nline$Green $(( mn+=1 )). Download $file_name_1 to $install_folder folder $Reset$Nline"
	fi
	
}

extract_from_iso () {

	mkdir -p "/mnt/$file_name_1"
	mount -o loop "$install_folder/$file_name_1" "/mnt/$file_name_1"
	cp -fr "/mnt/$file_name_1/"* "$install_folder/"
	if ! [ $? = 0 ]; then echo "$Nline $Red Error: Extract from iso, exit 1 $Reset$Nline"; exit 1
	else
	MESSAGE+="$Nline$Green $(( mn+=1 )). Extract from $file_name_1 isolinux folder to $install_folder $Reset$Nline"
	fi
	umount "/mnt/$file_name_1"
	cd "/mnt/"
	rm -df "$file_name_1"
	cd "$install_folder"
	
}

add_to_grub () {

	# Device naming has changed between GRUB Legacy and GRUB. Partitions are numbered from 1 instead of 0 while drives are still numbered from 0,
	# and prefixed with partition-table type. For example, /dev/sda1 would be referred to as (hd0,msdos1) (for MBR) or (hd0,gpt1) (for GPT).
	# ( Old Grub start count disks from 0, partitions from 0)
	# ( New Grub start count disks from 0, partitions from 1)
	
	#  Old Grub
	command=$(whereis -b grub|awk '{print $2}')
	if [[ -f $command ]]
	then
	
	grub_root_dev=$(echo "find $install_folder/system.sfs"|grub|grep "(hd"| head -1)
	
	# Grub "/boot/grub/menu.lst"
	grub_menu_lst=$( cat <<-EOF
	
	title Android-x86 4.4-r4 Live
		root $grub_root_dev
		kernel $install_folder/kernel quiet root=$install_folder/system.sfs root=/dev/ram0 androidboot.hardware=android_x86 SRC=$install_folder
		initrd $install_folder/initrd.img

	title Android-x86 4.4-r4 (Debug nomodeset)
		root $grub_root_dev
		kernel $install_folder/kernel nomodeset vga=788 root=$install_folder/system.sfs root=/dev/ram0 androidboot.hardware=android_x86 DEBUG=2 SRC=$install_folder
		initrd $install_folder/initrd.img
		
	title Android-x86 4.4-r4 (Debug video=LVDS-1:d)
		root $grub_root_dev
		kernel $install_folder/kernel video=LVDS-1:d root=$install_folder/system.sfs root=/dev/ram0 androidboot.hardware=android_x86 DEBUG=2 SRC=$install_folder
		initrd $install_folder/initrd.img
		
	title Android-x86 4.4-r4 (install to harddisk)
		root $grub_root_dev
		kernel $install_folder/kernel root=$install_folder/system.sfs root=/dev/ram0 androidboot.hardware=android_x86 INSTALL=1 DEBUG= SRC=$install_folder
		initrd=$install_folder/initrd.img
		
	EOF
	)
	
	echo "$Reset$Nline"
	echo "$Nline$Red Add below lines to /boot/grub/menu.lst ? $Nline$Cyan $grub_menu_lst $Reset$Nline"
	if [[ "no" == $(r_ask "$Green Add abowe lines to /boot/grub/menu.lst :,$Orange Please answer$LRed") ]]; then
		echo "$Nline$Orange Skipped.$Reset$Nline"
		MESSAGE+="$Nline$Orange $(( mn+=1 )). Skipped add belowe lines to /boot/grub/menu.lst:$Nline $grub_menu_lst $Nline $Reset"
	else
		echo "$grub_menu_lst" >> "/boot/grub/menu.lst"
		echo "$Nline$Orange ok add $Reset$Nline"
		MESSAGE+="$Nline$Green $(( mn+=1 )). Add belowe lines to /boot/grub/menu.lst:$Nline $grub_menu_lst $Nline $Reset"
	fi
	
	fi
	
	# New Grub
	
	command1=$(whereis -b grub-mkconfig|awk '{print $2}')
	command2=$(whereis -b grub2-mkconfig|awk '{print $2}')
	if [[ -f $command1 ]] || [[ -f $command2 ]] ;then
	
	# Grub 2 "/etc/grub.d/40_custom"
	grub_40_custom=$( cat <<-EOF
	
	menuentry 'Android-x86 4.4-r4 Live' --class android-x86 {
	search --file --no-floppy --set=root $install_folder/system.sfs
	linux $install_folder/kernel root=/dev/ram0 androidboot.hardware=android_x86 quiet DATA=
	initrd $install_folder/initrd.img
	}
	
	menuentry 'Android-x86 4.4-r4 DEBUG mode' --class android-x86 {
	search --file --no-floppy --set=root $install_folder/system.sfs
	linux $install_folder/kernel root=/dev/ram0 androidboot.hardware=android_x86 DATA= DEBUG=2
	initrd $install_folder/initrd.img
	}
	
	menuentry 'Android-x86 4.4-r4 Installation' --class android-x86 {
	search --file --no-floppy --set=root $install_folder/system.sfs
	linux $install_folder/kernel root=/dev/ram0 androidboot.hardware=android_x86 DEBUG= INSTALL=1
	initrd $install_folder/initrd.img
	}
	
	EOF
	)
	
	echo "$Nline$Red Add below lines to /etc/grub.d/40_custom ? $Nline$Cyan $grub_40_custom $Reset$Nline"
	if [[ "no" == $(r_ask "$Green Add abowe lines to /etc/grub.d/40_custom and grub-mkconfig -o /boot/grub/grub.cfg :,$Orange Please answer$LRed") ]]; then
		echo "$Nline$Orange Skipped.$Reset$Nline"
		MESSAGE+="$Nline$Orange $(( mn+=1 )). Skipped add belowe lines to /etc/grub.d/40_custom:$Nline $grub_40_custom $Nline $Reset"
	else
		echo "$grub_40_custom" >> "/etc/grub.d/40_custom"
		echo "$Nline$Orange ok add $Reset$Nline"
		
		if [[ -f $command1 ]] ;then
			grub-mkconfig -o /boot/grub/grub.cfg
		elif [[ -f $command2 ]] ;then
			grub2-mkconfig -o /boot/grub2/grub.cfg
		fi
		MESSAGE+="$Nline$Green $(( mn+=1 )). Add belowe lines to /etc/grub.d/40_custom:$Nline $grub_40_custom $Nline $Reset"
	fi
	
	fi
	
}

end_message () {
	
	cat <<-EOF
		$Green
		 Hi,
		 You has successfully:
		 $MESSAGE
		 $Magenta
		 $(( mn+=1 )). To run:$Nline - Reboot and select menuentry Android-x86 4.4-r4 ...
		$Green$Blink The end.$Reset
		
	EOF
}
##################
Begin

