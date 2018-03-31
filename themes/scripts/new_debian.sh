#!/bin/bash
# new_debian.sh script
# Test Install Debian current boot.img.gz to Grub boot menu

Begin () {
get_parameters
prepare_check_environment
ask_for_install
download_it
# extract_from_iso
extract_from_tar
#extract_from_zip
extract_from_gzip
add_to_grub
end_message
}

get_parameters () {
##################
# Parameters to change


install_folder="/Debian_iso"	# ( folder for download iso file from mirros)
memdisk_folder="/boot"		# ( folder for download syslinux-6.03.tar.xz and extract memedisk)
current_type="-i386-netinst.iso"


: ${mirrors_1="http://cdimage.debian.org/debian-cd/current/i386/iso-cd/"}; file_name_1="debian-8.5.0-i386-netinst.iso" # filename willbe changed for current from file_name_3
: ${mirrors_2="http://cdimage.debian.org/debian-cd/current/i386/iso-cd/"}; file_name_2="SHA1SUMS"
: ${mirrors_3="https://www.kernel.org/pub/linux/utils/boot/syslinux/"}; file_name_3="syslinux-6.03.tar.xz"
# download syslinux-6.03.tar.xz to extract memdisk
# https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.xz
: ${mirrors_4="http://ftp.debian.org/debian/dists/stable/main/installer-i386/current/images/hd-media/"}; file_name_4="boot.img.gz"
# https://www.debian.org/mirror/list
# http://ftp.debian.org/debian/dists/
# https://www.debian.org/CD/http-ftp/
# https://www.debian.org/CD/http-ftp/#mirrors
# http://cdimage.debian.org/debian-cd/current/i386/iso-cd/SHA1SUMS
# debian-8.3.0-i386-netinst.iso
# debian-8.3.0-i386-kde-CD-1.iso
# debian-8.3.0-i386-lxde-CD-1.iso
# debian-8.3.0-i386-xfce-CD-1.iso
##################
# advanced parameters to change
MESSAGE=''
Post_MESSAGE=" Change password in console - type sudo su & passwd"
title_name=${file_name_1%.*}
if [ -z $TMPDIR ]; then TMPDIR=/tmp; fi

# End of advanced parameters to change

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

}

prepare_check_environment () {

if [ ! -t 0 ]; then				# script is executed outside the terminal
konsole --hold -e "/bin/bash \"$0\" $*"	# execute the script inside a terminal window
exit $?
fi
	
	echo "$Nline$Green Install Debian current harddisk boot.img.gz,$Orange Test beta script$Reset"
	echo "$Green # by Leszek Ostachowski (2016) GPL V2$Reset$Nline"
	
	if ! [ $(id -u) = 0 ]; then echo "$Nline$Orange This script must be run with root privileges.$Reset$Nline"
	su -c "/bin/bash \"$0\" $*"
	exit $?
	fi

	
	# Gathering informations about dowload program
	if command -v wget >/dev/null 2>&1; then
		_get_command() { wget -c "$@" ; }
	elif command -v curl >/dev/null 2>&1; then
		_get_command() { curl -f -L -O -C - "$@" ; }
	else
		echo "$Red Eroor: This script needs curl or wget, exit$Reset$Nline" >&2
		exit 2
	fi
	
}

function r_ask() {
    read -p "$1 [y]es or [N]o: " -n 1 -r
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo -n "yes" ;;
        *)     echo -n "no" ;;
    esac
}

ask_for_install () {

	if [[ "no" == $(r_ask "$Green You are as root going to download file „$file_name_1” from $mirrors_1$Nline and add it to Grub boot menu:$Nline$Cyan ( you need 400MiB free space left on root of $install_folder folder),$Orange Please answer$LRed") ]]; then
	echo "$Nline$Orange ok, next time$Reset$Nline"; exit 0
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
	
	if [ -f $file_name_2 ]; then
		echo " file $file_name_2 exist$Reset$Nline"
		if ! [[ "no" == $(r_ask "$Green Download again:,$Orange Please answer$LRed") ]]; then
			echo "$Nline$Green Redownload $mirrors_2$file_name_2 =$Reset$Nline"
			get_it "$mirrors_2" "$file_name_2"
			if ! [ $? = 0 ]; then echo "$Nline $Red Error: download, exit 1 $Reset$Nline"; exit 1; else echo "$Green ok"; fi
			MESSAGE+="$Nline$Green $(( mn+=1 )). Redownload $file_name_2 to $install_folder folder $Reset$Nline"
		else
			echo "$Nline$Orange Skipped.$Reset$Nline"
			MESSAGE+="$Nline$Orange $(( mn+=1 )). Skipped redownload $file_name_2 to $install_folder folder $Reset$Nline"
		fi
		
	else
		echo "$Nline$Green download $mirrors_1$file_name_2 =$Reset$Nline"
		get_it "$mirrors_1" "$file_name_2"
		if ! [ $? = 0 ]; then echo "$Nline $Red Error: download, exit 1 $Reset$Nline"; exit 1; else echo "$Green ok"; fi
		MESSAGE+="$Nline$Green $(( mn+=1 )). Download $file_name_2 to $install_folder folder $Reset$Nline"
		
		
		
	fi
	
	# Get name of current
	cat "$file_name_2"|grep -e "$current_type"| head -1 > "sha1_sums_$title_name.txt"
	read -r sha1 file_name_1 < "sha1_sums_$title_name.txt"
	
	
	if [ -f $file_name_1 ]; then
		echo " file $file_name_1 exist$Reset$Nline"
		if ! [[ "no" == $(r_ask "$Green Download again:,$Orange Please answer$LRed") ]]; then
			echo "$Nline$Green Redownload $mirrors$file_name_1 =$Reset$Nline"
			get_it "$mirrors_1" "$file_name_1"
			if ! [ $? = 0 ]; then echo "$Nline $Red Error: download, exit 1 $Reset$Nline"; exit 1; else echo "$Nline$Green ok$Reset$Nline"; fi
			MESSAGE+="$Nline$Green $(( mn+=1 )). Redownload $file_name_1 to $install_folder folder $Reset$Nline"
		else
			echo "$Nline$Orange Skipped.$Reset$Nline"
			MESSAGE+="$Nline$Orange $(( mn+=1 )). Skipped redownload $file_name_1 to $install_folder folder $Reset$Nline"
		fi
	else
		echo "$Nline$Green download $mirrors$file_name_1 =$Reset$Nline"
		get_it "$mirrors_1" "$file_name_1"
		if ! [ $? = 0 ]; then echo "$Nline $Red Error: download, exit 1 $Reset$Nline"; exit 1; else echo "$Nline$Green ok$Reset$Nline"; fi
		MESSAGE+="$Nline$Green $(( mn+=1 )). Download $file_name_1 to $install_folder folder $Reset$Nline"
	fi
	
	#  check sums of downloaded files
	
	if [ -e "md5_sums_$title_name.txt" ]
	then
	  echo "$Nline$Green check md5 sums =$Reset$Nline"
	  check_sums="md5sum -c "md5_sums_$title_name.txt""
	fi
	
	if [ -e "sha1_sums_$title_name.txt" ]
	then
	  echo "$Nline$Green check sha1 sums =$Reset$Nline"
	  check_sums="sha1sum -c "sha1_sums_$title_name.txt""
	fi
	
	if [ -e "sha_256_sums_$title_name.txt" ]
	then
	  echo "$Nline$Green check sha256 sums =$Reset$Nline"
	  check_sums="sha256sum -c "sha_256_sums_$title_name.txt""
	fi
	
	$check_sums
	if ! [ $? = 0 ]
	then echo "$Nline$Red Error: check sums of $file_name_1 $Reset$Nline"
	
	 if [[ "no" == $(r_ask "$Green Continue - Y or $Red Remove  files ! : "$file_name_1" "$file_name_2" "sha1_sums_$title_name.txt" - n$Nline$Orange Please answer$LRed") ]]
	 then  rm -f "$file_name_1" "$file_name_2" "sha1_sums_$title_name.txt" ; echo "$Nline $Red exit 1"; exit 1
	 fi
	 MESSAGE+="$Nline$Red$Blink $(( mn+=1 )). Error: check sums of $file_name_1 $Reset$Nline"
	
	else
	
	 echo "$Nline$Green check sums of $file_name_1 ok$Reset$Nline"
	 MESSAGE+="$Nline$Green $(( mn+=1 )). Check sumsf $file_name_1 ok $Reset$Nline"
	
	fi
	
	if [ -f $file_name_3 ]; then
		echo " file $file_name_3 exist$Reset$Nline"
		if ! [[ "no" == $(r_ask "$Green Download again:,$Orange Please answer$LRed") ]]; then
			echo "$Nline$Green Redownload "$mirrors_3" "$file_name_3" =$Reset$Nline"
			get_it "$mirrors_3" "$file_name_3"
			if ! [ $? = 0 ]; then echo "$Nline $Red Error: download, exit 1 $Reset$Nline"; exit 1; else echo "$Nline$Green ok$Reset$Nline"; fi
			MESSAGE+="$Nline$Green $(( mn+=1 )). Redownload $file_name_3 to $install_folder folder $Reset$Nline"
		else
			echo "$Nline$Orange Skipped.$Reset$Nline"
			MESSAGE+="$Nline$Orange $(( mn+=1 )). Skipped redownload $file_name_3 to $install_folder folder $Reset$Nline"
		fi
	else
		echo "$Nline$Green Download "$mirrors_3" "$file_name_3" =$Reset$Nline"
		get_it "$mirrors_3" "$file_name_3"
		if ! [ $? = 0 ]; then echo "$Nline $Red Error: download, exit 1 $Reset$Nline"; exit 1; else echo "$Nline$Green ok$Reset$Nline"; fi
		MESSAGE+="$Nline$Green $(( mn+=1 )). Download $file_name_3 to $install_folder folder $Reset$Nline"
		
	fi
	
	if [ -f $file_name_4 ]; then
		echo " file $file_name_4 exist$Reset$Nline"
		if ! [[ "no" == $(r_ask "$Green Download again:,$Orange Please answer$LRed") ]]; then
			echo "$Nline$Green Redownload "$mirrors_4" "$file_name_4" =$Reset$Nline"
			get_it "$mirrors_4" "$file_name_4"
			if ! [ $? = 0 ]; then echo "$Nline $Red Error: download, exit 1 $Reset$Nline"; exit 1; else echo "$Nline$Green ok$Reset$Nline"; fi
			MESSAGE+="$Nline$Green $(( mn+=1 )). Redownload $file_name_4 to $install_folder folder $Reset$Nline"
		else
			echo "$Nline$Orange Skipped.$Reset$Nline"
			MESSAGE+="$Nline$Orange $(( mn+=1 )). Skipped redownload $file_name_4 to $install_folder folder $Reset$Nline"
		fi
	else
		echo "$Nline$Green Download "$mirrors_4" "$file_name_4" =$Reset$Nline"
		get_it "$mirrors_4" "$file_name_4"
		if ! [ $? = 0 ]; then echo "$Nline $Red Error: download, exit 1 $Reset$Nline"; exit 1; else echo "$Nline$Green ok"$Reset$Nline; fi
		MESSAGE+="$Nline$Green $(( mn+=1 )). Download $file_name_4 to $install_folder folder $Reset$Nline"
		
	fi
	
	
}

extract_from_iso() {

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

extract_from_tar() {

	echo "$Nline$Green Extract from $file_name_3 memdisk: $Reset$Nline"
	tar -xvf $file_name_3 syslinux-6.03/bios/memdisk/memdisk
	if ! [ $? = 0 ]; then echo "$Nline $Red Error: Extract from tar, exit 1 $Reset$Nline"; exit 1
	else
	MESSAGE+="$Nline$Green $(( mn+=1 )). Extract memdisk from $file_name_3 $Reset$Nline"
	fi
	echo "$Nline$Green mv syslinux-6.03/bios/memdisk/memdisk $memdisk_folder/ : $Reset$Nline"
	mv syslinux-6.03/bios/memdisk/memdisk $memdisk_folder/
	MESSAGE+="$Nline$Green $(( mn+=1 )). Install memdisk in $memdisk_folder/  $Reset$Nline"
	rm -fr syslinux-6.03
	
}

extract_from_zip () {

	echo "$Nline$Green Extract from $file_name_1: $Reset$Nline"
	unzip $file_name_1
	if ! [ $? = 0 ]; then echo "$Nline $Red Error: Extract from $file_name_1, exit 1 $Reset$Nline"; exit 1
	else
	MESSAGE+="$Nline$Green $(( mn+=1 )). Extract from $file_name_1 to $install_folder $Reset$Nline"
	fi

}

extract_from_gzip () {

	echo "$Nline$Green Change compression from gzip to zip of $file_name_4 for boot from Grub 2: $Reset$Nline"
	gzip -d $file_name_4
	if ! [ $? = 0 ]; then echo "$Nline $Red Error: Extract from $file_name_4, exit 1 $Reset$Nline"; exit 1;fi
	
	# change compression to zip for pass Grub 2 bug?
	zip $file_name_4 boot.img
	if ! [ $? = 0 ]; then echo "$Nline $Red Error: zip $file_name_4, exit 1 $Reset$Nline"; exit 1
	else
	MESSAGE+="$Nline$Green $(( mn+=1 )). Change compression from gzip to zip of $file_name_4 in $install_folder $Reset$Nline"
	fi
	rm -f boot.img

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
	grub_root_dev=$(echo "find $install_folder/$file_name_1"|grub|grep -e "(hd"| head -1)
	
	# Grub "/boot/grub/menu.lst"
	grub_menu_lst=$( cat <<-EOF
	
	title Debian harddisk boot.img.gz
		root $grub_root_dev
		kernel $memdisk_folder/memdisk harddisk
		initrd $install_folder/$file_name_1
		
	EOF
	)
	
	echo "$Reset$Nline"
	echo "$Nline$Red Add below lines to /boot/grub/menu.lst : $Nline$Cyan $grub_menu_lst $Reset$Nline"
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
	if [[ -f $command1 ]] || [[ -f $command2 ]]; then
	
	# Grub 2 "/etc/grub.d/40_custom"
	grub_40_custom=$( cat <<-EOF
	
	menuentry "Debian harddisk boot.img.gz" --class cd_boot {
		
		search --file --no-floppy --set=root $install_folder/$file_name_1
		linux16 $memdisk_folder/memdisk harddisk
		initrd16 $install_folder/$file_name_1
		
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
		command=$(whereis -b grub-mkconfig|awk '{print $2}')
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
		 $(( mn+=1 )). To run: Reboot and select menuentry - Debian current harddisk boot.img.gz
		
		6.3.1.4. Looking for the Debian Installer ISO Image
		When installing via the hd-media method, there will be a moment where you need to find and mount the Debian Installer iso image in order to get the rest of the installation files.
		The component iso-scan does exactly this. At first, iso-scan automatically mounts all block devices (e.g. partitions) which have some known filesystem on them and sequentially searches for filenames ending with .iso (or .ISO for that matter).
		Beware that the first attempt scans only files in the root directory and in the first level of subdirectories (i.e. it finds /whatever.iso, /data/whatever.iso, but not /data/tmp/whatever.iso). After an iso image has been found,
		iso-scan checks its content to determine if the image is a valid Debian iso image or not. In the former case we are done, in the latter iso-scan seeks for another image.
		In case the previous attempt to find an installer iso image fails, iso-scan will ask you whether you would like to perform a more thorough search. This pass doesn't just look into the topmost directories, but really traverses whole filesystem.
		If iso-scan does not discover your installer iso image, reboot back to your original operating system and check if the image is named correctly (ending in .iso), if it is placed on a filesystem recognizable by debian-installer, and if it is not corrupted (verify the checksum).
		Experienced Unix users could do this without rebooting on the second console. https://www.debian.org/releases/stable/i386/ch06s03.html.en
		$Green$Blink The end.$Reset
	EOF
}
##################
Begin
